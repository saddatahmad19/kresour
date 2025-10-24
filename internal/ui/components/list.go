package components

// PhaseItem represents a phase in the list
type PhaseItem struct {
	title, desc string
}

func (i PhaseItem) Title() string       { return i.title }
func (i PhaseItem) Description() string { return i.desc }
func (i PhaseItem) FilterValue() string { return i.title }

// NewPhaseItem creates a new PhaseItem
func NewPhaseItem(title, desc string) PhaseItem {
	return PhaseItem{title: title, desc: desc}
}

// ToolItem represents a tool in the list
type ToolItem struct {
	title, desc string
}

func (i ToolItem) Title() string       { return i.title }
func (i ToolItem) Description() string { return i.desc }
func (i ToolItem) FilterValue() string { return i.title }

// NewToolItem creates a new ToolItem
func NewToolItem(title, desc string) ToolItem {
	return ToolItem{title: title, desc: desc}
}
