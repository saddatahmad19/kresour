# Kresour

[![Go Version](https://img.shields.io/badge/go-1.20+-blue.svg)](https://golang.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-lightgrey.svg)](https://github.com/saddatahmad19/kresour)

> A Terminal User Interface (TUI) for navigating cybersecurity resources and tools organized by engagement phases.

Kresour is an interactive command-line tool that provides quick access to cybersecurity resources organized by typical penetration testing phases. It offers a clean, keyboard-driven interface for browsing tools, commands, and documentation without requiring internet connectivity.

## Features

- **Phase-based Organization**: Resources organized by Reconnaissance, Scanning, Enumeration, Exploitation, Post-Exploitation, and Reporting
- **Interactive Navigation**: Hierarchical browsing with intuitive keyboard controls
- **Comprehensive Tool Database**: Detailed tool descriptions, start commands, and usage examples
- **ffline Operation**: No internet connection required - all data stored locally
- **Beautiful TUI**: Built with [Bubble Tea](https://github.com/charmbracelet/bubbletea) for a modern terminal experience
- **Cross-platform**: Works on Linux, macOS, and Windows
- **Responsive Design**: Adapts to different terminal sizes

## Installation

### One-Line Install (Recommended)

The easiest way to install Kresour is using our install script:

```bash
curl -sL https://raw.githubusercontent.com/saddatahmad19/kresour/main/install.sh | bash
```

This script will:

- Automatically detect your OS and architecture
- Download the appropriate binary
- Verify SHA256 checksums
- Install to `/usr/local/bin` (or `$GOBIN` if set)
- Set proper executable permissions

### Go Install (Alternative)

If you have Go 1.20+ installed, you can install directly:

```bash
go install github.com/saddatahmad19/kresour/cmd/kresour@latest
```

### Build from Source

For advanced users and contributors:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/saddatahmad19/kresour.git
   cd kresour
   ```

2. **Build the application:**

   ```bash
   go build -o kresour ./cmd/kresour
   ```

3. **Run the application:**
   ```bash
   ./kresour
   ```

#### Using Make (for maintainers)

The project includes a Makefile with various build targets:

```bash
# Build for current platform
make build

# Build for all supported platforms
make build-all

# Create distribution packages with checksums
make dist checksums

# Run tests
make test

# Install locally
make install

# See all available targets
make help
```

## Usage

### Navigation

- **Arrow Keys** or **j/k**: Navigate through lists
- **Enter**: Select an item or drill down
- **Backspace**: Go back to previous level
- **q** or **Ctrl+C**: Quit the application

### Interface Overview

1. **Phase Selection**: Browse through cybersecurity phases (Reconnaissance, Scanning, etc.)
2. **Tool Selection**: View available tools for the selected phase
3. **Tool Details**: Access detailed information including:
   - Tool description
   - Start command
   - Usage examples with explanations

## Data Format

The tool uses JSON files to store cybersecurity resource data. Each phase file contains:

```json
{
  "phase": "Phase Name",
  "phaseDescription": "Description of the phase",
  "tools": [
    {
      "toolName": "Tool Name",
      "toolDescription": "Tool description",
      "toolStartCommand": "Command to start the tool",
      "toolCommands": [
        {
          "toolCommand": "Specific command example",
          "commandDescription": "What this command does"
        }
      ]
    }
  ]
}
```

## Development

### Building from Source

For contributors and advanced users:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/saddatahmad19/kresour.git
   cd kresour
   ```

2. **Install dependencies:**
   ```bash
   go mod download
   ```

3. **Build the application:**
   ```bash
   make build
   # or
   go build -o kresour ./cmd/kresour
   ```

4. **Run tests:**
   ```bash
   make test
   ```

### Release Process

Kresour uses automated releases with GoReleaser and GitHub Actions. See [RELEASE.md](RELEASE.md) for detailed information about:

- Creating releases
- Cross-platform builds
- Release automation
- Troubleshooting

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run `make test` and `make lint`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
