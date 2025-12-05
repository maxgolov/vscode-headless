# Consolidated Project Structure Proposal

## Project Name: `unified-vscode-mcp`

A unified MCP server combining the best of both worlds:
- **Infrastructure & Analysis** from vsc-remote-mcp (rUv)
- **Editor Integration & Approvals** from vscode-as-mcp-server (Yuki Ito)

---

## 📁 Proposed Directory Structure

```
unified-vscode-mcp/
├── LICENSE                          # Apache 2.0 (for combined work)
├── NOTICE                           # Attribution for both projects
├── README.md                        # Unified documentation
├── package.json                     # Unified dependencies
├── tsconfig.json
├── LICENSES/
│   ├── MIT-vsc-remote-mcp.txt      # Original MIT license
│   └── Apache-vscode-as-mcp.txt     # Original Apache 2.0 license
│
├── src/
│   ├── server/
│   │   ├── mcp-server.ts           # Unified MCP server
│   │   ├── transports/
│   │   │   ├── stdio.ts            # From vsc-remote-mcp
│   │   │   ├── websocket.ts        # From vsc-remote-mcp
│   │   │   ├── http.ts             # From vscode-as-mcp-server
│   │   │   └── sse.ts              # From vscode-as-mcp-server
│   │   └── tool-registry.ts        # Combined registry
│   │
│   ├── tools/
│   │   ├── analysis/               # From vsc-remote-mcp
│   │   │   ├── analyze-code.ts     # Code metrics, complexity
│   │   │   ├── search-code.ts      # Pattern search
│   │   │   └── index.ts
│   │   ├── deployment/             # From vsc-remote-mcp
│   │   │   ├── deploy-instance.ts  # Docker deployment
│   │   │   ├── list-instances.ts   # Instance management
│   │   │   ├── stop-instance.ts    # Instance control
│   │   │   ├── manage-resources.ts # Resource limits
│   │   │   └── index.ts
│   │   ├── editor/                 # From vscode-as-mcp-server
│   │   │   ├── text-editor.ts      # File operations with approval
│   │   │   ├── code-checker.ts     # Real-time diagnostics
│   │   │   ├── focus-editor.ts     # Navigation
│   │   │   ├── search-symbol.ts    # Symbol search
│   │   │   └── index.ts
│   │   ├── execution/              # Combined from both
│   │   │   ├── execute-command.ts  # Enhanced terminal
│   │   │   ├── terminal-manager.ts # Terminal control
│   │   │   └── index.ts
│   │   ├── debug/                  # From vscode-as-mcp-server
│   │   │   ├── debug-tools.ts      # Debug session control
│   │   │   └── index.ts
│   │   ├── preview/                # From vscode-as-mcp-server
│   │   │   ├── preview-url.ts      # Browser preview
│   │   │   └── index.ts
│   │   ├── vscode/                 # From vscode-as-mcp-server
│   │   │   ├── execute-vscode-command.ts
│   │   │   ├── list-vscode-commands.ts
│   │   │   ├── register-external-tools.ts
│   │   │   └── index.ts
│   │   └── unified/                # NEW: Combined tools
│   │       ├── build-and-verify.ts # Build pipeline
│   │       ├── smart-deploy.ts     # Intelligent deployment
│   │       └── index.ts
│   │
│   ├── ui/                         # From vscode-as-mcp-server
│   │   ├── approval/
│   │   │   ├── confirmation-ui.ts  # Approval dialogs
│   │   │   ├── diff-view.ts        # Visual diffs
│   │   │   └── status-bar.ts       # Status indicators
│   │   └── decoration/
│   │       └── decoration-controller.ts
│   │
│   ├── deployment/
│   │   ├── docker/                 # From vsc-remote-mcp
│   │   │   ├── Dockerfile
│   │   │   ├── docker-compose.yml
│   │   │   ├── entrypoint.sh
│   │   │   └── templates/          # Dockerfile templates
│   │   │       ├── node.Dockerfile
│   │   │       ├── python.Dockerfile
│   │   │       ├── cpp.Dockerfile
│   │   │       └── java.Dockerfile
│   │   └── extension/              # From vscode-as-mcp-server
│   │       ├── extension.ts        # VSCode extension entry
│   │       ├── package.json        # Extension manifest
│   │       └── webpack.config.js
│   │
│   ├── utils/
│   │   ├── security.ts             # From vsc-remote-mcp
│   │   ├── validation.ts           # From vsc-remote-mcp
│   │   ├── path-utils.ts           # From vscode-as-mcp-server
│   │   ├── diagnostics.ts          # From vscode-as-mcp-server
│   │   └── time.ts                 # From vscode-as-mcp-server
│   │
│   └── types/
│       ├── mcp.ts                  # MCP types
│       ├── tools.ts                # Tool definitions
│       └── deployment.ts           # Deployment types
│
├── cli/
│   ├── index.ts                    # Unified CLI
│   ├── commands/
│   │   ├── start.ts                # Start MCP server
│   │   ├── deploy.ts               # Deploy instances
│   │   ├── analyze.ts              # Code analysis
│   │   ├── search.ts               # Code search
│   │   └── manage.ts               # Instance management
│   └── config/
│       └── default-config.ts
│
├── tests/
│   ├── tools/
│   │   ├── analysis.test.ts
│   │   ├── deployment.test.ts
│   │   ├── editor.test.ts
│   │   └── execution.test.ts
│   ├── integration/
│   │   ├── docker-deployment.test.ts
│   │   ├── extension-mode.test.ts
│   │   └── mcp-protocol.test.ts
│   └── e2e/
│       ├── build-pipeline.test.ts
│       └── approval-workflow.test.ts
│
├── docs/
│   ├── README.md                   # Main docs
│   ├── ARCHITECTURE.md             # System architecture
│   ├── API.md                      # API reference
│   ├── TOOLS.md                    # Tool documentation
│   ├── DEPLOYMENT.md               # Deployment guide
│   ├── MIGRATION.md                # Migration from original projects
│   └── examples/
│       ├── build-environment.md
│       ├── ci-cd-integration.md
│       └── custom-tools.md
│
└── examples/
    ├── docker-mode/
    │   ├── cpp-build-env/
    │   ├── python-dev-env/
    │   └── node-app-env/
    ├── extension-mode/
    │   └── local-development/
    └── hybrid-mode/
        └── distributed-team/
```

