FROM mcr.microsoft.com/vscode/devcontainers/dotnet:8.0

# Install Hugo (extended version)
ARG HUGO_VERSION=0.123.8
RUN apt-get update && apt-get install -y \
    gpg curl ca-certificates \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb -o hugo.deb \
    && dpkg -i hugo.deb \
    && rm hugo.deb \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
ARG NODE_VERSION=20
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl -sSL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install npm packages globally
RUN npm install -g @azure/static-web-apps-cli azure-functions-core-tools@4