# VSCode Headless Tunnel MCP Control

This project evaluates and provides tools for spawning VSCode headless in tunnel mode and controlling it via MCP (Model Context Protocol).

## Project Structure

```
vscode-headless/
├── external/           # Cloned projects for evaluation
│   ├── vsc-remote-mcp/
│   └── vscode-as-mcp-server-with-approvals/
├── scripts/            # PowerShell and Bash launch scripts
│   ├── launch-vscode-tunnel.ps1
│   └── launch-vscode-tunnel.sh
├── vscode-cli/         # (Auto-created) Isolated VSCode CLI
├── EVALUATION.md       # Detailed evaluation and comparison
└── README.md          # This file
```

## Quick Start

### Windows (PowerShell)
```powershell
# Basic launch
.\scripts\launch-vscode-tunnel.ps1

# With custom tunnel name and MCP extensions
.\scripts\launch-vscode-tunnel.ps1 -TunnelName "my-tunnel" -InstallExtensions
```

### Linux/macOS (Bash)
```bash
# Make script executable
chmod +x scripts/launch-vscode-tunnel.sh

# Basic launch
./scripts/launch-vscode-tunnel.sh

# With options
./scripts/launch-vscode-tunnel.sh --tunnel-name my-tunnel --install-exts
```

## Evaluated Projects

### 1. ruvnet/vsc-remote-mcp ⭐
- **Repository:** https://github.com/ruvnet/vsc-remote-mcp
- **Best for:** Docker-based deployments, multi-instance management
- **Features:** Complete MCP server, VSCode swarm management, security features
- **Type:** NPM package + Docker

### 2. mikhail-yaskou/vscode-as-mcp-server-with-approvals ⭐
- **Repository:** https://github.com/mikhail-yaskou/vscode-as-mcp-server-with-approvals
- **Best for:** Extension-based control, local development
- **Features:** Approval UI for code changes, real-time diagnostics, terminal ops
- **Type:** VSCode Extension

📖 **See [EVALUATION.md](EVALUATION.md) for detailed comparison and architecture**  
📊 **See [FEATURE_PARITY_ANALYSIS.md](FEATURE_PARITY_ANALYSIS.md) for comprehensive feature-by-feature comparison**

## What is MCP?

**Model Context Protocol (MCP)** enables AI assistants (Claude, etc.) to interact with developer environments:
- 📝 Code editing with approval workflows
- 🔍 Real-time diagnostics and error correction
- 💻 Terminal command execution
- 🌐 Remote/tunnel mode support
- 🔧 Extension and workspace management

## Features

✅ **Isolated VSCode CLI installation** - No interference with main VSCode  
✅ **Tunnel mode support** - Remote access from anywhere  
✅ **Cross-platform scripts** - PowerShell (Windows) and Bash (Linux/macOS)  
✅ **MCP extension auto-install** - Optional `-InstallExtensions` flag  
✅ **Project evaluation** - Compare multiple MCP control approaches  

## Setup Instructions

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url>
   cd vscode-headless
   ```

2. **Choose your approach:**
   - **Quick Start:** Use the provided scripts (see Quick Start above)
   - **Extension-Based:** Install `vscode-as-mcp-server` from VSCode marketplace
   - **Docker/Advanced:** Explore `external/vsc-remote-mcp`

3. **Configure AI Client (e.g., Claude Desktop):**
   ```json
   // claude_desktop_config.json
   {
     "mcpServers": {
       "vscode": {
         "command": "npx",
         "args": ["vscode-as-mcp-server"]
       }
     }
   }
   ```

4. **Test the connection:**
   - Launch tunnel (via script or manually)
   - Start your AI client (Claude Desktop, etc.)
   - AI should now be able to control your VSCode instance!

## Recommendations

🎯 **For local development:** Use `vscode-as-mcp-server` extension + custom scripts  
🎯 **For production/teams:** Use `vsc-remote-mcp` with Docker  
🎯 **For evaluation:** Compare both approaches in `external/` directory

## Documentation

- **[MCP_SETUP_AND_TESTING.md](MCP_SETUP_AND_TESTING.md)** - 🚀 **Complete guide for building, configuring, and testing vsc-remote-mcp**
- **[PODMAN_DOCKER_SUPPORT.md](docs/PODMAN_DOCKER_SUPPORT.md)** - 🐳 **NEW: Docker + Podman automatic detection and support**
- **[USE_CASE_ANALYSIS.md](USE_CASE_ANALYSIS.md)** - 🎯 **Analysis for pre-configured build environments**
- **[CONSOLIDATION_PROPOSAL.md](CONSOLIDATION_PROPOSAL.md)** - 🔀 **Plan for merging both projects**
- **[EVALUATION.md](EVALUATION.md)** - Project evaluation, architecture, and recommendations
- **[FEATURE_PARITY_ANALYSIS.md](FEATURE_PARITY_ANALYSIS.md)** - ⭐ **Comprehensive feature-by-feature comparison**
- **[ARCHITECTURE_COMPARISON.md](ARCHITECTURE_COMPARISON.md)** - 📐 **Visual architecture diagrams and flows**
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference guide and command cheat sheet
- **[TESTING.md](TESTING.md)** - Complete testing procedures for all approaches
- **[external/vsc-remote-mcp/README.md](external/vsc-remote-mcp/README.md)** - Docker-based solution docs
- **[external/vscode-as-mcp-server-with-approvals/README.md](external/vscode-as-mcp-server-with-approvals/README.md)** - Extension docs

## Security Notes

⚠️ **Tunnel authentication:** First run will prompt for Microsoft/GitHub OAuth  
⚠️ **MCP permissions:** Review and approve AI code changes via approval UI  
⚠️ **Isolated installation:** Scripts install VSCode CLI in separate directory  

## Resources

- [VSCode Tunnel Documentation](https://code.visualstudio.com/docs/remote/tunnels)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [VSCode MCP Extension API](https://code.visualstudio.com/api/extension-guides/mcp)

## License

MIT (for custom scripts in this repository)  
See individual projects in `external/` for their licenses.
