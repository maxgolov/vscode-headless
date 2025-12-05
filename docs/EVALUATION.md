# VSCode Headless Tunnel MCP - Project Evaluation

## Overview
This document provides a comprehensive evaluation of approaches to running VSCode in headless tunnel mode with MCP (Model Context Protocol) control.

## Project Architecture

```
vscode-headless/
├── external/                              # Cloned projects for evaluation
│   ├── vsc-remote-mcp/                   # ruvnet's solution
│   └── vscode-as-mcp-server-with-approvals/  # mikhail-yaskou's extension
├── scripts/
│   ├── launch-vscode-tunnel.ps1          # PowerShell launcher
│   └── launch-vscode-tunnel.sh           # Bash launcher
├── vscode-cli/                           # (Created by scripts) Isolated VSCode CLI installation
├── EVALUATION.md                         # This file
└── README.md

```

---

## Evaluated Solutions

### 1. **ruvnet/vsc-remote-mcp** ⭐ Recommended for Containerized Deployments

**Repository:** https://github.com/ruvnet/vsc-remote-mcp

#### Key Features
- ✅ **Complete CLI and MCP server** for VSCode remote development
- ✅ **Docker-based deployment** with secure password management
- ✅ **VSCode Swarm Management** - Deploy/manage multiple instances
- ✅ **Code analysis and modification tools**
- ✅ **Resource management** for instances and jobs
- ✅ **Security features**: Command injection protection, secure password handling
- ✅ **NPM package** (`vsc-remote`) - Can be used via `npx`

#### Architecture
```
┌─────────────────┐
│   MCP Client    │ (Claude Desktop, etc.)
│  (AI Assistant) │
└────────┬────────┘
         │ MCP Protocol
         ▼
┌─────────────────┐
│  vsc-remote-mcp │ (Node.js MCP Server)
│   NPM Package   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Docker Container│ (VSCode Server)
│   with Tunnel   │
└─────────────────┘
```

#### Use Cases
- **Best for:** Teams needing containerized, secure VSCode instances
- **Best for:** Managing multiple VSCode instances (swarms)
- **Best for:** Integration with existing Docker workflows

#### Setup Example
```bash
# Install globally
npm install -g vsc-remote

# Or use via npx
npx vsc-remote mcp
```

#### Scripts Provided
- `vscode-remote-cli.sh` - CLI for Docker container management
- `vscode-remote-interact.sh` - Interactive operations
- Docker Compose configuration for easy deployment

---

### 2. **mikhail-yaskou/vscode-as-mcp-server-with-approvals** ⭐ Recommended for Extension-Based Control

**Repository:** https://github.com/mikhail-yaskou/vscode-as-mcp-server-with-approvals

#### Key Features
- ✅ **VSCode Extension** - Turns VSCode into an MCP server
- ✅ **Code editing with approval UI** - Review diffs before applying
- ✅ **Real-time diagnostics** sent to AI for immediate corrections
- ✅ **Terminal operations** (background/foreground, timeout support)
- ✅ **URL preview** in VSCode's integrated browser
- ✅ **Multi-instance switching** - Switch between VSCode windows
- ✅ **Relay functionality** - Expose built-in MCP servers externally
- ✅ **Cost-effective alternative** to Roo Code/Cursor

#### Architecture
```
┌─────────────────┐
│   MCP Client    │ (Claude Desktop, etc.)
│  (AI Assistant) │
└────────┬────────┘
         │ MCP Protocol (via npx)
         ▼
┌─────────────────┐
│  VSCode + Ext   │ (vscode-as-mcp-server)
│   Running in    │
│  Tunnel Mode    │
└─────────────────┘
```

#### Available MCP Tools
- `execute_command` - Run terminal commands
- `code_checker` - Get diagnostics
- `focus_editor` - Navigate to code locations
- `text_editor` - File operations (view, replace, create, insert, undo)
- `list_directory` - Tree-format directory listing
- `get_terminal_output` - Fetch terminal output
- `preview_url` - Open URLs in VSCode browser
- Debug session management tools

#### Use Cases
- **Best for:** Direct integration with existing VSCode installations
- **Best for:** Developers wanting approval workflows for AI code changes
- **Best for:** Cost-conscious teams avoiding metered coding tools
- **Best for:** Leveraging existing VSCode extensions and configurations

#### Setup Example
```json
// Claude Desktop config: claude_desktop_config.json
{
  "mcpServers": {
    "vscode": {
      "command": "npx",
      "args": ["vscode-as-mcp-server"]
    }
  }
}
```

---

## Custom Scripts (This Project)

### PowerShell Script: `launch-vscode-tunnel.ps1`

**Features:**
- Downloads and installs VSCode CLI to isolated directory
- Launches tunnel mode with configurable name
- Optional MCP extension installation
- Windows-optimized with progress indicators

**Usage:**
```powershell
# Basic usage
.\scripts\launch-vscode-tunnel.ps1

# Custom tunnel name + install extensions
.\scripts\launch-vscode-tunnel.ps1 -TunnelName "my-ai-tunnel" -InstallExtensions

# Custom directory
.\scripts\launch-vscode-tunnel.ps1 -VscodeDir "C:\tools\vscode-mcp"
```

