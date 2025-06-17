package main

import (
	"bufio"
	"flag"
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"slices"
	"strings"
	"syscall"
	"time"
)

type UnknownEventError struct {
	Name string
	Data string
}

func (e *UnknownEventError) Error() string {
	return fmt.Sprintf("unknown event: %s, data: %s", e.Name, e.Data)
}

type InvalidEventError struct {
	Data string
}

func (e *InvalidEventError) Error() string {
	return fmt.Sprintf("invalid event data: %s", e.Data)
}

var ctrlSock = os.Getenv("XDG_RUNTIME_DIR") +
	"/hypr/" + os.Getenv("HYPRLAND_INSTANCE_SIGNATURE") +
	"/.socket.sock"

var hyprctl = HyprCtl{CtrlSock: ctrlSock}

func parseEvent(raw string) (HyprlandEvent, error) {
	slog.Debug("Parsing event", "raw", raw)
	p := strings.SplitN(raw, ">>", 2)
	if len(p) < 2 {
		return nil, &InvalidEventError{Data: raw}
	}
	ev := p[0]
	data := p[1]

	switch ev {
	case "workspace":
		slog.Debug("WorkspaceEvent", "data", data)
		return WorkspaceEvent{}.SetData(data)
	case "workspacev2":
		slog.Debug("WorkspaceV2Event", "data", data)
		return WorkspaceV2Event{}.SetData(data)
	case "openwindow":
		slog.Debug("OpenwindowEvent", "data", data)
		return OpenwindowEvent{}.SetData(data)
	case "closewindow":
		slog.Debug("ClosewindowEvent", "data", data)
		return ClosewindowEvent{}.SetData(data)
	default:
		return nil, &UnknownEventError{Name: ev, Data: data}
	}
}

func triggerPinnedMove(ws *Workspace) {
	/*
		1. Get the active workspace if not provided
		2. Get all clients in the workspace
		3. Check if any client has the "bbrain" or "work" tag
		4. If found, move the tag to the workspace
		5. Search for any pin:tag in the workspace that does not match the found tag
		6. If found, search for a client with that tag without the pin: prefix
		7. If found, move that client to the workspace
		5. If not found, log a message and exit
	*/
	if ws == nil {
		w, err := hyprctl.GetActiveWorkspace()
		if err != nil {
			slog.Error("Failed to get active workspace", "error", err)
			return
		}
		ws = w
	}

	clients, err := hyprctl.GetClientsInWorkspace(ws)
	if err != nil {
		slog.Error("Failed to get clients in workspace", "error", err)
		return
	}

	var tagWeight map[string]int = make(map[string]int)

	for _, client := range *clients {
		for _, tag := range client.Tags {
			if strings.HasPrefix(tag, "pin:") {
				continue
			}
			if _, ok := tagWeight[tag]; !ok {
				tagWeight[tag] = 0
			}
			tagWeight[tag]++
		}
	}

	mainTag := struct {
		name   string
		weight int
	}{
		name:   "",
		weight: 0,
	}
	for tag, weight := range tagWeight {
		if weight > mainTag.weight {
			mainTag.name = tag
			mainTag.weight = weight
		}
	}
	slog.Debug(fmt.Sprintf("%#v", tagWeight))

	if mainTag.name == "" {
		slog.Info("No relevant tag found, skipping workspace move")
		return
	}

	delete(tagWeight, mainTag.name)

	for _, c := range *clients {
		if slices.Contains(c.Tags, "pin:"+mainTag.name) || slices.Contains(c.Tags, mainTag.name) {
			slog.Info("Skipping client", "client", c.Title, "tag", mainTag.name)
			continue
		}
		for _, tag := range c.Tags {
			if !strings.HasPrefix(tag, "pin:") {
				slog.Info("Not moving client", "client", c.Title)
				continue
			}
			search := strings.TrimPrefix(tag, "pin:")
			nc, err := hyprctl.GetClientWithTag(search)
			if err != nil {
				slog.Error("Failed to get client with tag", "tag", search, "error", err)
				continue
			}
			slog.Info("Moving client", "client", c.Title, "tag", search, "to workspace", nc.Workspace.Id)
			hyprctl.MoveClientToWorkspace(&c, nc.Workspace.Full(&hyprctl))
			break
		}
		// If we reach here, it means we didn't find a pin:tag for this client, so we move it to workspace 9
		slog.Info("Moving client to default workspace")
		wid := 9
		if ws.Id == wid {
			wid = 4
		}
		defaultWorkspace, err := hyprctl.GetWorkspaceById(wid)
		if err != nil {
			slog.Error("Failed to get default workspace", "id", 4, "error", err)
			continue
		}
		hyprctl.MoveClientToWorkspace(&c, defaultWorkspace)
	}

	slog.Info("Moving tag", "tag", "pin:"+mainTag.name, "to workspace", ws.Name)
	hyprctl.MoveTagToWorkspace("pin:"+mainTag.name, ws)
}

