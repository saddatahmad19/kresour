# Release Process

This document describes how to create releases for Kresour using GoReleaser and GitHub Actions.

## Overview

Kresour uses [GoReleaser](https://goreleaser.com/) for automated cross-platform builds and GitHub Actions for CI/CD. The release process automatically:

- Cross-compiles binaries for multiple platforms (Linux, macOS, Windows)
- Creates distribution archives (tar.gz for Unix, zip for Windows)
- Generates SHA256 checksums for verification
- Publishes releases to GitHub with detailed changelogs
- Updates the install script to work with new releases

## Supported Platforms

| Platform | Architecture | Binary Name |
|----------|-------------|-------------|
| Linux | x86_64 | `kresour_Linux_x86_64.tar.gz` |
| Linux | ARM64 | `kresour_Linux_arm64.tar.gz` |
| macOS | x86_64 | `kresour_Darwin_x86_64.tar.gz` |
| macOS | ARM64 | `kresour_Darwin_arm64.tar.gz` |
| Windows | x86_64 | `kresour_Windows_x86_64.zip` |

## Creating a Release

### Prerequisites

1. **GitHub Repository**: Ensure your repository is on GitHub
2. **Git Tags**: Use semantic versioning (e.g., `v1.0.0`, `v1.2.3`)
3. **GitHub Token**: The workflow uses `GITHUB_TOKEN` (automatically provided)

### Method 1: GitHub Actions (Recommended)

1. **Create and push a tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **The GitHub Action will automatically:**
   - Trigger on tag push
   - Run tests
   - Build binaries for all platforms
   - Create a GitHub release
   - Upload binaries and checksums

### Method 2: Local Release (Development)

1. **Install GoReleaser:**
   ```bash
   go install github.com/goreleaser/goreleaser@latest
   ```

2. **Create a snapshot release:**
   ```bash
   make snapshot
   # or
   goreleaser release --snapshot --clean
   ```

3. **Create a full release (requires tag):**
   ```bash
   git tag v1.0.0
   make release
   # or
   goreleaser release --clean
   ```

## Release Configuration

The release process is configured in `.goreleaser.yml`:

### Key Features

- **Cross-compilation**: Builds for Linux, macOS, and Windows
- **Architecture support**: x86_64 and ARM64
- **Archive creation**: tar.gz for Unix, zip for Windows
- **Checksum generation**: SHA256 checksums for all binaries
- **Changelog**: Automatic changelog generation from git commits
- **Release notes**: Detailed release notes with installation instructions

### Customization

You can customize the release process by editing `.goreleaser.yml`:

- **Add more platforms**: Modify the `goos` and `goarch` lists
- **Change archive formats**: Update the `archives` section
- **Modify release notes**: Edit the `release.header` and `release.footer`
- **Add package managers**: Enable Homebrew, Scoop, or Snap packages

## Testing Releases

### Local Testing

1. **Test the binary:**
   ```bash
   ./kresour --version
   ```

2. **Test installation:**
   ```bash
   # Test the install script
   curl -sL https://raw.githubusercontent.com/saddatahmad19/kresour/main/install.sh | bash
   ```

### GitHub Actions Testing

The workflow includes automated testing:

- **Go tests**: Runs `go test -v ./...`
- **Linting**: Runs `go vet` and `go fmt`
- **Build verification**: Ensures all platforms build successfully

## Release Assets

Each release includes:

1. **Binaries**: Platform-specific executables
2. **Archives**: Compressed distribution packages
3. **Checksums**: SHA256 verification files
4. **Source code**: Tagged source code
5. **Release notes**: Detailed changelog and installation instructions

## Version Information

The binary includes version information accessible via:

```bash
kresour --version
# or
kresour -v
```

This displays:
- Version number
- Git commit hash
- Build date
- Build tool (goreleaser)

## Troubleshooting

### Common Issues

1. **Build failures**: Check Go version compatibility
2. **Permission errors**: Ensure GitHub token has proper permissions
3. **Tag issues**: Verify tag format (must start with 'v')
4. **Archive problems**: Check file paths in `.goreleaser.yml`

### Debug Mode

Run GoReleaser in debug mode:

```bash
goreleaser release --snapshot --clean --debug
```

### Manual Release

If automated release fails, you can manually create releases:

1. Build binaries locally: `make build-all`
2. Create archives: `make dist`
3. Generate checksums: `make checksums`
4. Upload to GitHub manually

## Security

- **Checksums**: All binaries include SHA256 checksums
- **Signed releases**: Consider adding GPG signing for production releases
- **Dependency scanning**: GitHub automatically scans for vulnerabilities

## Best Practices

1. **Semantic versioning**: Use `vMAJOR.MINOR.PATCH` format
2. **Release notes**: Include detailed changelog
3. **Testing**: Test releases before publishing
4. **Documentation**: Update README with new features
5. **Backup**: Keep release artifacts for rollback

## Future Enhancements

Potential improvements:

- **Package managers**: Homebrew, Scoop, Snap packages
- **Docker images**: Containerized releases
- **Code signing**: GPG or code signing certificates
- **Automated testing**: Integration tests with releases
- **Rollback mechanism**: Automated rollback on critical issues
