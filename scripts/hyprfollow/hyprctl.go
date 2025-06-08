package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log/slog"
	"net"
	"slices"
)

type HyprCtl struct {
	CtrlSock   string
	monitors   *[]Monitor
	workspaces *[]Workspace
	clients    *[]Client
}

func (h *HyprCtl) UpdateMonitors() (*[]Monitor, error) {
	cmd := "monitors"
	monitors, err := runCmd[[]Monitor](h, cmd)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch monitors: %w", err)
	}
	h.monitors = monitors
	return h.monitors, nil
}

func (h *HyprCtl) UpdateWorkspaces() (*[]Workspace, error) {
	cmd := "workspaces"
	workspaces, err := runCmd[[]Workspace](h, cmd)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch workspaces: %w", err)
	}
	h.workspaces = workspaces
	return h.workspaces, nil
}

func (h *HyprCtl) UpdateClients() (*[]Client, error) {
	cmd := "clients"
	clients, err := runCmd[[]Client](h, cmd)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch clients: %w", err)
	}
	h.clients = clients
	return h.clients, nil
}

func (h *HyprCtl) Monitors() *[]Monitor {
	if h.monitors == nil {
		_, err := h.UpdateMonitors()
		if err != nil {
			panic(fmt.Errorf("failed to init monitors: %w", err))
		}
	}
	return h.monitors
}

func (h *HyprCtl) Workspaces() *[]Workspace {
	if h.workspaces == nil {
		_, err := h.UpdateWorkspaces()
		if err != nil {
			panic(fmt.Errorf("failed to init workspaces: %w", err))
		}
	}
	return h.workspaces
}

func (h *HyprCtl) Clients() *[]Client {
	if h.clients == nil {
		_, err := h.UpdateClients()
		if err != nil {
			panic(fmt.Errorf("failed to init clients: %w", err))
		}
	}
	return h.clients
}

func runCmd[T any](h *HyprCtl, cmd string) (*T, error) {
	slog.Debug("Running command: %s\n", cmd)
	conn, err := net.Dial("unix", ctrlSock)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to Hyprland IPC socket: %w", err)
	}
	defer conn.Close()

	cmd = fmt.Sprintf("j/%s", cmd)
	_, err = fmt.Fprintf(conn, cmd)
	if err != nil {
		return nil, fmt.Errorf("failed to send command to Hyprland IPC socket: %w", err)
	}
	var r T

	d := json.NewDecoder(conn)
	err = d.Decode(&r)
	if err != nil {
		scanner := bufio.NewScanner(d.Buffered())
		hasMsg := scanner.Scan()
		if !hasMsg {
			return nil, fmt.Errorf("failed to decode JSON response from Hyprland IPC socket: %w", err)
		}

		return nil, fmt.Errorf("failed to run command `%s`: %s", cmd, scanner.Text())
	}

	return &r, nil
}

func (h *HyprCtl) GetActiveWorkspace() (*Workspace, error) {
	cmd := "activeworkspace"
	result, err := runCmd[Workspace](h, cmd)
	if err != nil {
		return nil, fmt.Errorf("failed to get active workspace: %w", err)
	}
	return result, nil
}

func (h *HyprCtl) GetClientWithTag(tag string) (*Client, error) {
	for _, client := range *h.Clients() {
		if slices.Contains(client.Tags, tag) {
			return &client, nil
		}
	}

	return nil, fmt.Errorf("no client found with tag: %s", tag)
}

func sliceContainsTags(tags []string, clientTags []string) bool {
	for _, tag := range tags {
		if !slices.Contains(clientTags, tag) {
			return false
		}
	}
	return true
}

func (h *HyprCtl) GetClientsWithTags(tags []string) (*[]Client, error) {
	var sel []Client
	for _, client := range *h.Clients() {
		if sliceContainsTags(tags, client.Tags) {
			sel = append(sel, client)
		}
	}

	return &sel, nil
}

func (h *HyprCtl) GetClientsInWorkspace(workspace *Workspace) (*[]Client, error) {
	var selected []Client
	for _, client := range *h.Clients() {
		if client.Workspace.Id == workspace.Id {
			selected = append(selected, client)
		}
	}
	if len(selected) == 0 {
		return nil, fmt.Errorf("no clients found in workspace: %s", workspace.Name)
	}
	return &selected, nil
}

func (h *HyprCtl) MoveClientToWorkspace(client *Client, workspace *Workspace) error {
	cmd := fmt.Sprintf("dispatch movetoworkspacesilent %d,pid:%d", workspace.Id, client.Pid)
	_, err := runCmd[any](h, cmd)
	if err != nil {
		return fmt.Errorf("failed to move client to workspace: %w", err)
	}
	return nil
}

func (h *HyprCtl) MoveTagToWorkspace(tag string, workspace *Workspace) error {
	cmd := fmt.Sprintf("dispatch movetoworkspacesilent %d,tag:%s", workspace.Id, tag)
	_, err := runCmd[any](h, cmd)
	if err != nil {
		return fmt.Errorf("failed to move tag to workspace: %w", err)
	}

	return nil
}
