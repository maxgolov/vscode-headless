# Testing Guide - VSCode Tunnel MCP Setup

This guide walks you through testing each approach to ensure everything works correctly.

---

## ✅ Pre-flight Checklist

Before testing, ensure you have:

- [ ] Git installed and configured
- [ ] Node.js and npm installed (for MCP server approach)
- [ ] PowerShell 5.1+ or Bash shell
- [ ] Internet connection (for downloading VSCode CLI)
- [ ] Microsoft or GitHub account (for tunnel authentication)

---

## 🧪 Test 1: Custom Scripts (Quickest)

### Windows (PowerShell)

```powershell
# Step 1: Navigate to project
cd c:\build\vscode-headless

# Step 2: Run the script
.\scripts\launch-vscode-tunnel.ps1 -TunnelName "test-tunnel" -InstallExtensions

# Expected output:
# - "VSCode CLI installed successfully!" (if first run)
# - "Launching VSCode tunnel..."
# - Browser opens for authentication
```

### Linux/macOS (Bash)

```bash
# Step 1: Navigate to project
cd /path/to/vscode-headless

# Step 2: Make script executable
chmod +x scripts/launch-vscode-tunnel.sh

# Step 3: Run the script
./scripts/launch-vscode-tunnel.sh --tunnel-name "test-tunnel" --install-exts

# Expected output:
# - "VSCode CLI installed successfully!" (if first run)
# - "Launching VSCode tunnel..."
# - Browser opens for authentication
```

### Verification

1. **Check tunnel is running:**
   ```bash
   # In a new terminal
   ./vscode-cli/code tunnel status
   ```
   
   Expected: `Tunnel 'test-tunnel' is active`

2. **Access via browser:**
   - Go to: `https://vscode.dev/tunnel/test-tunnel`
   - Should see VSCode web interface

3. **Check installed extensions:**
   ```bash
   ./vscode-cli/code --list-extensions | grep -i mcp
   ```
   
   Expected output:
   ```
   acomagu.vscode-as-mcp-server
   ms-vscode.vscode-mcp
   ```

### Cleanup

```powershell
# Windows
.\vscode-cli\code.exe tunnel kill

# Linux/Mac
./vscode-cli/code tunnel kill

# Optional: Remove installed VSCode CLI
Remove-Item -Recurse -Force .\vscode-cli  # Windows
rm -rf ./vscode-cli                        # Linux/Mac
```

---

## 🧪 Test 2: vscode-as-mcp-server Extension

### Step 1: Install Extension

```bash
# If you have VSCode installed globally
code --install-extension acomagu.vscode-as-mcp-server

# Or use the CLI installed by custom scripts
./vscode-cli/code --install-extension acomagu.vscode-as-mcp-server
```

### Step 2: Configure Claude Desktop

**Windows:**
```powershell
$configPath = "$env:APPDATA\Claude\claude_desktop_config.json"
$config = @{
    mcpServers = @{
        vscode = @{
            command = "npx"
            args = @("vscode-as-mcp-server")
        }
    }
} | ConvertTo-Json -Depth 10

New-Item -Path (Split-Path $configPath) -ItemType Directory -Force
$config | Out-File -FilePath $configPath -Encoding utf8
```

**Linux/macOS:**
```bash
mkdir -p ~/.config/claude
cat > ~/.config/claude/claude_desktop_config.json << EOF
{
  "mcpServers": {
    "vscode": {
      "command": "npx",
      "args": ["vscode-as-mcp-server"]
    }
  }
}
EOF
```

### Step 3: Start Tunnel

```bash
./vscode-cli/code tunnel --name "mcp-test" --accept-server-license-terms
```

### Step 4: Test MCP Connection

1. **Open Claude Desktop** (if installed)
2. **Start a conversation:**
   ```
   Can you list the files in my current workspace?
   ```
3. **Expected behavior:**
   - Claude should use the `list_directory` tool
   - You should see directory contents returned

### Verification

**Check MCP server status in VSCode:**
- Look at the bottom-right status bar
- Should see: 🔌 (plug icon) indicating server is running

**Test available tools:**
```
Ask Claude: "What tools do you have access to?"
```

Expected tools:
- execute_command
- text_editor
- code_checker
- focus_editor
- list_directory
- get_terminal_output
- preview_url

### Cleanup

```bash
# Stop tunnel
./vscode-cli/code tunnel kill

# Uninstall extension
./vscode-cli/code --uninstall-extension acomagu.vscode-as-mcp-server
```

---

## 🧪 Test 3: vsc-remote-mcp (Docker-based)

### Prerequisites

```bash
# Install Docker if not present
# Windows: https://docs.docker.com/desktop/install/windows-install/
# Linux: sudo apt install docker.io docker-compose
# macOS: https://docs.docker.com/desktop/install/mac-install/
```

### Step 1: Navigate and Install

```bash
cd external/vsc-remote-mcp

# Install dependencies
npm install

# Build the project (if needed)
npm run build
```

### Step 2: Start Docker Container

```bash
# Start VSCode container
docker-compose up -d

# Check container status
docker ps | grep vscode
```

Expected output:
```
CONTAINER ID   IMAGE     ... PORTS                    NAMES
abc123def456   vscode... ... 0.0.0.0:8080->8080/tcp   vscode-vscode-roo-1
```

### Step 3: Test CLI Tools

```bash
# Check container status
./vscode-remote-cli.sh status

# List environment variables
./vscode-remote-cli.sh list-env

# Test extension installation
./vscode-remote-cli.sh install-ext ms-python.python

# List installed extensions
./vscode-remote-cli.sh list-ext
```

