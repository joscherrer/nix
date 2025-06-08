package main

import (
	"fmt"
	"strconv"
	"strings"
)

type HyprlandEvent interface {
	SetData(data string) (HyprlandEvent, error)
}

type WorkspaceEvent struct {
	WorkspaceName string
}

func (e WorkspaceEvent) SetData(data string) (HyprlandEvent, error) {
	e.WorkspaceName = data
	return e, nil
}

type WorkspaceV2Event struct {
	WorkspaceId   int
	WorkspaceName string
}

func (e WorkspaceV2Event) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 2)
	if len(parts) < 2 {
		return nil, fmt.Errorf("invalid data for WorkspaceV2Event: %s", data)
	}

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return nil, fmt.Errorf("invalid WorkspaceV2 ID: %s", parts[0])
	}

	e.WorkspaceId = id
	e.WorkspaceName = parts[1]
	return e, nil
}

type OpenwindowEvent struct {
	WindowAddress string
	WorkspaceName string
	WindowClass   string
	WindowTitle   string
}

func (e OpenwindowEvent) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 4)
	if len(parts) < 4 {
		return nil, fmt.Errorf("invalid data for OpenwindowEvent: %s", data)
	}

	e.WindowAddress = parts[0]
	e.WorkspaceName = parts[1]
	e.WindowClass = parts[2]
	e.WindowTitle = parts[3]

	return e, nil
}

type ClosewindowEvent struct {
	WindowAddress string
}

func (e ClosewindowEvent) SetData(data string) (HyprlandEvent, error) {
	e.WindowAddress = data
	return e, nil
}

type CreateWorkspaceV2Event struct {
	WorkspaceId   int
	WorkspaceName string
}

func (e CreateWorkspaceV2Event) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 2)
	if len(parts) < 2 {
		return nil, fmt.Errorf("invalid data for CreateWorkspaceV2Event: %s", data)
	}

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return nil, fmt.Errorf("invalid CreateWorkspaceV2 ID: %s", parts[0])
	}

	e.WorkspaceId = id
	e.WorkspaceName = parts[1]
	return e, nil
}

type DestroyWorkspaceV2Event struct {
	WorkspaceId   int
	WorkspaceName string
}

func (e DestroyWorkspaceV2Event) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 2)
	if len(parts) < 2 {
		return nil, fmt.Errorf("invalid data for DestroyWorkspaceV2Event: %s", data)
	}

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return nil, fmt.Errorf("invalid DestroyWorkspaceV2 ID: %s", parts[0])
	}

	e.WorkspaceId = id
	e.WorkspaceName = parts[1]
	return e, nil
}

type MonitorAddedV2Event struct {
	MonitorId          int
	MonitorName        string
	MonitorDescription string
}

func (e MonitorAddedV2Event) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 3)
	if len(parts) < 3 {
		return nil, fmt.Errorf("invalid data for MonitorAddedV2Event: %s", data)
	}

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return nil, fmt.Errorf("invalid MonitorAddedV2 ID: %s", parts[0])
	}

	e.MonitorId = id
	e.MonitorName = parts[1]
	e.MonitorDescription = parts[2]
	return e, nil
}

type MonitorRemovedV2Event struct {
	MonitorId          int
	MonitorName        string
	MonitorDescription string
}

func (e MonitorRemovedV2Event) SetData(data string) (HyprlandEvent, error) {
	parts := strings.SplitN(data, ",", 3)
	if len(parts) < 3 {
		return nil, fmt.Errorf("invalid data for MonitorRemovedV2Event: %s", data)
	}

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return nil, fmt.Errorf("invalid MonitorRemovedV2 ID: %s", parts[0])
	}

	e.MonitorId = id
	e.MonitorName = parts[1]
	e.MonitorDescription = parts[2]
	return e, nil
}
