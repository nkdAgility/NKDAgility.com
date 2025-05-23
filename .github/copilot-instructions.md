# NKDAgility Website Development Guide

This repository contains the NKDAgility website built with Hugo. Here's what you need to know to work with this project.

## Repository Structure

- `docs/` - Documentation for the project and additional information for developers and AI
- `site/` - The main Hugo website directory
  - `content/` - All website content in Markdown format. Adding posts, pages, and images should be done only here.
    - `resources/` - All resources including blog, engineering-notes, guides, signals, and videos
    - `capabilities/` - Company page related to capabilities of our organisation. What we do and how we do it.
    - `categories/` - Categories for resources
    - `tags/` - Tags for resources
    - `concepts/` - Concepts for resources
    - `company/` - Company page related to NKDAgility
    - `outcomes/` - Corporate outcomes related to NKDAgility. What we can do for our clients.
  - `layouts/` - Hugo templates
  - `static/` - Static assets (images, CSS, JS, etc.)
  - `archetypes/` - Template files for new content (not used)
  - `data/` - YAML/JSON/TOML files used in templates
  - `hugo.yaml` - Main Hugo configuration file
  - `hugo.local.yaml`, `hugo.preview.yaml`, etc. - Environment-specific configurations
- `functions/` - Azure Functions for API functionality
- `.github/` - GitHub configuration files and workflows
- `.powershell/` - PowerShell scripts for automation (see Pre/Post Processing)

## Pre-Processing & Post-Processing

- The `.powershell/` folder contains scripts for automation, image processing, and data cleanup.
- **Pre-processing**: Scripts may run before the Hugo build to prepare content, sync data, or transform files. Example: image optimization, taxonomy generation, or data file updates.
- **Post-processing**: After Hugo builds the site, scripts in `.powershell/` are used to offload images to blob storage, rewrite image links, and clean up local files. These are invoked in CI/CD workflows and can be run locally as needed.
- See `.github/workflows/main.yaml` for how these scripts are integrated into the build and deploy process.

## Build Instructions (Hugo)

- To build the site locally:
  ```
  hugo server --source site --config hugo.yaml,hugo.local.yaml
  ```
  - This starts a local server at http://localhost:1313
- For production or other environments:
  ```
  hugo build --source site --config hugo.yaml,hugo.production.yaml
  ```
  - Replace `hugo.production.yaml` with the appropriate config for your environment.
- The build process is automated in CI/CD using GitHub Actions. See the `BuildSite` job in `.github/workflows/main.yaml`.

## Content Manipulation

- All content is in Markdown files under `site/content/`.
- To add a new page, create a new Markdown file in the appropriate subdirectory.
- Images should be placed in the same folder as the content or in a relevant subfolder.
- Use front matter to set metadata (title, description, tags, categories, etc.).
- Taxonomies (tags, categories, concepts) are defined in `hugo.yaml` and referenced in content front matter.
- Content is processed by Hugo and may be further transformed by pre/post-processing scripts.

## Layout

- Layouts are in `site/layouts/` and define the structure of pages using Hugo templating.
- Static assets (CSS, JS, images) are in `site/static/` and are served as-is.
- To change the look and feel, edit templates in `layouts/` or styles in `static/css/`.
- Use Hugo's templating features to create reusable components and partials.
- Layouts can access content, taxonomies, and data files for dynamic rendering.

## API Development

If you need to work with the Azure Functions:

1. Navigate to the functions directory
   ```
   cd functions
   ```
2. Start the Azure Functions runtime
   ```
   func start
   ```
3. In a separate terminal, start the SWA CLI to connect Hugo and Functions
   ```
   swa start http://localhost:1313 --api-location ./functions
   ```

## Key Workflows

The repository uses GitHub Actions for CI/CD:

- Pull requests trigger canary builds that are deployed to a canary environment
- Merges to main branch deploy to preview environment on https://preview.nkdagility.com
- Release tags deploy to production

## Content Management

- Content is written in Markdown format in the `site/content` directory
- Images are stored in subdirectories alongside content files
- The website uses various taxonomies (tags, categories, etc.) defined in `hugo.yaml`