---

## 📜 License Attribution

### NOTICE File Content:

```
Unified VSCode MCP Server
Copyright 2025 [Your Name/Organization]

This project combines and extends functionality from:

1. vsc-remote-mcp
   Copyright (c) 2025 rUv
   Licensed under the MIT License
   Source: https://github.com/ruvnet/vsc-remote-mcp
   
   Components used:
   - Docker deployment system (src/deployment/docker/)
   - Code analysis tools (src/tools/analysis/)
   - Instance management (src/tools/deployment/)
   - Security utilities (src/utils/security.ts)

2. vscode-as-mcp-server
   Copyright 2025 Yuki Ito
   Licensed under the Apache License, Version 2.0
   Source: https://github.com/mikhail-yaskou/vscode-as-mcp-server-with-approvals
   
   Components used:
   - VSCode extension integration (src/deployment/extension/)
   - Editor tools with approval UI (src/tools/editor/)
   - Real-time diagnostics (src/tools/editor/code-checker.ts)
   - Terminal management (src/tools/execution/terminal-manager.ts)
   - Visual diff viewer (src/ui/approval/diff-view.ts)

All original copyright notices and license terms are retained.
See LICENSES/ directory for full license texts.
```

---

## 🔧 Unified Configuration

### package.json (Combined)

