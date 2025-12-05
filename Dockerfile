FROM codercom/code-server:latest
USER root
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs curl unzip
COPY external/vscode-as-mcp-server-with-approvals/packages/extension/vscode-as-mcp-server-0.0.25.vsix /tmp/ext.vsix
RUN mkdir -p /tmp/ext && \
    unzip -q /tmp/ext.vsix -d /tmp/ext && \
    mkdir -p /home/coder/.local/share/code-server/extensions && \
    mv /tmp/ext/extension /home/coder/.local/share/code-server/extensions/acomagu.vscode-as-mcp-server-0.0.25 && \
    chown -R coder:coder /home/coder/.local && \
    rm -rf /tmp/ext /tmp/ext.vsix
RUN mkdir -p /workspace && chown -R coder:coder /workspace
USER coder
WORKDIR /workspace
