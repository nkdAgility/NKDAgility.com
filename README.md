# NKDAgility Website

- [Live](https://nkdagility.com)
- [Prototype](https://prototype.nkdagility.com)
- [Preview](https://yellow-pond-042d21b03-preview.westeurope.5.azurestaticapps.net/)

Pull request sites are yellow-pond-042d21b03-{PRNumber}.westeurope.5.azurestaticapps.net/

For each PR there will be a custom environemnt created that will be listed on the PR.

## Testing Locally

## prerequisits:

1. `winget install hugo`
2. `npm install -g @azure/static-web-apps-cli`
3. `npm i -g azure-functions-core-tools@4 --unsafe-perm true`
4. Install https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local

## Running

4. Start Hugo Server `hugo server --source site --config hugo.yaml,hugo.debug.yaml --debug`
5. Start Swa Server `swa start http://localhost:1313 --api-location ./functions`
