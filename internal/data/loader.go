package data

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

// Loader handles loading of phase data
type Loader struct {
	dataDir string
}

// NewLoader creates a new data loader
func NewLoader(dataDir string) *Loader {
	return &Loader{dataDir: dataDir}
}

// LoadPhases loads all phases from JSON files
func (l *Loader) LoadPhases() ([]Phase, error) {
	fileNames := []string{
		"reconnaissance.json",
		"scanning.json",
		"enumeration.json",
		"exploitation.json",
		"post-exploitation.json",
		"reporting.json",
		"misc.json",
	}

	var phases []Phase
	for _, fn := range fileNames {
		filePath := filepath.Join(l.dataDir, fn)
		data, err := os.ReadFile(filePath)
		if err != nil {
			return nil, fmt.Errorf("failed to read %s: %w", filePath, err)
		}
		
		var p Phase
		if err := json.Unmarshal(data, &p); err != nil {
			return nil, fmt.Errorf("failed to unmarshal %s: %w", fn, err)
		}
		phases = append(phases, p)
	}
	return phases, nil
}