### Bash Script: `launch-vscode-tunnel.sh`

**Features:**
- Cross-platform (Linux, macOS)
- Auto-detects architecture (x64, arm64, armhf)
- Isolated VSCode CLI installation
- Parallel functionality to PowerShell version

**Usage:**
```bash
# Make executable
chmod +x scripts/launch-vscode-tunnel.sh

# Basic usage
./scripts/launch-vscode-tunnel.sh

# With options
./scripts/launch-vscode-tunnel.sh --tunnel-name my-ai-tunnel --install-exts
```

---

## Comparison Matrix

| Feature | vsc-remote-mcp | vscode-as-mcp-server | Custom Scripts |
|---------|----------------|----------------------|----------------|
| **Deployment** | Docker/NPM | VSCode Extension | Standalone CLI |
| **MCP Server** | ✅ Built-in | ✅ Built-in | ⚠️ Requires extension |
| **Code Editing** | ✅ Yes | ✅ With approval UI | ⚠️ Via extension |
| **Container Support** | ✅ Native | ❌ No | ❌ No |
| **Multi-Instance** | ✅ Swarm mode | ✅ Window switching | ❌ Manual |
| **Security** | ✅ Password, injection protection | ✅ Approval workflows | ⚠️ Basic |
| **Tunnel Mode** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Setup Complexity** | Medium | Low | Very Low |
| **Resource Management** | ✅ Advanced | ❌ No | ❌ No |
| **Cost** | Free (OSS) | Free (OSS) | Free (OSS) |

---

## Recommended Approach by Use Case

### 🎯 **Use Case 1: Containerized Production Environment**
**Solution:** `ruvnet/vsc-remote-mcp`
- Deploy via Docker Compose
- Use MCP server for AI control
- Leverage swarm management for scaling
- Secure with password authentication

### 🎯 **Use Case 2: Local Development with AI Assistant**
**Solution:** `vscode-as-mcp-server-with-approvals` extension
- Install extension in your VSCode
- Configure Claude Desktop (or other MCP client)
- Launch VSCode tunnel: `code tunnel --name my-tunnel`
- AI can now control your VSCode instance

### 🎯 **Use Case 3: Quick Isolated VSCode CLI Instance**
**Solution:** Custom scripts (this project)
- Run PowerShell/Bash script
- VSCode CLI installed in isolated directory
- Tunnel launched automatically
- Manually configure MCP extensions

### 🎯 **Use Case 4: Hybrid - Best of Both Worlds**
**Solution:** Combine approaches
1. Use custom script to set up isolated VSCode CLI
2. Install `vscode-as-mcp-server` extension
3. Use `vsc-remote-mcp` tools for advanced operations

---

## MCP Integration Flow

### Standard MCP Connection
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  Claude      │  MCP    │  MCP Server  │  VSCode │  VSCode      │
│  Desktop     │◄───────►│  (npx pkg or │  API    │  Instance    │
│  (AI Client) │         │   extension) │◄───────►│  (Tunnel)    │
└──────────────┘         └──────────────┘         └──────────────┘
```

### Authentication Flow (First Run)
```
1. User runs tunnel command
   └─► VSCode CLI prompts for Microsoft/GitHub auth
       └─► Browser opens for OAuth
           └─► User authenticates
               └─► Token stored locally
                   └─► Tunnel established
                       └─► MCP client connects
```

---

## Security Considerations

### For `vsc-remote-mcp`
- ✅ Command injection protection
- ✅ Secure password generation for UI access
- ✅ Container isolation
- ⚠️ Docker daemon access required

### For `vscode-as-mcp-server`
- ✅ Approval UI for code changes
- ✅ Runs in user's VSCode context (inherits permissions)
- ⚠️ No built-in authentication (relies on tunnel auth)

### For Custom Scripts
- ✅ Isolated VSCode CLI installation
- ✅ Uses official VSCode tunnel authentication (Microsoft/GitHub)
- ⚠️ No additional security layer
- ⚠️ Requires manual MCP server configuration

---

## Next Steps

### To Test `vsc-remote-mcp`:
```bash
cd external/vsc-remote-mcp
npm install
npm run build
npx vsc-remote mcp
```

### To Test `vscode-as-mcp-server`:
1. Install extension from marketplace: `acomagu.vscode-as-mcp-server`
2. Configure Claude Desktop (see README)
3. Start tunnel: `code tunnel --name test`

### To Test Custom Scripts:
```powershell
# Windows
.\scripts\launch-vscode-tunnel.ps1 -InstallExtensions

# Linux/Mac
./scripts/launch-vscode-tunnel.sh --install-exts
```

---

## Conclusion

**For most users starting fresh:** Use `vscode-as-mcp-server-with-approvals` extension + custom launch scripts for simplicity.

**For production/team environments:** Use `vsc-remote-mcp` with Docker for robustness and multi-instance management.

**For hybrid needs:** Start with custom scripts, install the extension, and integrate `vsc-remote-mcp` tools as needed.

All approaches support the core goal: **VSCode in tunnel mode controlled by AI via MCP**.
