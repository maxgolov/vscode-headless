docker build -t vscode-mcp .
docker run -d --name vscode-mcp --restart unless-stopped -p 8080:8080 -p 60100:60100 -v "$PWD/test-workspace:/workspace" --cpus=1.0 --memory=2g vscode-mcp --auth none /workspace
Write-Host "VSCode running at http://localhost:8080 (passwordless). Open it once to activate the MCP extension (port 60100)."
