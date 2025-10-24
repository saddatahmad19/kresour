package app

import (
	"fmt"
	"strings"

	"github.com/saddatahmad19/kresour/internal/ui/components"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbles/viewport"
)

// Init initializes the model
func (m Model) Init() tea.Cmd {
	return nil
}

// Update handles all updates to the model
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		// Handle resize: adjust lists and viewport to fit terminal
		m.width = msg.Width
		m.height = msg.Height
		h, v := m.styles.App.GetFrameSize()
		m.phaseList.SetSize(msg.Width-h, msg.Height-v-4) // Leave room for help/footer
		if m.toolListInit {
			m.toolList.SetSize(msg.Width-h, msg.Height-v-4)
		}
		if m.viewportInit {
			m.detailViewport.Width = msg.Width - h
			m.detailViewport.Height = msg.Height - v - 4
			// Update viewport content with new width
			m.updateViewportContent()
		}
		return m, nil

	case tea.KeyMsg:
		// Global keys: quit and back
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "backspace":
			switch m.state {
			case ToolsView:
				m.state = PhasesView
				return m, nil
			case ToolView:
				m.state = ToolsView
				return m, nil
			}
		}
	}

	// State-specific updates
	switch m.state {
	case PhasesView:
		m.phaseList, cmd = m.phaseList.Update(msg)
		if keyMsg, ok := msg.(tea.KeyMsg); ok && keyMsg.String() == "enter" && m.phaseList.Index() >= 0 {
			m.selectedPhase = m.phaseList.Index()
			// Build tool list dynamically
			var toolItems []list.Item
			for _, t := range m.phases[m.selectedPhase].Tools {
				toolItems = append(toolItems, components.NewToolItem(t.ToolName, t.ToolDescription))
			}
			m.toolList = list.New(toolItems, list.NewDefaultDelegate(), m.width, m.height)
			m.toolList.Title = fmt.Sprintf("Tools in %s", m.phases[m.selectedPhase].Phase)
			m.toolList.SetShowHelp(true)
			h, v := m.styles.App.GetFrameSize()
			m.toolList.SetSize(m.width-h, m.height-v-4)
			m.toolListInit = true
			m.state = ToolsView
		}

	case ToolsView:
		m.toolList, cmd = m.toolList.Update(msg)
		if keyMsg, ok := msg.(tea.KeyMsg); ok && keyMsg.String() == "enter" && m.toolList.Index() >= 0 {
			m.selectedTool = m.toolList.Index()
			
			// Calculate available width for content
			h, v := m.styles.App.GetFrameSize()
			contentWidth := m.width - h - 4 // Account for border and padding
			
			// Build detail content with proper styling
			tool := m.phases[m.selectedPhase].Tools[m.selectedTool]
			var sb strings.Builder
			
			// Tool title
			sb.WriteString(m.styles.Title.Width(contentWidth).Render(tool.ToolName))
			sb.WriteString("\n\n")
			
			// Description section
			sb.WriteString(m.styles.Section.Width(contentWidth).Render("Description:"))
			sb.WriteString("\n")
			sb.WriteString(m.styles.Content.Width(contentWidth).Render(tool.ToolDescription))
			sb.WriteString("\n\n")
			
			// Start command section
			sb.WriteString(m.styles.Section.Width(contentWidth).Render("Start Command:"))
			sb.WriteString("\n")
			sb.WriteString(m.styles.Command.Width(contentWidth).Render(tool.ToolStartCommand))
			sb.WriteString("\n\n")
			
			// Commands section
			sb.WriteString(m.styles.Section.Width(contentWidth).Render("Commands:"))
			sb.WriteString("\n")
			for i, c := range tool.ToolCommands {
				sb.WriteString(fmt.Sprintf("%d. ", i+1))
				sb.WriteString(m.styles.Command.Width(contentWidth).Render(c.ToolCommand))
				sb.WriteString("\n")
				sb.WriteString(m.styles.Desc.Width(contentWidth).Render(c.CommandDescription))
				sb.WriteString("\n\n")
			}
			
			// Add navigation help
			sb.WriteString("\n" + strings.Repeat("─", contentWidth) + "\n")
			sb.WriteString(m.styles.Help.Width(contentWidth).Render("↑/k up • ↓/j down • backspace back • q quit"))
			
			// Setup viewport for scrolling with consistent sizing
			m.detailViewport = viewport.New(m.width-h, m.height-v-4)
			m.detailViewport.SetContent(sb.String())
			m.viewportInit = true
			m.state = ToolView
		}

	case ToolView:
		m.detailViewport, cmd = m.detailViewport.Update(msg)
	}

	return m, cmd
}

// updateViewportContent regenerates the viewport content with the current width
func (m *Model) updateViewportContent() {
	if m.state != ToolView || !m.viewportInit {
		return
	}
	
	// Calculate available width for content
	h, _ := m.styles.App.GetFrameSize()
	contentWidth := m.width - h - 4 // Account for border and padding
	
	// Build detail content with proper styling
	tool := m.phases[m.selectedPhase].Tools[m.selectedTool]
	var sb strings.Builder
	
	// Tool title
	sb.WriteString(m.styles.Title.Width(contentWidth).Render(tool.ToolName))
	sb.WriteString("\n\n")
	
	// Description section
	sb.WriteString(m.styles.Section.Width(contentWidth).Render("Description:"))
	sb.WriteString("\n")
	sb.WriteString(m.styles.Content.Width(contentWidth).Render(tool.ToolDescription))
	sb.WriteString("\n\n")
	
	// Start command section
	sb.WriteString(m.styles.Section.Width(contentWidth).Render("Start Command:"))
	sb.WriteString("\n")
	sb.WriteString(m.styles.Command.Width(contentWidth).Render(tool.ToolStartCommand))
	sb.WriteString("\n\n")
	
	// Commands section
	sb.WriteString(m.styles.Section.Width(contentWidth).Render("Commands:"))
	sb.WriteString("\n")
	for i, c := range tool.ToolCommands {
		sb.WriteString(fmt.Sprintf("%d. ", i+1))
		sb.WriteString(m.styles.Command.Width(contentWidth).Render(c.ToolCommand))
		sb.WriteString("\n")
		sb.WriteString(m.styles.Desc.Width(contentWidth).Render(c.CommandDescription))
		sb.WriteString("\n\n")
	}
	
	// Add navigation help
	sb.WriteString("\n" + strings.Repeat("─", contentWidth) + "\n")
	sb.WriteString(m.styles.Help.Width(contentWidth).Render("↑/k up • ↓/j down • backspace back • q quit"))
	
	m.detailViewport.SetContent(sb.String())
}