func handleEvent(ev HyprlandEvent) {
	slog.Debug("Received event", "type", fmt.Sprintf("%T", &ev))
	switch e := ev.(type) {
	case WorkspaceV2Event:
		if e.WorkspaceId%2 != 1 {
			return
		}
		ws, err := hyprctl.GetWorkspaceById(e.WorkspaceId)
		if err != nil {
			slog.Error("Failed to get workspace by ID", "id", e.WorkspaceId, "error", err)
			return
		}
		triggerPinnedMove(ws)
	case OpenwindowEvent, ClosewindowEvent:
		hyprctl.UpdateClients()
	case CreateWorkspaceV2Event, DestroyWorkspaceV2Event, MoveWorkspaceV2Event:
		hyprctl.UpdateWorkspaces()
	case MonitorAddedV2Event, MonitorRemovedV2Event:
		hyprctl.UpdateMonitors()
	case ClientTagUpdatedEvent:
		slog.Info("Client tag updated", "client", e.Client, "added", e.Added, "removed", e.Removed)
		triggerPinnedMove(e.Client.Workspace.Full(&hyprctl))
	default:
		slog.Debug(fmt.Sprintf("Unhandled event type: %T", &e))
	}
}

func main() {
	debug := flag.Bool("debug", false, "Enable debug logging")
	flag.Parse()

	level := slog.LevelInfo
	if *debug {
		level = slog.LevelDebug
	}

	logger := slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: level}))
	slog.SetDefault(logger)

	eventSock := os.Getenv("XDG_RUNTIME_DIR") +
		"/hypr/" + os.Getenv("HYPRLAND_INSTANCE_SIGNATURE") +
		"/.socket2.sock"

	conn, err := net.Dial("unix", eventSock)
	if err != nil {
		slog.Error("Failed to connect to Hyprland IPC socket", "error", err)
		os.Exit(1)
	}
	defer conn.Close()

	// Handle Ctrl+C (SIGINT)
	exit := make(chan os.Signal, 1)
	signal.Notify(exit, syscall.SIGINT, syscall.SIGTERM)

	refreshPin := make(chan os.Signal, 1)
	signal.Notify(refreshPin, syscall.SIGUSR1)

	done := make(chan struct{})
	eventChan := make(chan HyprlandEvent)

	go func() {
		scanner := bufio.NewScanner(conn)
		for scanner.Scan() {
			line := scanner.Text()

			ev, err := parseEvent(line)
			if err != nil {
				if _, ok := err.(*InvalidEventError); ok {
					slog.Error(err.Error())
				} else if _, ok := err.(*UnknownEventError); ok {
					slog.Debug(err.Error())
				}
			}
			eventChan <- ev
		}
		if err := scanner.Err(); err != nil {
			fmt.Fprintf(os.Stderr, "Scanner error: %v\n", err)
		}
		close(done)
	}()

	go func() {
		for {
			<-refreshPin
			slog.Info("Received SIGUSR1, triggering pinned move")
			triggerPinnedMove(nil)
		}
	}()

	go func() {
		for {
			ev := <-eventChan
			handleEvent(ev)
		}
	}()

	go func() {
		for {
			time.Sleep(1 * time.Second)
			o := hyprctl.Clients()
			n, err := hyprctl.UpdateClients()
			if err != nil {
				slog.Error("Failed to update clients", "error", err)
				continue
			}
			DispatchClientTagUpdated(o, n, eventChan)

			hyprctl.UpdateWorkspaces()
		}
	}()

	<-exit
	fmt.Println("\nInterrupt received. Exiting.")
	close(done)
}
