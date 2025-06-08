package main

import "fmt"

type Workspace struct {
	Id              int    `json:"id"`
	Name            string `json:"name"`
	Monitor         string `json:"monitor"`
	MonitorId       int    `json:"monitorId"`
	Windows         int    `json:"windows"`
	Hasfullscreen   bool   `json:"hasfullscreen"`
	LastWindow      string `json:"lastwindow"`
	LastWindowTitle string `json:"lastwindowtitle"`
	IsPersistent    bool   `json:"ispersistent"`
}

func (w *Workspace) Clients(h *HyprCtl) (*[]Client, error) {
	return h.GetClientsInWorkspace(w)
}

type WorkspaceBrief struct {
	Id   int        `json:"id"`
	Name string     `json:"name"`
	full *Workspace `json:"-"`
}

func (w *WorkspaceBrief) Full(h *HyprCtl) *Workspace {
	if w.full != nil {
		return w.full
	}

	for _, ws := range *h.Workspaces() {
		if ws.Id == w.Id {
			w.full = &ws
			break
		}
	}

	if w.full == nil {
		panic(fmt.Errorf("workspace with id %d not found", w.Id))
	}

	return w.full
}

type Monitor struct {
	Id               int            `json:"id"`
	Name             string         `json:"name"`
	Description      string         `json:"description"`
	Make             string         `json:"make"`
	Model            string         `json:"model"`
	Serial           string         `json:"serial"`
	Width            int            `json:"width"`
	Height           int            `json:"height"`
	RefreshRate      float64        `json:"refreshRate"`
	X                int            `json:"x"`
	Y                int            `json:"y"`
	ActiveWorkspace  WorkspaceBrief `json:"activeWorkspace"`
	SpecialWorkspace WorkspaceBrief `json:"specialWorkspace"`
	Reserved         []int          `json:"reserved"`
	Scale            float64        `json:"scale"`
	Transform        int            `json:"transform"`
	Focused          bool           `json:"focused"`
	DpmsStatus       bool           `json:"dpmsStatus"`
	Vrr              bool           `json:"vrr"`
	Solitary         string         `json:"solitary"`
	ActivelyTearing  bool           `json:"activelyTearing"`
	DirectScanoutTo  string         `json:"directScanoutTo"`
	Disabled         bool           `json:"disabled"`
	CurrentFormat    string         `json:"currentFormat"`
	MirrorOf         string         `json:"mirrorOf"`
	AvailableModes   []string       `json:"availableModes"`
}

type Client struct {
	Address          string         `json:"address"`
	Mapped           bool           `json:"mapped"`
	Hidden           bool           `json:"hidden"`
	At               []int          `json:"at"`   // [x, y]
	Size             []int          `json:"size"` // [width, height]
	Workspace        WorkspaceBrief `json:"workspace"`
	Floating         bool           `json:"floating"`
	Pseudo           bool           `json:"pseudo"`
	Monitor          int            `json:"monitor"`
	Class            string         `json:"class"`
	Title            string         `json:"title"`
	InitialClass     string         `json:"initialClass"`
	InitialTitle     string         `json:"initialTitle"`
	Pid              int            `json:"pid"`
	XWayland         bool           `json:"xwayland"`
	Pinned           bool           `json:"pinned"`
	Fullscreen       int            `json:"fullscreen"`       // 0 or 1
	FullscreenClient int            `json:"fullscreenClient"` // 0 or 1
	Group            []string       `json:"grouped"`          // list of client addresses
	Tags             []string       `json:"tags"`             // list of tags
	Swallowing       string         `json:"swallowing"`       // address of the client that is swallowing this one
	FocusHistoryID   int            `json:"focusHistoryID"`
	InhibitingIdle   bool           `json:"inhibitingIdle"`
}
