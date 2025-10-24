# Kresour Direct Binary Download Script for Windows
# Downloads the latest kresour.exe for Windows

param(
    [string]$OutputPath = ".\kresour.exe"
)

# Configuration
$REPO = "saddatahmad19/kresour"
$API_URL = "https://api.github.com/repos/$REPO/releases/latest"

# Function to write colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Main function
function Main {
    Write-Status "Kresour Direct Binary Downloader for Windows"
    Write-Status "============================================="
    
    # Check if PowerShell version supports Invoke-RestMethod
    if ($PSVersionTable.PSVersion.Major -lt 3) {
        Write-Error "PowerShell 3.0 or later is required"
        exit 1
    }
    
    try {
        # Get latest release info
        Write-Status "Fetching latest release information..."
        $releaseInfo = Invoke-RestMethod -Uri $API_URL -Method Get
        
        $version = $releaseInfo.tag_name
        Write-Status "Latest version: $version"
        
        # Find the Windows binary download URL
        $downloadUrl = $null
        foreach ($asset in $releaseInfo.assets) {
            if ($asset.name -eq "kresour.exe") {
                $downloadUrl = $asset.browser_download_url
                break
            }
        }
        
        if (-not $downloadUrl) {
            Write-Error "No Windows binary found in the latest release"
            Write-Status "Available assets:"
            foreach ($asset in $releaseInfo.assets) {
                Write-Host "  - $($asset.name)"
            }
            exit 1
        }
        
        # Download the binary
        Write-Status "Downloading kresour.exe..."
        Write-Status "URL: $downloadUrl"
        
        # Create output directory if it doesn't exist
        $outputDir = Split-Path -Parent $OutputPath
        if ($outputDir -and -not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
        }
        
        # Download with progress
        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $OutputPath -UseBasicParsing
        }
        catch {
            Write-Error "Failed to download binary: $($_.Exception.Message)"
            exit 1
        }
        
        # Verify the download
        if (Test-Path $OutputPath) {
            $fileSize = (Get-Item $OutputPath).Length
            Write-Success "Successfully downloaded kresour.exe to $OutputPath"
            Write-Status "File size: $([math]::Round($fileSize / 1MB, 2)) MB"
            
            # Test the binary
            Write-Status "Testing binary..."
            try {
                $versionOutput = & $OutputPath --version 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Binary is working correctly!"
                    Write-Host $versionOutput
                } else {
                    Write-Warning "Binary downloaded but may not be working correctly"
                }
            }
            catch {
                Write-Warning "Could not test binary: $($_.Exception.Message)"
            }
        } else {
            Write-Error "Download failed - file not found at $OutputPath"
            exit 1
        }
        
        Write-Success "Download completed successfully!"
        Write-Status "Run '$OutputPath' to start using Kresour"
    }
    catch {
        Write-Error "Failed to fetch release information: $($_.Exception.Message)"
        Write-Status "Make sure you have internet connectivity and try again"
        exit 1
    }
}

# Show help
function Show-Help {
    Write-Host "Usage: .\download.ps1 [output_path]"
    Write-Host ""
    Write-Host "Downloads the latest Kresour binary for Windows."
    Write-Host ""
    Write-Host "Arguments:"
    Write-Host "  output_path    Optional. Where to save the binary (default: .\kresour.exe)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\download.ps1                    # Download to .\kresour.exe"
    Write-Host "  .\download.ps1 C:\tools\kresour.exe  # Download to C:\tools\kresour.exe"
    Write-Host "  .\download.ps1 .\my-kresour.exe   # Download to .\my-kresour.exe"
    Write-Host ""
    Write-Host "Note: This script requires PowerShell 3.0 or later"
}

# Check for help parameter
if ($args -contains "--help" -or $args -contains "-h") {
    Show-Help
    exit 0
}

# Run main function
Main
