# Passwordless VSCode Instance Deployment

## Overview

The vsc-remote-mcp tool now supports passwordless VSCode instance deployment. When deployed in passwordless mode, the VSCode web interface loads directly without authentication prompts.

## How to Deploy Passwordless

### Option 1: Empty String Password
```javascript
mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "dev-passwordless",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8080,
  password: ""  // Empty string = passwordless
})
```

### Option 2: Omit Password Parameter
```javascript
// Set DEFAULT_PASSWORD to empty string in deploy_vscode_instance.js:
// const DEFAULT_PASSWORD = '';

mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "dev-no-auth",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8081
  // password parameter not provided, uses DEFAULT_PASSWORD
})
```

## Implementation Details

### Code Changes (commit d3df13e)

**File:** `vscode-remote-mcp/src/tools/deploy_vscode_instance.js`

**Line 193 - Allow Empty String:**
```javascript
// OLD: const password = params.password || DEFAULT_PASSWORD;
// NEW:
const password = params.password !== undefined ? params.password : DEFAULT_PASSWORD;
```

**Lines 357-360 - Conditional PASSWORD Environment Variable:**
```javascript
const passwordEnv = (password === '' || password === undefined || password === null) 
  ? '' // Passwordless: omit PASSWORD env var entirely
  : `-e PASSWORD=${password}`;
```

**Success Message Enhancement:**
```javascript
const authMethod = password === '' || password === undefined || password === null 
  ? 'Passwordless' 
  : `Password: ${password}`;

// Result includes: "Authentication: Passwordless" or "Authentication: Password: xxx"
```

## Verification

### Check Container Environment
```powershell
# Should show NO PASSWORD variable for passwordless instances
docker inspect <instance-id> --format='{{range .Config.Env}}{{println .}}{{end}}' | Select-String -Pattern "PASSWORD"
```

### Test Access
```
Open: http://localhost:8080
Expected: VSCode interface loads directly, no password prompt
```

## Important: MCP Server Restart Required

After modifying `deploy_vscode_instance.js`, changes won't take effect until you restart the MCP server:

1. **Stop Current Server:**
   - Locate MCP server terminal in VS Code
   - Press Ctrl+C or close the terminal

2. **Restart Server:**
   - Press `Ctrl+Shift+B` → Select "Start vsc-remote-mcp Server"
   - OR run manually: `cd external\vsc-remote-mcp\vscode-remote-mcp; node src/index.js`

3. **Verify Code Loaded:**
   - Deploy new instance with `password: ""`
   - Check docker inspect output - should have NO PASSWORD env var

## Use Cases

### Development Testing
```javascript
// Quick local testing without auth barriers
{
  name: "quick-test",
  workspace_path: "c:\\projects\\my-app",
  port: 8080,
  password: ""
}
```

### Trusted Networks
```javascript
// Internal network, VPN-protected
{
  name: "internal-dev",
  workspace_path: "c:\\shared\\team-workspace",
  port: 9000,
  password: ""  // Network security sufficient
}
```

### CI/CD Pipelines
```javascript
// Automated build environments
{
  name: "ci-builder",
  workspace_path: "${GITHUB_WORKSPACE}",
  port: 8080,
  password: "",
  extensions: ["ms-python.python"]
}
```

## Security Considerations

### When to Use Passwordless

✅ **Safe Scenarios:**
- localhost development (not exposed externally)
- VPN-only networks
- Container networks with restricted access
- CI/CD isolated runners
- Internal corporate networks with other authentication layers

❌ **Avoid Passwordless When:**
- Publicly accessible endpoints
- Shared hosting environments
- Multi-tenant systems
- Untrusted networks
- Internet-facing deployments

### Alternative Security Measures

If you need passwordless access but want security:

1. **Network Isolation:**
   ```powershell
   docker run --network=isolated-net ...
   ```

2. **Reverse Proxy Authentication:**
   ```nginx
   location / {
     auth_request /auth;
     proxy_pass http://localhost:8080;
   }
   ```

3. **SSH Tunneling:**
   ```powershell
   ssh -L 8080:localhost:8080 remote-server
   ```

## Troubleshooting

### Password Still Required After Passwordless Deploy

**Symptom:** Browser prompts for password despite `password: ""`

**Cause:** MCP server running old code

**Fix:**
1. Stop MCP server process
2. Restart via VS Code task
3. Redeploy instance
4. Verify with `docker inspect`

### Container Shows PASSWORD=changeme

**Symptom:** `docker inspect` shows `PASSWORD=changeme` env var

**Cause:** Code changes not loaded (server not restarted)

**Fix:** Follow "MCP Server Restart Required" steps above

### Browser Shows "Reconnecting" Loop

**Symptom:** VSCode UI repeatedly tries to reconnect

**Possible Causes:**
- Container not fully started (wait 10-15 seconds)
- Port conflict (another service using 8080)
- Workspace mount permissions issue

**Debug:**
```powershell
docker logs <instance-id>  # Check startup messages
docker ps  # Verify container running
netstat -an | Select-String "8080"  # Check port usage
```

## Commit History

- `d3df13e` - Add passwordless VSCode instance support
- `6a676f3` - Add Docker/Podman dual runtime support

## Repository

- Fork: https://github.com/maxgolov/vsc-remote-mcp
- Original: https://github.com/ruvnet/vsc-remote-mcp

## License

MIT License (inherited from vsc-remote-mcp)
