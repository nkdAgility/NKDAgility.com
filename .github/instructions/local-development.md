---
description: Local development setup and commands
applyTo: "**"
---

# Local Development

## Prerequisites

- Hugo Extended version: `winget install hugo`
- Static Web Apps CLI: `npm install -g @azure/static-web-apps-cli`
- Azure Functions Core Tools: `npm i -g azure-functions-core-tools@4 --unsafe-perm true`
- .NET 10 SDK from https://dotnet.microsoft.com/download/dotnet/10.0
- PowerShell 7+: `winget install Microsoft.PowerShell`

## Running Locally

Start Hugo development server:

```
hugo server --source site --config hugo.yaml,hugo.local.yaml
```

Note: Build takes more than 30 seconds to run.

View site at http://localhost:1313

## Building

Build for production or other environments:

```
hugo build --source site --config hugo.yaml,hugo.local.yaml
```

For different environments, replace `hugo.local.yaml` with appropriate config file (`hugo.preview.yaml`, `hugo.production.yaml`, etc.).

## API Development

1. Navigate to functions directory: `cd functions`
2. Start Azure Functions runtime: `func start`
3. In separate terminal, start SWA CLI: `swa start http://localhost:1313 --api-location ./functions`
