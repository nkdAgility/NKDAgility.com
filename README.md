# NKDAgility Website

- [Live](https://nkdagility.com)
- [Prototype](https://prototype.nkdagility.com)
- [Preview](https://yellow-pond-042d21b03-preview.westeurope.5.azurestaticapps.net/)

Pull request sites are yellow-pond-042d21b03-{PRNumber}.westeurope.5.azurestaticapps.net/

For each PR there will be a custom environemnt created that will be listed on the PR.

## Testing Locally

There are two ways to run the project locally:

### Option 1: Using Visual Studio Code Devcontainer (Recommended)

1. Install [Docker](https://www.docker.com/get-started) and [Visual Studio Code](https://code.visualstudio.com/)
2. Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code
3. Clone this repository
4. Open the repository in VS Code
5. When prompted "Reopen in Container", click "Reopen in Container", or run the "Dev Containers: Reopen in Container" command from the Command Palette (F1)
6. Once the container is built and running, press F5 or click the "Run and Debug" button in VS Code, then select "Launch Hugo & Functions"

This will automatically start both Hugo server and Azure Functions, and open the site in your browser.

### Option 2: Manual Setup

#### Prerequisites:

1. `winget install hugo` or download from [Hugo Releases](https://github.com/gohugoio/hugo/releases) (Extended version)
2. `npm install -g @azure/static-web-apps-cli`
3. `npm i -g azure-functions-core-tools@4 --unsafe-perm true`
4. Install [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local)

#### Running:

1. Start Hugo Server `hugo server --source site --config hugo.yaml,hugo.local.yaml --disableFastRender`
2. Start Azure Functions `cd functions && func start`
3. Start SWA Server `swa start http://localhost:1313 --api-location ./functions`
