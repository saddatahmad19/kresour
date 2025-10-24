package app

import (
	"github.com/saddatahmad19/kresour/internal/config"
	"github.com/saddatahmad19/kresour/internal/data"
	"github.com/saddatahmad19/kresour/internal/ui/components"
	"github.com/saddatahmad19/kresour/internal/ui"
	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbles/viewport"
)

// ViewState represents the current view state
type ViewState int

const (
	PhasesView ViewState = iota
	ToolsView
	ToolView
)

// Model represents the main application model
type Model struct {
	phases         []data.Phase
	state          ViewState
	selectedPhase  int
	selectedTool   int
	phaseList      list.Model
	toolList       list.Model
	detailViewport viewport.Model
	width          int
	height         int
	toolListInit   bool
	viewportInit   bool
	styles         *ui.Styles
	loader         *data.Loader
}

// NewModel creates a new application model
func NewModel(cfg *config.Config) *Model {
	loader := data.NewLoader(cfg.DataDir)
	phases, err := loader.LoadPhases()
	if err != nil {
		// Handle error appropriately - for now, use empty slice
		phases = []data.Phase{}
	}

	styles := ui.NewStyles()
	
	// Initialize phase list
	var phaseItems []list.Item
	for _, p := range phases {
		phaseItems = append(phaseItems, components.NewPhaseItem(p.Phase, p.PhaseDescription))
	}
	phaseList := list.New(phaseItems, list.NewDefaultDelegate(), 0, 0)
	phaseList.Title = "Cybersecurity Phases"
	phaseList.SetShowHelp(true)

	return &Model{
		phases:    phases,
		state:     PhasesView,
		phaseList: phaseList,
		styles:    styles,
		loader:    loader,
	}
}
