package main

import (
	"fmt"
	"os"

	"github.com/saddatahmad19/kresour/internal/app"
	"github.com/saddatahmad19/kresour/internal/config"
	tea "github.com/charmbracelet/bubbletea"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		fmt.Printf("Error loading config: %v\n", err)
		os.Exit(1)
	}

	model := app.NewModel(cfg)
	p := tea.NewProgram(model, tea.WithAltScreen())
	
	if _, err := p.Run(); err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}
