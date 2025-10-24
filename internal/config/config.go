package config

import (
	"fmt"
	"os"
)

// Config holds application configuration
type Config struct {
	DataDir string
}

// Load loads configuration from environment or defaults
func Load() (*Config, error) {
	dataDir := os.Getenv("KRESOUR_DATA_DIR")
	if dataDir == "" {
		dataDir = "data"
	}
	
	// Ensure data directory exists
	if _, err := os.Stat(dataDir); os.IsNotExist(err) {
		return nil, fmt.Errorf("data directory not found: %s", dataDir)
	}
	
	return &Config{
		DataDir: dataDir,
	}, nil
}
