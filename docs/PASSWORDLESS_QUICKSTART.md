# Quick Start: Passwordless VSCode Deployment

## 🚀 TL;DR

```javascript
// 1. Restart MCP server first (if you just modified code)
//    → Ctrl+Shift+B → "Start vsc-remote-mcp Server"

// 2. Deploy passwordless instance
mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "dev",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8080,
  password: ""  // ← Empty string = no password
})

// 3. Open browser: http://localhost:8080
```

## ✅ Verification Checklist

```powershell
# Check container has NO PASSWORD variable
docker inspect <instance-id> --format='{{range .Config.Env}}{{println .}}{{end}}' | Select-String -Pattern "PASSWORD"
# Expected: No output (PASSWORD not set)

# Access VSCode
# Open: http://localhost:8080
# Expected: Direct access, no password prompt
```

## 🔧 If Password Still Required

**The #1 cause:** MCP server has old code in memory

**Fix:**
1. Close MCP server terminal (Ctrl+C)
2. Press `Ctrl+Shift+B` → "Start vsc-remote-mcp Server"  
3. Redeploy with `password: ""`
4. Verify with docker inspect

---

**Code committed:** [d3df13e](https://github.com/maxgolov/vsc-remote-mcp/commit/d3df13e)  
**Full docs:** See `PASSWORDLESS_DEPLOYMENT.md`
