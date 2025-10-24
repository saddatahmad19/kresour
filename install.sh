#!/bin/bash

# Kresour Install Script
# Downloads and installs the latest release of Kresour

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="saddatahmad19/kresour"
BINARY_NAME="kresour"
INSTALL_DIR="/usr/local/bin"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect OS and architecture
detect_platform() {
    local os arch
    
    case "$(uname -s)" in
        Linux*)     os="linux" ;;
        Darwin*)    os="darwin" ;;
        CYGWIN*|MINGW*|MSYS*) os="windows" ;;
        *)          print_error "Unsupported operating system: $(uname -s)"; exit 1 ;;
    esac
    
    case "$(uname -m)" in
        x86_64|amd64)   arch="amd64" ;;
        arm64|aarch64)  arch="arm64" ;;
        armv7l)         arch="armv7" ;;
        i386|i686)      arch="386" ;;
        *)              print_error "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
    
    echo "${os}_${arch}"
}

# Function to get latest release info
get_latest_release() {
    local api_url="https://api.github.com/repos/${REPO}/releases/latest"
    local release_info
    
    print_status "Fetching latest release information..."
    
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed. Please install curl and try again."
        exit 1
    fi
    
    release_info=$(curl -s "$api_url")
    
    if [ $? -ne 0 ] || [ -z "$release_info" ]; then
        print_error "Failed to fetch release information from GitHub API"
        exit 1
    fi
    
    echo "$release_info"
}

# Function to download and verify binary
download_and_install() {
    local platform="$1"
    local release_info="$2"
    local download_url checksum_url temp_dir binary_path
    
    # Extract download URL and checksum URL from release info
    download_url=$(echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*${platform}[^\"]*\"" | cut -d'"' -f4)
    checksum_url=$(echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*checksums[^\"]*\"" | cut -d'"' -f4)
    
    if [ -z "$download_url" ]; then
        print_error "No release found for platform: $platform"
        print_status "Available platforms:"
        echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*\"" | cut -d'"' -f4 | sed 's/.*\///' | sed 's/\.tar\.gz$//' | sed 's/\.zip$//'
        exit 1
    fi
    
    # Create temporary directory
    temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT
    
    print_status "Downloading binary for $platform..."
    print_status "URL: $download_url"
    
    # Download binary
    if ! curl -L -o "$temp_dir/${BINARY_NAME}" "$download_url"; then
        print_error "Failed to download binary"
        exit 1
    fi
    
    # Download checksums if available
    if [ -n "$checksum_url" ]; then
        print_status "Downloading checksums..."
        if curl -L -o "$temp_dir/checksums.txt" "$checksum_url"; then
            print_status "Verifying SHA256 checksum..."
            
            # Extract expected checksum for our platform
            local expected_checksum
            expected_checksum=$(grep "${BINARY_NAME}" "$temp_dir/checksums.txt" | awk '{print $1}')
            
            if [ -n "$expected_checksum" ]; then
                # Calculate actual checksum
                local actual_checksum
                if command -v sha256sum >/dev/null 2>&1; then
                    actual_checksum=$(sha256sum "$temp_dir/${BINARY_NAME}" | awk '{print $1}')
                elif command -v shasum >/dev/null 2>&1; then
                    actual_checksum=$(shasum -a 256 "$temp_dir/${BINARY_NAME}" | awk '{print $1}')
                else
                    print_warning "No SHA256 utility found, skipping checksum verification"
                    expected_checksum=""
                fi
                
                if [ -n "$expected_checksum" ] && [ "$expected_checksum" != "$actual_checksum" ]; then
                    print_error "Checksum verification failed!"
                    print_error "Expected: $expected_checksum"
                    print_error "Actual:   $actual_checksum"
                    exit 1
                fi
                
                if [ -n "$expected_checksum" ]; then
                    print_success "Checksum verification passed"
                fi
            else
                print_warning "No checksum found for ${BINARY_NAME} in checksums file"
            fi
        else
            print_warning "Failed to download checksums, skipping verification"
        fi
    else
        print_warning "No checksums available for this release"
    fi
    
    # Determine install directory
    if [ -n "$GOBIN" ] && [ -d "$GOBIN" ]; then
        INSTALL_DIR="$GOBIN"
        print_status "Using GOBIN directory: $INSTALL_DIR"
    elif [ -w "/usr/local/bin" ]; then
        INSTALL_DIR="/usr/local/bin"
        print_status "Installing to: $INSTALL_DIR"
    else
        print_warning "Cannot write to /usr/local/bin, trying ~/.local/bin"
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        print_status "Installing to: $INSTALL_DIR"
        print_warning "Make sure $INSTALL_DIR is in your PATH"
    fi
    
    # Install binary
    print_status "Installing ${BINARY_NAME} to $INSTALL_DIR..."
    
    if cp "$temp_dir/${BINARY_NAME}" "$INSTALL_DIR/${BINARY_NAME}"; then
        chmod +x "$INSTALL_DIR/${BINARY_NAME}"
        print_success "Successfully installed ${BINARY_NAME} to $INSTALL_DIR"
    else
        print_error "Failed to install binary to $INSTALL_DIR"
        print_error "You may need to run this script with sudo for system-wide installation"
        exit 1
    fi
    
    # Verify installation
    if command -v "$BINARY_NAME" >/dev/null 2>&1; then
        local version
        version=$("$BINARY_NAME" --version 2>/dev/null || echo "unknown")
        print_success "Installation verified! ${BINARY_NAME} is now available"
        print_status "Version: $version"
        print_status "Location: $(which $BINARY_NAME)"
    else
        print_warning "Installation completed but ${BINARY_NAME} is not in PATH"
        print_warning "Make sure $INSTALL_DIR is in your PATH environment variable"
    fi
}

# Main installation process
main() {
    print_status "Kresour Installer"
    print_status "=================="
    
    # Check if binary is already installed
    if command -v "$BINARY_NAME" >/dev/null 2>&1; then
        print_warning "${BINARY_NAME} is already installed: $(which $BINARY_NAME)"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled"
            exit 0
        fi
    fi
    
    # Detect platform
    local platform
    platform=$(detect_platform)
    print_status "Detected platform: $platform"
    
    # Get latest release info
    local release_info
    release_info=$(get_latest_release)
    
    # Extract version info
    local version
    version=$(echo "$release_info" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    print_status "Latest version: $version"
    
    # Download and install
    download_and_install "$platform" "$release_info"
    
    print_success "Installation completed successfully!"
    print_status "Run '${BINARY_NAME}' to start using Kresour"
}

# Run main function
main "$@"
