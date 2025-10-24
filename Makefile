# Kresour Makefile
# Build targets for maintainers and advanced users

# Variables
BINARY_NAME := kresour
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
GO_VERSION := $(shell go version | awk '{print $$3}')
LDFLAGS := -ldflags "-X main.version=$(VERSION) -X main.buildTime=$(BUILD_TIME) -X main.goVersion=$(GO_VERSION)"

# Default target
.PHONY: all
all: build

# Build the binary
.PHONY: build
build:
	@echo "Building $(BINARY_NAME)..."
	@go build $(LDFLAGS) -o $(BINARY_NAME) ./cmd/kresour
	@echo "Build complete: $(BINARY_NAME)"

# Build for multiple platforms
.PHONY: build-all
build-all: build-linux build-darwin build-windows

# Build for Linux (amd64 and arm64)
.PHONY: build-linux
build-linux:
	@echo "Building for Linux..."
	@GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o dist/$(BINARY_NAME)-linux-amd64 ./cmd/kresour
	@GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o dist/$(BINARY_NAME)-linux-arm64 ./cmd/kresour
	@echo "Linux builds complete"

# Build for macOS (amd64 and arm64)
.PHONY: build-darwin
build-darwin:
	@echo "Building for macOS..."
	@GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o dist/$(BINARY_NAME)-darwin-amd64 ./cmd/kresour
	@GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o dist/$(BINARY_NAME)-darwin-arm64 ./cmd/kresour
	@echo "macOS builds complete"

# Build for Windows (amd64)
.PHONY: build-windows
build-windows:
	@echo "Building for Windows..."
	@GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o dist/$(BINARY_NAME)-windows-amd64.exe ./cmd/kresour
	@echo "Windows build complete"

# Create distribution packages
.PHONY: dist
dist: build-all
	@echo "Creating distribution packages..."
	@mkdir -p dist
	@cd dist && tar -czf $(BINARY_NAME)-linux-amd64.tar.gz $(BINARY_NAME)-linux-amd64
	@cd dist && tar -czf $(BINARY_NAME)-linux-arm64.tar.gz $(BINARY_NAME)-linux-arm64
	@cd dist && tar -czf $(BINARY_NAME)-darwin-amd64.tar.gz $(BINARY_NAME)-darwin-amd64
	@cd dist && tar -czf $(BINARY_NAME)-darwin-arm64.tar.gz $(BINARY_NAME)-darwin-arm64
	@cd dist && zip $(BINARY_NAME)-windows-amd64.zip $(BINARY_NAME)-windows-amd64.exe
	@echo "Distribution packages created in dist/"

# Generate checksums
.PHONY: checksums
checksums: dist
	@echo "Generating checksums..."
	@cd dist && sha256sum *.tar.gz *.zip > checksums.txt
	@echo "Checksums generated: dist/checksums.txt"

# Install locally
.PHONY: install
install: build
	@echo "Installing $(BINARY_NAME) to $(GOPATH)/bin..."
	@go install $(LDFLAGS) ./cmd/kresour
	@echo "Installation complete"

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@go test -v ./...

# Run tests with coverage
.PHONY: test-coverage
test-coverage:
	@echo "Running tests with coverage..."
	@go test -v -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

# Run linting
.PHONY: lint
lint:
	@echo "Running linter..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not found, running go vet instead..."; \
		go vet ./...; \
	fi

# Format code
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	@go fmt ./...
	@echo "Code formatted"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -f $(BINARY_NAME)
	@rm -rf dist/
	@rm -f coverage.out coverage.html
	@echo "Clean complete"

# Run the application
.PHONY: run
run:
	@echo "Running $(BINARY_NAME)..."
	@go run ./cmd/kresour

# Development mode with auto-reload (requires air)
.PHONY: dev
dev:
	@if command -v air >/dev/null 2>&1; then \
		echo "Starting development mode with auto-reload..."; \
		air; \
	else \
		echo "air not found, running normally..."; \
		$(MAKE) run; \
	fi

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build         - Build the binary for current platform"
	@echo "  build-all     - Build for all supported platforms"
	@echo "  build-linux   - Build for Linux (amd64, arm64)"
	@echo "  build-darwin  - Build for macOS (amd64, arm64)"
	@echo "  build-windows - Build for Windows (amd64)"
	@echo "  dist          - Create distribution packages"
	@echo "  checksums     - Generate SHA256 checksums"
	@echo "  install       - Install to GOPATH/bin"
	@echo "  test          - Run tests"
	@echo "  test-coverage - Run tests with coverage report"
	@echo "  lint          - Run linter"
	@echo "  fmt           - Format code"
	@echo "  clean         - Clean build artifacts"
	@echo "  run           - Run the application"
	@echo "  dev           - Development mode with auto-reload"
	@echo "  help          - Show this help message"