```json
{
  "name": "unified-vscode-mcp",
  "version": "1.0.0",
  "description": "Unified MCP server for VSCode with Docker deployment and approval workflows",
  "main": "dist/index.js",
  "bin": {
    "uvscode-mcp": "dist/cli/index.js"
  },
  "scripts": {
    "start": "node dist/server/mcp-server.js",
    "start:docker": "docker-compose up -d && npm run start",
    "start:extension": "node dist/deployment/extension/extension.js",
    "build": "tsc && npm run build:extension",
    "build:extension": "webpack --config src/deployment/extension/webpack.config.js",
    "test": "jest",
    "test:unit": "jest tests/tools",
    "test:integration": "jest tests/integration",
    "test:e2e": "jest tests/e2e"
  },
  "keywords": [
    "vscode",
    "mcp",
    "docker",
    "remote",
    "editor",
    "ai",
    "assistant",
    "code-analysis",
    "build-automation"
  ],
  "author": "Your Name <your@email.com>",
  "license": "Apache-2.0",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.7.0",
    "express": "^4.21.2",
    "ws": "^8.18.1",
    "uuid": "^9.0.1",
    "dotenv": "^16.0.3",
    "diff": "^7.0.0",
    "dedent": "^1.5.3",
    "ignore": "^7.0.3",
    "isbinaryfile": "^5.0.4"
  },
  "devDependencies": {
    "@types/node": "^22.13.10",
    "@types/express": "^5.0.0",
    "@types/ws": "^8.5.10",
    "@types/diff": "^7.0.1",
    "typescript": "^5.8.2",
    "jest": "^29.5.0",
    "@types/jest": "^29.5.0",
    "webpack": "^5.97.1",
    "webpack-cli": "^6.0.1",
    "esbuild": "^0.25.1"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

---

## 🎯 Usage Examples

### 1. Docker Mode (Pre-configured Build Environment)

```typescript
// deploy-build-env.ts
import { UnifiedMCPServer } from 'unified-vscode-mcp';

const server = new UnifiedMCPServer({
  mode: 'docker',
  transport: 'websocket',
  port: 3001
});

// Deploy with pre-configuration
const deployment = await server.deployInstance({
  name: 'cpp-build-env',
  template: 'cpp',  // Uses templates/cpp.Dockerfile
  workspace: './my-cpp-project',
  extensions: [
    'ms-vscode.cpptools',
    'ms-vscode.cmake-tools'
  ],
  environment: {
    COMPILER: 'gcc-11',
    BUILD_TYPE: 'Release'
  },
  resources: {
    cpu: 2.0,
    memory: '4g'
  }
});

// Use analysis tools
const analysis = await server.analyzeCode({
  filePath: 'src/main.cpp',
  includeMetrics: true
});

// Build and verify
const buildResult = await server.buildAndVerify({
  buildCommand: 'cmake --build build',
  testCommand: './build/tests',
  showApprovals: false  // Automated mode
});

console.log('Build successful:', buildResult.success);
```

### 2. Extension Mode (Visual Approvals)

```typescript
// local-development.ts
import { UnifiedMCPServer } from 'unified-vscode-mcp';

const server = new UnifiedMCPServer({
  mode: 'extension',
  transport: 'http',
  port: 60100
});

// Edit with visual approval
await server.editFile({
  path: 'src/app.ts',
  command: 'str_replace',
  oldStr: 'const x = 5;',
  newStr: 'const x = 10;',
  showApproval: true  // User sees diff and approves
});

// Real-time diagnostics
const diagnostics = await server.checkCode();
console.log('Errors:', diagnostics.errors);

// Execute with approval
await server.executeCommand({
  command: 'npm run build',
  requireApproval: true,  // User approves before execution
  background: false,
  timeout: 60000
});
```

### 3. Hybrid Mode (Best of Both)

```typescript
// hybrid-workflow.ts
import { UnifiedMCPServer } from 'unified-vscode-mcp';

// Start in hybrid mode
const server = new UnifiedMCPServer({
  mode: 'hybrid',
  dockerEnabled: true,
  extensionEnabled: true
});

// Deploy Docker instance for build
const instance = await server.deployInstance({
  name: 'build-server',
  template: 'node',
  workspace: './api'
});

// Use local extension for editing with approvals
await server.setMode('extension');
await server.editFile({
  path: 'api/src/routes.ts',
  command: 'insert',
  insertLine: 10,
  newStr: 'app.get("/health", (req, res) => res.json({ status: "ok" }));',
  showApproval: true
});

// Switch back to Docker for building
await server.setMode('docker', { instanceName: 'build-server' });
const buildResult = await server.executeCommand({
  command: 'npm run build && npm test'
});

