# Kresour 🔍

[![Go Version](https://img.shields.io/badge/go-1.24+-blue.svg)](https://golang.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-lightgrey.svg)](https://github.com/yourusername/kresour)

> A Terminal User Interface (TUI) for navigating cybersecurity resources and tools organized by engagement phases.

Kresour is an interactive command-line tool that provides quick access to cybersecurity resources organized by typical penetration testing phases. It offers a clean, keyboard-driven interface for browsing tools, commands, and documentation without requiring internet connectivity.

## ✨ Features

- **📋 Phase-based Organization**: Resources organized by Reconnaissance, Scanning, Enumeration, Exploitation, Post-Exploitation, and Reporting
- **🔍 Interactive Navigation**: Hierarchical browsing with intuitive keyboard controls
- **📚 Comprehensive Tool Database**: Detailed tool descriptions, start commands, and usage examples
- **⚡ Offline Operation**: No internet connection required - all data stored locally
- **🎨 Beautiful TUI**: Built with [Bubble Tea](https://github.com/charmbracelet/bubbletea) for a modern terminal experience
- **🖥️ Cross-platform**: Works on Linux, macOS, and Windows
- **📱 Responsive Design**: Adapts to different terminal sizes

## 🚀 Quick Start

### Prerequisites

- Go 1.24+ installed on your system
- A terminal that supports ANSI escape sequences

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/kresour.git
   cd kresour
   ```

2. **Build the application:**

   ```bash
   go build -o kresour main.go
   ```

3. **Run the application:**
   ```bash
   ./kresour
   ```

### Alternative: Run directly with Go

```bash
go run main.go
```

## 🎮 Usage

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

## 📁 Project Structure

```
kresour/
├── main.go                    # Main application code
├── go.mod                     # Go module dependencies
├── README.md                  # This file
├── reconnaissance.json       # Reconnaissance phase data
├── scanning.json             # Scanning phase data
├── enumeration.json          # Enumeration phase data
├── exploitation.json         # Exploitation phase data
├── post-exploitation.json    # Post-exploitation phase data
└── reporting.json            # Reporting phase data
```

## 🛠️ Development

### Dependencies

- [Bubble Tea](https://github.com/charmbracelet/bubbletea) - TUI framework
- [Bubbles](https://github.com/charmbracelet/bubbles) - TUI components
- [Lip Gloss](https://github.com/charmbracelet/lipgloss) - Styling

### Building from Source

```bash
# Install dependencies
go mod download

# Build the application
go build -o kresour main.go

# Run tests (if available)
go test ./...
```

## 📊 Data Format

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

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Adding New Resources

To add new tools or phases:

1. Edit the appropriate JSON file (e.g., `reconnaissance.json`)
2. Follow the existing JSON structure
3. Test your changes by running the application
4. Submit a pull request with your additions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with the amazing [Charm.sh](https://charm.sh/) ecosystem
- Inspired by the cybersecurity community's need for offline resource access
- Thanks to all contributors who help maintain and improve this tool

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/kresour/issues) page
2. Create a new issue if your problem isn't already reported
3. Provide as much detail as possible about your environment and the issue

---

**Note**: This tool is designed for educational and authorized penetration testing purposes only. Always ensure you have proper authorization before testing any systems.
