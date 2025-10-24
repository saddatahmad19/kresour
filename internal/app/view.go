package app

// View renders the current state of the model
func (m Model) View() string {
	switch m.state {
	case PhasesView:
		return m.styles.App.Render(m.phaseList.View())
	case ToolsView:
		return m.styles.App.Render(m.toolList.View())
	case ToolView:
		return m.styles.App.Render(m.detailViewport.View())
	}
	return "Error: Invalid state"
}
