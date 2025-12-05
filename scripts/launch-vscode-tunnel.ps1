<#
.SYNOPSIS
    Launch VSCode CLI in tunnel mode for MCP control

.DESCRIPTION
    This script installs (if needed) and launches a VSCode CLI instance in tunnel mode,
    enabling remote control via MCP (Model Context Protocol) from AI clients.

.PARAMETER VscodeDir
    Directory where VSCode CLI will be installed (default: .\vscode-cli)

.PARAMETER TunnelName
    Name for the tunnel (default: vscode-mcp-tunnel)

.PARAMETER InstallExtensions
    Install MCP-related extensions

.EXAMPLE
    .\launch-vscode-tunnel.ps1 -TunnelName "my-tunnel" -InstallExtensions
#>

param(
    [string]$VscodeDir = "$PSScriptRoot\..\vscode-cli",
    [string]$TunnelName = "vscode-mcp-tunnel",
    [switch]$InstallExtensions
)

$ErrorActionPreference = "Stop"

# Colors
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "=== VSCode Headless Tunnel Launcher ===" "Cyan"
Write-ColorOutput "Target Directory: $VscodeDir" "Yellow"
Write-ColorOutput "Tunnel Name: $TunnelName" "Yellow"

# Create directory if it doesn't exist
if (!(Test-Path $VscodeDir)) {
    Write-ColorOutput "Creating directory: $VscodeDir" "Green"
    New-Item -ItemType Directory -Path $VscodeDir -Force | Out-Null
}

# Check if code CLI exists
$codeExe = Join-Path $VscodeDir "code.exe"
$downloadNeeded = $true

if (Test-Path $codeExe) {
    Write-ColorOutput "VSCode CLI found at: $codeExe" "Green"
    $downloadNeeded = $false
} else {
    Write-ColorOutput "VSCode CLI not found. Will download..." "Yellow"
}

# Download VSCode CLI if needed
if ($downloadNeeded) {
    Write-ColorOutput "Downloading VSCode CLI..." "Cyan"
    
    # Detect architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "ia32" }
    $platform = "win32"
    
    $downloadUrl = "https://update.code.visualstudio.com/latest/$platform-$arch-cli/stable"
    $zipPath = Join-Path $VscodeDir "vscode-cli.zip"
    
    Write-ColorOutput "Download URL: $downloadUrl" "Gray"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
        Write-ColorOutput "Download complete. Extracting..." "Green"
        
        Expand-Archive -Path $zipPath -DestinationPath $VscodeDir -Force
        Remove-Item $zipPath -Force
        
        Write-ColorOutput "VSCode CLI installed successfully!" "Green"
    } catch {
        Write-ColorOutput "Error downloading VSCode CLI: $_" "Red"
        exit 1
    }
}

# Install MCP extensions if requested
if ($InstallExtensions) {
    Write-ColorOutput "`nInstalling MCP-related extensions..." "Cyan"
    
    $extensions = @(
        "acomagu.vscode-as-mcp-server",
        "ms-vscode.vscode-mcp"
    )
    
    foreach ($ext in $extensions) {
        Write-ColorOutput "Installing: $ext" "Yellow"
        try {
            & $codeExe --install-extension $ext --force
        } catch {
            Write-ColorOutput "Warning: Failed to install $ext" "Yellow"
        }
    }
}

# Launch tunnel
Write-ColorOutput "`nLaunching VSCode tunnel..." "Cyan"
Write-ColorOutput "Tunnel Name: $TunnelName" "Yellow"
Write-ColorOutput "This will open a browser for authentication on first run." "Yellow"
Write-ColorOutput "" "White"

try {
    # Start tunnel with proper parameters
    & $codeExe tunnel --name $TunnelName --accept-server-license-terms
} catch {
    Write-ColorOutput "Error launching tunnel: $_" "Red"
    exit 1
}