### Step 4: Start MCP Server

```bash
npx vsc-remote mcp
```

Expected output:
```
🚀 VSCode Remote MCP Server started
📡 Listening for MCP connections...
```

### Verification

1. **Access VSCode UI:**
   - Browser: `http://localhost:8080`
   - Login with password (default: `changeme`)

2. **Test MCP tools:**
   ```bash
   npx vsc-remote analyze-code external/vsc-remote-mcp/README.md
   ```

3. **Check Docker logs:**
   ```bash
   docker logs -f vscode-vscode-roo-1
   ```

### Cleanup

```bash
# Stop MCP server (Ctrl+C)

# Stop Docker container
docker-compose down

# Remove volumes (optional - full cleanup)
docker-compose down -v
```

---

## 🧪 Test 4: Integration Test (All Components)

### Scenario: AI-Controlled Code Editing

**Goal:** Have AI create, edit, and execute code via MCP

### Setup

1. Use **Test 2** setup (vscode-as-mcp-server + tunnel)
2. Ensure Claude Desktop is configured
3. Create a test workspace:
   ```bash
   mkdir -p workspace/test-project
   cd workspace/test-project
   ```

### Test Cases

#### Test Case 1: Create a File
**Prompt to AI:**
```
Create a Python file called hello.py that prints "Hello from MCP!"
```

**Expected:**
- AI uses `text_editor` tool with "create" operation
- File `hello.py` is created in workspace
- You're shown a diff to approve (if approval UI enabled)

**Verification:**
```bash
cat hello.py
# Should output: print("Hello from MCP!")
```

#### Test Case 2: Execute Code
**Prompt to AI:**
```
Run the hello.py file
```

**Expected:**
- AI uses `execute_command` tool
- Command: `python hello.py`
- Output: "Hello from MCP!"

#### Test Case 3: Check Diagnostics
**Prompt to AI:**
```
Create a Python file with a syntax error, then check diagnostics
```

**Expected:**
- AI creates file with error
- AI uses `code_checker` tool
- Returns diagnostic messages (syntax errors)

#### Test Case 4: Preview URL
**Prompt to AI:**
```
Create a simple HTML file and preview it
```

**Expected:**
- AI creates `index.html`
- AI uses `preview_url` tool
- VSCode opens built-in browser with HTML rendered

---

## 📊 Test Results Template

Use this template to record your test results:

```markdown
## Test Results - [Date]

### Test 1: Custom Scripts
- ✅ / ❌ PowerShell script execution
- ✅ / ❌ VSCode CLI download
- ✅ / ❌ Tunnel authentication
- ✅ / ❌ Extension installation
- Notes: _______________________________

### Test 2: vscode-as-mcp-server
- ✅ / ❌ Extension installation
- ✅ / ❌ Claude Desktop configuration
- ✅ / ❌ MCP connection established
- ✅ / ❌ Tool execution (list_directory)
- Notes: _______________________________

### Test 3: vsc-remote-mcp
- ✅ / ❌ Docker container start
- ✅ / ❌ Web UI access
- ✅ / ❌ CLI tools functionality
- ✅ / ❌ MCP server start
- Notes: _______________________________

### Test 4: Integration Test
- ✅ / ❌ File creation via AI
- ✅ / ❌ Code execution via AI
- ✅ / ❌ Diagnostics retrieval
- ✅ / ❌ URL preview
- Notes: _______________________________

### Overall Assessment
- Best approach for my use case: _______
- Issues encountered: _______
- Performance notes: _______
```

---

## 🐛 Common Issues & Solutions

### Issue: "Authentication failed"
**Solution:**
```bash
# Clear cached credentials
rm ~/.vscode-cli/token-*.json  # Linux/Mac
Remove-Item $env:USERPROFILE\.vscode-cli\token-*.json  # Windows

# Try again with explicit provider
./vscode-cli/code tunnel --provider github
```

### Issue: "Port 8080 already in use" (Docker)
**Solution:**
```bash
# Edit docker-compose.yml
ports:
  - "8081:8080"  # Change 8080 to 8081

# Or stop conflicting service
lsof -ti:8080 | xargs kill -9  # Linux/Mac
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess | Stop-Process  # Windows
```

### Issue: "MCP server not responding"
**Solution:**
```bash
# 1. Verify tunnel is active
./vscode-cli/code tunnel status

# 2. Restart VSCode window
# 3. Check Claude Desktop logs
tail -f ~/.config/Claude/logs/mcp*.log  # Linux/Mac

# 4. Test MCP server manually
npx vscode-as-mcp-server
```

### Issue: "Extension not found"
**Solution:**
```bash
# Update VSCode CLI
rm -rf ./vscode-cli
./scripts/launch-vscode-tunnel.sh --install-exts

# Or install manually
./vscode-cli/code --install-extension acomagu.vscode-as-mcp-server
```

---

## ✅ Success Criteria

Your setup is working correctly if:

1. ✅ Tunnel is accessible via browser (`https://vscode.dev/tunnel/your-name`)
2. ✅ MCP extension shows as "running" in VSCode status bar
3. ✅ AI client (Claude) can list tools and execute commands
4. ✅ Code changes proposed by AI appear in VSCode
5. ✅ Terminal commands execute successfully

---

## 📝 Next Steps After Testing

Once testing is complete:

1. **Choose your preferred approach** based on test results
2. **Document your configuration** for team members
3. **Set up automation** (systemd service, Docker Compose)
4. **Configure CI/CD** if using in production
5. **Review security settings** (approval workflows, authentication)

Happy testing! 🚀
