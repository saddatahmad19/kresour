package ui

import "github.com/charmbracelet/lipgloss"

// Styles contains all application styles
type Styles struct {
	App     lipgloss.Style
	Doc     lipgloss.Style
	Help    lipgloss.Style
	Title   lipgloss.Style
	Section lipgloss.Style
	Command lipgloss.Style
	Desc    lipgloss.Style
	Content lipgloss.Style
}

// NewStyles creates a new styles instance
func NewStyles() *Styles {
	return &Styles{
		App: lipgloss.NewStyle().
			Border(lipgloss.NormalBorder(), true).
			BorderForeground(lipgloss.Color("63")).
			Padding(1, 2),
		
		Doc: lipgloss.NewStyle().
			Margin(1, 2),
		
		Help: lipgloss.NewStyle().
			Foreground(lipgloss.Color("#626262")).
			Margin(1, 0, 0, 0),
		
		Title: lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FAFAFA")).
			Background(lipgloss.Color("#7D56F4")).
			Padding(0, 1).
			Margin(0, 0, 1, 0),
		
		Section: lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#04B575")).
			Margin(0, 0, 1, 0),
		
		Command: lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FF5F87")).
			Background(lipgloss.Color("#1a1a1a")).
			Padding(0, 1).
			Margin(0, 0, 0, 2),
		
		Desc: lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FAFAFA")).
			Margin(0, 0, 1, 4),
		
		Content: lipgloss.NewStyle().
			Foreground(lipgloss.Color("#D9DCCF")).
			Margin(0, 0, 1, 0),
	}
}