// Analyze results
if (!buildResult.success) {
  const issues = await server.analyzeCode({
    filePath: 'api/src/routes.ts',
    includeIssues: true
  });
  console.log('Build failed. Issues found:', issues);
}
```

---

## 🚀 CLI Commands (Unified)

```bash
# Deploy with pre-configuration
uvscode-mcp deploy \
  --name my-app \
  --template python \
  --workspace ./my-project \
  --extensions "ms-python.python,ms-python.vscode-pylance" \
  --env "PYTHON_VERSION=3.11"

# Start MCP server (auto-detects mode)
uvscode-mcp start --mode auto --port 3001

# Analyze code (from vsc-remote-mcp)
uvscode-mcp analyze src/app.py --metrics --structure

# Search patterns (from vsc-remote-mcp)
uvscode-mcp search "async def" --directory src --context 5

# Edit with approval (from vscode-as-mcp-server)
uvscode-mcp edit src/app.py \
  --command str_replace \
  --old "x = 5" \
  --new "x = 10" \
  --approve

# Check diagnostics (from vscode-as-mcp-server)
uvscode-mcp check --all

# Build pipeline (NEW: unified tool)
uvscode-mcp build-verify \
  --docker \
  --build "npm run build" \
  --test "npm test" \
  --analyze
```

---

## 📊 Feature Matrix (Consolidated)

| Feature | Mode | Source Project |
|---------|------|----------------|
| **Deployment** | | |
| Docker deployment | Docker | vsc-remote-mcp |
| Multi-instance mgmt | Docker | vsc-remote-mcp |
| Resource limits | Docker | vsc-remote-mcp |
| VSCode extension | Extension | vscode-as-mcp-server |
| **Code Operations** | | |
| Code analysis | Both | vsc-remote-mcp |
| Pattern search | Both | vsc-remote-mcp |
| File editing | Both | vscode-as-mcp-server |
| Visual approvals | Extension | vscode-as-mcp-server |
| Symbol search | Extension | vscode-as-mcp-server |
| **Execution** | | |
| Terminal control | Both | vscode-as-mcp-server (enhanced) |
| Background jobs | Both | vscode-as-mcp-server |
| Output capture | Both | vscode-as-mcp-server |
| **Diagnostics** | | |
| Real-time errors | Extension | vscode-as-mcp-server |
| Code metrics | Both | vsc-remote-mcp |
| **Integration** | | |
| Debug sessions | Extension | vscode-as-mcp-server |
| URL preview | Extension | vscode-as-mcp-server |
| VSCode commands | Extension | vscode-as-mcp-server |
| External MCP relay | Extension | vscode-as-mcp-server |

---

## 🎯 Migration Guide

### From vsc-remote-mcp:

```bash
# Old
npx vsc-remote deploy-vscode-instance --name my-app

# New
uvscode-mcp deploy --name my-app --mode docker
```

### From vscode-as-mcp-server:

```bash
# Old (extension-based, manual config)
code --install-extension vscode-as-mcp-server

# New (can use both modes)
uvscode-mcp start --mode extension
# OR
uvscode-mcp start --mode docker  # Now with Docker support!
```

---

## ⏱️ Implementation Timeline

**Phase 1: Foundation (Week 1-2)**
- Set up project structure
- Implement unified MCP server
- Port basic tools from both projects

**Phase 2: Integration (Week 3-4)**
- Integrate Docker deployment
- Integrate approval UI
- Create unified CLI

**Phase 3: New Features (Week 5-6)**
- Build `build-and-verify` tool
- Implement hybrid mode
- Add template system

**Phase 4: Testing & Docs (Week 7-8)**
- Comprehensive testing
- Write documentation
- Create examples

**Total:** 2 months for solid production-ready version

---

## 🎉 Benefits of Consolidation

✅ **Single dependency** instead of two  
✅ **Consistent API** across all tools  
✅ **Choose your mode**: Docker, Extension, or Hybrid  
✅ **All features** in one place  
✅ **Better testing** (unified test suite)  
✅ **Easier maintenance** (one codebase)  
✅ **Enhanced workflows** (new combined tools)  
✅ **License compliant** (proper attribution)  

---

This consolidated project would be **perfect** for your use case while preserving all the strengths of both original projects! 🚀
