#!/bin/bash

# Kresour Direct Binary Download Script
# Downloads the latest binary for your platform

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

# Function to download binary
download_binary() {
    local platform="$1"
    local release_info="$2"
    local download_url temp_dir binary_path
    
    # Extract download URL for the specific platform
    if [ "$platform" = "windows_amd64" ]; then
        download_url=$(echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*kresour.exe[^\"]*\"" | cut -d'"' -f4)
        binary_name="kresour.exe"
    else
        download_url=$(echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*kresour[^\"]*\"" | grep -v "\.tar\.gz" | grep -v "\.zip" | cut -d'"' -f4)
        binary_name="kresour"
    fi
    
    if [ -z "$download_url" ]; then
        print_error "No binary found for platform: $platform"
        print_status "Available downloads:"
        echo "$release_info" | grep -o "\"browser_download_url\": \"[^\"]*\"" | cut -d'"' -f4
        exit 1
    fi
    
    # Create temporary directory
    temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT
    
    print_status "Downloading binary for $platform..."
    print_status "URL: $download_url"
    
    # Download binary
    if ! curl -L -o "$temp_dir/$binary_name" "$download_url"; then
        print_error "Failed to download binary"
        exit 1
    fi
    
    # Make executable (for Unix systems)
    if [ "$platform" != "windows_amd64" ]; then
        chmod +x "$temp_dir/$binary_name"
    fi
    
    # Determine output path
    if [ -n "$1" ] && [ "$1" != "" ]; then
        output_path="$1"
    else
        output_path="./$binary_name"
    fi
    
    # Copy to final location
    if cp "$temp_dir/$binary_name" "$output_path"; then
        if [ "$platform" != "windows_amd64" ]; then
            chmod +x "$output_path"
        fi
        print_success "Successfully downloaded $binary_name to $output_path"
        
        # Test the binary
        if [ "$platform" != "windows_amd64" ]; then
            print_status "Testing binary..."
            if "$output_path" --version >/dev/null 2>&1; then
                print_success "Binary is working correctly!"
                "$output_path" --version
            else
                print_warning "Binary downloaded but may not be working correctly"
            fi
        fi
    else
        print_error "Failed to save binary to $output_path"
        exit 1
    fi
}

# Main function
main() {
    print_status "Kresour Direct Binary Downloader"
    print_status "================================="
    
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
    
    # Download binary
    download_binary "$platform" "$release_info" "$1"
    
    print_success "Download completed successfully!"
    print_status "Run './$BINARY_NAME' (or '$BINARY_NAME.exe' on Windows) to start using Kresour"
}

# Show help
show_help() {
    echo "Usage: $0 [output_path]"
    echo ""
    echo "Downloads the latest Kresour binary for your platform."
    echo ""
    echo "Arguments:"
    echo "  output_path    Optional. Where to save the binary (default: ./kresour)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Download to ./kresour"
    echo "  $0 /usr/local/bin/    # Download to /usr/local/bin/kresour"
    echo "  $0 ./my-kresour       # Download to ./my-kresour"
    echo ""
    echo "Supported platforms:"
    echo "  - Linux (x86_64, ARM64)"
    echo "  - macOS (x86_64, ARM64)"
    echo "  - Windows (x86_64)"
}

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

# Run main function
main "$@"
