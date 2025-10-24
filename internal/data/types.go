package data

// Command represents a tool command
type Command struct {
	ToolCommand        string `json:"toolCommand"`
	CommandDescription string `json:"commandDescription"`
}

// Tool represents a cybersecurity tool
type Tool struct {
	ToolName         string    `json:"toolName"`
	ToolDescription  string    `json:"toolDescription"`
	ToolStartCommand string    `json:"toolStartCommand"`
	ToolCommands     []Command `json:"toolCommands"`
}

// Phase represents a cybersecurity phase
type Phase struct {
	Phase            string `json:"phase"`
	PhaseDescription string `json:"phaseDescription"`
	Tools            []Tool `json:"tools"`
}
