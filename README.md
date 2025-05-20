# NKDAgility Website

This repository contains the code for the NKDAgility.com website, built with Hugo and Azure Static Web Apps. The site contains resources on Agile, DevOps, and technical leadership topics.

## Environments

- [Live](https://nkdagility.com) - Production environment
- [Preview](https://preview.nkdagility.com) - Development/preview environment

Pull request sites are automatically created at: `yellow-pond-042d21b03-{PRNumber}.westeurope.5.azurestaticapps.net/`

For each PR, a custom environment will be created, and the link will be listed on the PR itself.

## Project Structure

- `/site` - Main Hugo website content and configuration
  - `/content` - Markdown files for all site content
  - `/layouts` - Hugo templates defining the site structure
  - `/static` - Static assets like images and CSS
  - `hugo.yaml` - Main Hugo configuration
  - Various `hugo.*.yaml` files for different environments
- `/functions` - Azure Functions for backend functionality
- `staticwebapp.config.*.json` - Configuration files for Azure Static Web Apps

## Prerequisites

1. [Hugo](https://gohugo.io/) - Static site generator
   ```
   winget install hugo
   ```

2. [Azure Static Web Apps CLI](https://github.com/Azure/static-web-apps-cli) - For local development
   ```
   npm install -g @azure/static-web-apps-cli
   ```

3. [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local) - For local Azure Functions development
   ```
   npm i -g azure-functions-core-tools@4 --unsafe-perm true
   ```

4. Follow the installation guide for Azure Functions: https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local

## Running Locally

1. Clone the repository
   ```
   git clone https://github.com/nkdAgility/NKDAgility.com.git
   cd NKDAgility.com
   ```

2. Start the Hugo server
   ```
   hugo server --source site --config hugo.yaml,hugo.local.yaml --debug
   ```

3. Start the Azure Static Web Apps CLI in a separate terminal
   ```
   swa start http://localhost:1313 --api-location ./functions
   ```

4. Open your browser and navigate to http://localhost:4280

## Configuration

The site uses several configuration files for different environments:

- `hugo.yaml` - Main configuration file
- `hugo.canary.yaml` - Configuration for canary environment
- `hugo.preview.yaml` - Configuration for preview environment
- `hugo.production.yaml` - Configuration for production environment
- `hugo.local.yaml` - Configuration for local development

Azure Static Web Apps configuration is managed through:
- `staticwebapp.config.json` - Default configuration
- `staticwebapp.config.canary.json` - Canary environment configuration
- `staticwebapp.config.preview.json` - Preview environment configuration
- `staticwebapp.config.production.json` - Production environment configuration

## Development Workflow

1. Create a feature branch from `main`
   ```
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the site content or configuration

3. Test your changes locally using the instructions above

4. Create a Pull Request to merge your changes to `main`

5. The PR will automatically deploy to a preview environment for testing

6. Once approved and merged, the changes will be deployed based on the branch:
   - `main` branch deploys to the Preview environment
   - `prototype` branch deploys to the Prototype environment
   - `production` branch deploys to the Live environment

## Deployment

The site is deployed using GitHub Actions workflows that are triggered on push to specific branches. The deployment process:

1. Builds the Hugo site with the appropriate configuration
2. Deploys the Azure Functions
3. Deploys the entire application to Azure Static Web Apps

Each environment (Preview, Prototype, Live) has its own deployment configuration.

## Troubleshooting

- **Hugo build errors**: Most common errors are related to content formatting. Check the error message for the specific file and line number.
- **Azure Functions not running**: Make sure you've installed Azure Functions Core Tools correctly and that you're running the `swa` command with the correct `--api-location` parameter.
- **Static Web Apps CLI not working**: Ensure you have the latest version installed and that Hugo is running on the correct port (usually 1313).
- **Authentication issues**: The site uses GitHub authentication which requires environment variables to be set up. For local development, you may need to create a `.env` file with the appropriate GitHub client ID and secret.

## Contributing

1. Fork the repository and create your feature branch
2. Make your changes
3. Test your changes locally
4. Submit a pull request

Please follow the existing code style and commit message conventions.
