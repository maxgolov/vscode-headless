#!/bin/bash
# Launch VSCode CLI in tunnel mode for MCP control
#
# Usage: ./launch-vscode-tunnel.sh [OPTIONS]
# Options:
#   --vscode-dir DIR    Directory for VSCode CLI (default: ./vscode-cli)
#   --tunnel-name NAME  Tunnel name (default: vscode-mcp-tunnel)
#   --install-exts      Install MCP-related extensions
#   --help              Show this help

set -e

# Default values
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_DIR="$SCRIPT_DIR/../vscode-cli"
TUNNEL_NAME="vscode-mcp-tunnel"
INSTALL_EXTENSIONS=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vscode-dir)
            VSCODE_DIR="$2"
            shift 2
            ;;
        --tunnel-name)
            TUNNEL_NAME="$2"
            shift 2
            ;;
        --install-exts)
            INSTALL_EXTENSIONS=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --vscode-dir DIR    Directory for VSCode CLI (default: ./vscode-cli)"
            echo "  --tunnel-name NAME  Tunnel name (default: vscode-mcp-tunnel)"
            echo "  --install-exts      Install MCP-related extensions"
            echo "  --help              Show this help"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}=== VSCode Headless Tunnel Launcher ===${NC}"
echo -e "${YELLOW}Target Directory: $VSCODE_DIR${NC}"
echo -e "${YELLOW}Tunnel Name: $TUNNEL_NAME${NC}"

# Create directory if needed
if [ ! -d "$VSCODE_DIR" ]; then
    echo -e "${GREEN}Creating directory: $VSCODE_DIR${NC}"
    mkdir -p "$VSCODE_DIR"
fi

# Detect platform and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Linux*)
        PLATFORM="linux"
        ;;
    Darwin*)
        PLATFORM="darwin"
        ;;
    *)
        echo -e "${RED}Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64|amd64)
        ARCH_NAME="x64"
        ;;
    aarch64|arm64)
        ARCH_NAME="arm64"
        ;;
    armv7l)
        ARCH_NAME="armhf"
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

CODE_BIN="$VSCODE_DIR/code"

# Download VSCode CLI if needed
if [ ! -f "$CODE_BIN" ]; then
    echo -e "${CYAN}Downloading VSCode CLI...${NC}"
    
    DOWNLOAD_URL="https://update.code.visualstudio.com/latest/$PLATFORM-$ARCH_NAME-cli/stable"
    TARBALL="$VSCODE_DIR/vscode-cli.tar.gz"
    
    echo -e "${GRAY}Download URL: $DOWNLOAD_URL${NC}"
    
    if command -v curl &> /dev/null; then
        curl -Lf "$DOWNLOAD_URL" -o "$TARBALL"
    elif command -v wget &> /dev/null; then
        wget "$DOWNLOAD_URL" -O "$TARBALL"
    else
        echo -e "${RED}Neither curl nor wget found. Please install one.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Download complete. Extracting...${NC}"
    tar -xzf "$TARBALL" -C "$VSCODE_DIR"
    rm "$TARBALL"
    
    chmod +x "$CODE_BIN"
    echo -e "${GREEN}VSCode CLI installed successfully!${NC}"
else
    echo -e "${GREEN}VSCode CLI found at: $CODE_BIN${NC}"
fi

# Install MCP extensions if requested
if [ "$INSTALL_EXTENSIONS" = true ]; then
    echo -e "\n${CYAN}Installing MCP-related extensions...${NC}"
    
    extensions=(
        "acomagu.vscode-as-mcp-server"
        "ms-vscode.vscode-mcp"
    )
    
    for ext in "${extensions[@]}"; do
        echo -e "${YELLOW}Installing: $ext${NC}"
        "$CODE_BIN" --install-extension "$ext" --force || echo -e "${YELLOW}Warning: Failed to install $ext${NC}"
    done
fi

# Launch tunnel
echo -e "\n${CYAN}Launching VSCode tunnel...${NC}"
echo -e "${YELLOW}Tunnel Name: $TUNNEL_NAME${NC}"
echo -e "${YELLOW}This will open a browser for authentication on first run.${NC}"
echo ""

"$CODE_BIN" tunnel --name "$TUNNEL_NAME" --accept-server-license-terms
