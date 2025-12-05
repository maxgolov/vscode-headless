# vsc-remote-mcp Enhancement: Docker + Podman Support

**Date:** December 5, 2025  
**Enhancement:** Added automatic Docker/Podman detection and support

## What Changed

Enhanced `deploy_vscode_instance.js` to support both **Docker** and **Podman** container runtimes with automatic detection.

## Features

### 1. Automatic Runtime Detection
- Tries Docker first (most common)
- Falls back to Podman if Docker unavailable
- Caches detection result for performance
- Clear error messages if neither is available

### 2. Manual Runtime Override
Set via environment variable:
```bash
# Force Docker
export CONTAINER_RUNTIME=docker

# Force Podman
export CONTAINER_RUNTIME=podman

# Auto-detect (default)
export CONTAINER_RUNTIME=auto
```

Or per-request via parameter:
```javascript
{
  "name": "my-dev",
  "workspace_path": "/path/to/workspace",
  "runtime": "podman"  // Override auto-detection
}
```

### 3. Compatible Command Building
- Handles syntax differences (e.g., `--restart` vs `--restart=`)
- Identical functionality across both runtimes
- Same Docker API compatibility

## Technical Details

### Detection Logic
```javascript
async function detectContainerRuntime() {
  1. Check CONTAINER_RUNTIME env variable
  2. Try `docker --version` && `docker ps`
  3. Try `podman --version` && `podman ps`
  4. Throw error if neither works
}
```

### Modified Files
- `external/vsc-remote-mcp/vscode-remote-mcp/src/tools/deploy_vscode_instance.js`

### New Functions
- `detectContainerRuntime()` - Auto-detection logic
- `buildContainerCommand(runtime, ...)` - Replaces `buildDockerCommand()`

### API Changes
**New parameter:** `runtime` (optional)
```javascript
{
  "name": "hello-world-dev",
  "workspace_path": "c:\\build\\vscode-headless\\test-workspace",
  "port": 8080,
  "password": "test123",
  "runtime": "podman"  // NEW: 'docker', 'podman', or 'auto'
}
```

**New response field:** `runtime`
```javascript
{
  "id": "a12a8216",
  "name": "hello-world-dev",
  "runtime": "podman",  // NEW: Shows which runtime was used
  "port": 8080,
  "url": "http://localhost:8080",
  "status": "running"
}
```

## Why This Matters

### 1. Broader Compatibility
- Works on Linux systems with Podman (default in RHEL/Fedora)
- No Docker Desktop licensing concerns
- Rootless container support via Podman

### 2. Fallback Support
- If Docker daemon fails, automatically tries Podman
- Helpful during Docker Desktop updates/restarts
- Works in environments with only one runtime

### 3. Future-Proof
- Podman adoption growing in enterprise
- Both runtimes actively maintained
- API compatibility ensures longevity

## Testing

### With Docker
```javascript
// MCP tool call
mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "docker-test",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8080
})

// Expected: Detects Docker, deploys container
// Result: runtime="docker"
```

### With Podman
```javascript
// Same call, Podman installed instead
mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "podman-test",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8081
})

// Expected: Detects Podman, deploys container
// Result: runtime="podman"
```

### Force Specific Runtime
```javascript
// Explicitly use Podman
mcp_vsc-remote-mc_deploy_vscode_instance({
  name: "force-podman",
  workspace_path: "c:\\build\\vscode-headless\\test-workspace",
  port: 8082,
  runtime: "podman"
})
```

## Installation Instructions

### Installing Podman (if needed)

**Windows:**
```powershell
winget install RedHat.Podman
# Or download from: https://github.com/containers/podman/releases
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install podman
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install podman
```

**macOS:**
```bash
brew install podman
podman machine init
podman machine start
```

## Compatibility Matrix

| Runtime | Windows | Linux | macOS | Rootless | License |
|---------|---------|-------|-------|----------|---------|
| Docker  | ✅      | ✅    | ✅    | ❌       | Docker Desktop License |
| Podman  | ✅      | ✅    | ✅    | ✅       | Apache 2.0 |

## Backwards Compatibility

✅ **Fully backwards compatible**
- Existing code works without changes
- Auto-detection transparent to users
- Default behavior unchanged (tries Docker first)
- No breaking API changes

## Error Messages

### Neither Runtime Available
```
Error: Neither Docker nor Podman is available or running. 
Please install and start one of them.
```

### Docker Not Running
```
Docker is installed but daemon is not running
Detected container runtime: Podman
```

### Deployment Failure
```
Error deploying podman container: <error details>
```

## Configuration Examples

### .env file
```bash
# Container runtime preference
CONTAINER_RUNTIME=auto  # or 'docker' or 'podman'

# Other existing vars
DEFAULT_PASSWORD=changeme
DEFAULT_EXTENSIONS=ms-python.python,dbaeumer.vscode-eslint
```

### Per-Instance Override
```javascript
// Deploy with Docker even if Podman is default
{
  "name": "docker-only-instance",
  "workspace_path": "/workspace",
  "runtime": "docker"
}
```

## Future Enhancements

Potential additions:
- [ ] Support for `nerdctl` (containerd CLI)
- [ ] Kubernetes pod deployment
- [ ] LXC/LXD container support
- [ ] Runtime health checks
- [ ] Automatic image pulling with progress

## Benefits Summary

1. ✅ **No vendor lock-in** - Works with Docker or Podman
2. ✅ **Enterprise-friendly** - Podman avoids Docker Desktop licensing
3. ✅ **Seamless failover** - Auto-switches if primary runtime unavailable
4. ✅ **Developer choice** - Use preferred container runtime
5. ✅ **Zero config** - Works out of the box with either runtime

## Documentation Updates

Updated files:
- `docs/PODMAN_DOCKER_SUPPORT.md` - This file
- `external/vsc-remote-mcp/vscode-remote-mcp/src/tools/deploy_vscode_instance.js` - Enhanced code
- (TODO) `docs/MCP_SETUP_AND_TESTING.md` - Add Podman testing section

---

**Tested:** ✅ Code changes applied  
**Ready for testing:** Requires Docker or Podman running  
**Next step:** Test deployment with available runtime
