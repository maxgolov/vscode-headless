# Quick Reference Guide - VSCode Tunnel MCP Control

## 🚀 Fast Track Setup

### Option 1: Using Custom Scripts (Fastest)
```powershell
# Windows
.\scripts\launch-vscode-tunnel.ps1 -InstallExtensions

# Linux/Mac
./scripts/launch-vscode-tunnel.sh --install-exts
```

### Option 2: Using vscode-as-mcp-server Extension
```bash
# 1. Install extension
code --install-extension acomagu.vscode-as-mcp-server

# 2. Launch tunnel
code tunnel --name my-mcp-tunnel --accept-server-license-terms

# 3. Configure Claude Desktop
# Edit: ~/.config/claude/claude_desktop_config.json (Linux/Mac)
# Or: %APPDATA%\Claude\claude_desktop_config.json (Windows)
{
  "mcpServers": {
    "vscode": {
      "command": "npx",
      "args": ["vscode-as-mcp-server"]
    }
  }
}
```

### Option 3: Using vsc-remote-mcp (Docker)
```bash
cd external/vsc-remote-mcp
npm install
docker-compose up -d
npx vsc-remote mcp
```

---

## 🎯 Common Commands

### VSCode Tunnel Management
```bash
# Start tunnel (official CLI)
code tunnel --name my-tunnel --accept-server-license-terms

# Start tunnel (with user-specified machine name)
code tunnel user --accept-server-license-terms --name my-machine

# List active tunnels
code tunnel status

# Stop tunnel
code tunnel kill
```

### MCP Extension Management
```bash
# Install MCP extensions
code --install-extension acomagu.vscode-as-mcp-server
code --install-extension ms-vscode.vscode-mcp

# List installed extensions
code --list-extensions | grep -i mcp
```

### Docker-based (vsc-remote-mcp)
```bash
# Check container status
docker ps | grep vscode

# View logs
docker logs -f vscode-vscode-roo-1

# Execute command in container
docker exec vscode-vscode-roo-1 code --version

# Install extension in container
./external/vsc-remote-mcp/vscode-remote-cli.sh install-ext ms-python.python
```

---

## 🔧 Troubleshooting

### Issue: "code: command not found"
```bash
# Use full path to installed CLI
./vscode-cli/code tunnel --name my-tunnel
```

### Issue: Tunnel authentication fails
```bash
# Try GitHub auth instead of Microsoft
code tunnel --name my-tunnel --provider github

# Or specify Microsoft explicitly
code tunnel --name my-tunnel --provider microsoft
```

### Issue: MCP client can't connect
```bash
# 1. Verify tunnel is running
code tunnel status

# 2. Check extension is installed
code --list-extensions | grep vscode-as-mcp-server

# 3. Restart VSCode and MCP client
```

### Issue: Extension not loading
```bash
# Check VSCode version (MCP requires 1.102+)
code --version

# Update VSCode CLI
# Re-run the launch script to download latest
```

---

## 📋 MCP Tools Available (via vscode-as-mcp-server)

| Tool | Description | Example Usage |
|------|-------------|---------------|
| `execute_command` | Run terminal commands | `execute_command("npm install")` |
| `text_editor` | File operations | `text_editor("view", "src/index.ts")` |
| `code_checker` | Get diagnostics | `code_checker()` |
| `focus_editor` | Navigate to code | `focus_editor("src/app.ts", 42)` |
| `list_directory` | List files/dirs | `list_directory("./src")` |
| `get_terminal_output` | Get terminal output | `get_terminal_output(terminalId)` |
| `preview_url` | Open URL in VSCode | `preview_url("http://localhost:3000")` |
| `start_debug_session` | Start debugging | `start_debug_session("launch")` |

---

## 🔐 Authentication Flow

```
1. Run: code tunnel --name my-tunnel
   ↓
2. VSCode CLI outputs: "To grant access, please open: https://vscode.dev/tunnel/..."
   ↓
3. Open URL in browser → Sign in with Microsoft/GitHub
   ↓
4. Grant permissions
   ↓
5. Tunnel established! Output shows: "Tunnel 'my-tunnel' is now available"
   ↓
6. AI client connects via MCP
```

---

## 🌐 Accessing Your Tunnel

### Via Browser
```
https://vscode.dev/tunnel/<your-tunnel-name>
```

### Via VSCode Desktop
```
File → Connect to Remote... → Connect to Tunnel → <your-tunnel-name>
```

### Via MCP Client
Configure client to connect to `npx vscode-as-mcp-server`

---

## 📊 Comparison Cheat Sheet

| Feature | Custom Scripts | vscode-as-mcp-server | vsc-remote-mcp |
|---------|----------------|----------------------|----------------|
| **Setup Time** | 2 min | 5 min | 10 min |
| **Complexity** | ⭐ Easy | ⭐⭐ Medium | ⭐⭐⭐ Advanced |
| **MCP Built-in** | ❌ Manual | ✅ Yes | ✅ Yes |
| **Docker** | ❌ No | ❌ No | ✅ Yes |
| **Approval UI** | ❌ No | ✅ Yes | ⚠️ Partial |
| **Multi-instance** | ❌ Manual | ✅ Yes | ✅ Swarm mode |
| **Best For** | Quick start | Local dev | Production |

---

## 💡 Pro Tips

### Tip 1: Auto-restart tunnel
```bash
# Linux/Mac with systemd
sudo nano /etc/systemd/system/vscode-tunnel.service

[Unit]
Description=VSCode Tunnel
After=network.target

[Service]
ExecStart=/path/to/code tunnel --name my-tunnel --accept-server-license-terms
Restart=always

[Install]
WantedBy=multi-user.target

# Enable and start
sudo systemctl enable vscode-tunnel
sudo systemctl start vscode-tunnel
```

### Tip 2: Use environment variables
```bash
# Set tunnel name in env
export VSCODE_TUNNEL_NAME="dev-tunnel-$(whoami)"
code tunnel --name $VSCODE_TUNNEL_NAME
```

### Tip 3: Multiple tunnels for different projects
```bash
# Project A
cd ~/projects/project-a
./vscode-cli/code tunnel --name project-a-tunnel

# Project B
cd ~/projects/project-b
./vscode-cli/code tunnel --name project-b-tunnel
```

---

## 📚 Additional Resources

- [VSCode Tunnel Docs](https://code.visualstudio.com/docs/remote/tunnels)
- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [vscode-as-mcp-server Marketplace](https://marketplace.visualstudio.com/items?itemName=acomagu.vscode-as-mcp-server)
- [vsc-remote-mcp NPM](https://www.npmjs.com/package/vsc-remote)

---

## 🆘 Getting Help

1. Check `EVALUATION.md` for detailed architecture
2. Review external project READMEs in `external/` directory
3. Run scripts with `--help` flag for options
4. Check VSCode logs: `code --log trace`
