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
		return nil, &UnknownEventError{}
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

	tag := ""
	notag := ""
	for _, client := range *clients {
		if slices.Contains(client.Tags, "bbrain") {
			tag = "bbrain"
			notag = "work"
			break
		}
		if slices.Contains(client.Tags, "work") {
			tag = "work"
			notag = "bbrain"
			break
		}
	}

	if tag == "" {
		slog.Info("No relevant tag found, skipping workspace move")
		return
	}

	hyprctl.GetClientWithTag(notag)

	slog.Info("Moving tag", "tag", "pin:"+tag, "to workspace", ws.Name)
	hyprctl.MoveTagToWorkspace("pin:"+tag, ws)
}

func handleEvent(line string) {
	ev, err := parseEvent(line)
	if err != nil {
		if _, ok := err.(*InvalidEventError); ok {
			slog.Error("Invalid event data", "error", err, "line", line)
		} else if _, ok := err.(*UnknownEventError); ok {
			slog.Debug("Unknown event type", "error", err, "line", line)
		}
		return
	}

	switch e := ev.(type) {
	case WorkspaceV2Event:
		if e.WorkspaceId%2 == 1 {
			triggerPinnedMove(nil)
		}
	case OpenwindowEvent, ClosewindowEvent:
		hyprctl.UpdateClients()
	case CreateWorkspaceV2Event, DestroyWorkspaceV2Event:
		hyprctl.UpdateWorkspaces()
	case MonitorAddedV2Event, MonitorRemovedV2Event:
		hyprctl.UpdateMonitors()
	default:
		slog.Debug(fmt.Sprintf("Unhandled event type: %T", e))
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

	go func() {
		scanner := bufio.NewScanner(conn)
		for scanner.Scan() {
			line := scanner.Text()
			handleEvent(line)
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

	<-exit
	fmt.Println("\nInterrupt received. Exiting.")
	close(done)
}
