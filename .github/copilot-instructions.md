# NKDAgility Website Development Guide

This repository contains the NKDAgility website built with Hugo. Here's what you need to know to work with this project.

## Repository Structure

- `site/` - The main Hugo website directory

  - `content/` - All website content in Markdown format
  - `layouts/` - Hugo templates
  - `static/` - Static assets (images, CSS, JS, etc.)
  - `archetypes/` - Template files for new content
  - `data/` - YAML/JSON/TOML files used in templates
  - `hugo.yaml` - Main Hugo configuration file
  - `hugo.local.yaml`, `hugo.preview.yaml`, etc. - Environment-specific configurations

- `functions/` - Azure Functions for API functionality
- `.github/` - GitHub configuration files and workflows
- `.powershell/` - PowerShell scripts for automation

## Local Development Setup

### Prerequisites

1. Install Hugo Extended version

   ```
   winget install hugo
   ```

2. Install Static Web Apps CLI

   ```
   npm install -g @azure/static-web-apps-cli
   ```

3. Install Azure Functions Core Tools

   ```
   npm i -g azure-functions-core-tools@4 --unsafe-perm true
   ```

4. Install .NET 10 SDK from https://dotnet.microsoft.com/download/dotnet/10.0

5. Install PowerShell 7+
   ```
   winget install Microsoft.PowerShell
   ```

### Running the Website Locally

1. Clone the repository

   ```
   git clone https://github.com/nkdAgility/NKDAgility.com.git
   cd NKDAgility.com
   ```

2. Start the Hugo development server

   ```
   hugo server --source site --config hugo.yaml,hugo.local.yaml
   ```

   Note, the build can take more than 30 seconds to run.

3. View the site at http://localhost:1313

### Building for Production

To build the site for production or other environments:

```
hugo build --source site --config hugo.yaml,hugo.local.yaml
```

Note, the build can take more than 30 seconds to run.

This is the typical command used from the root of the repo. For different environments, replace `hugo.local.yaml` with the appropriate config file (`hugo.preview.yaml`, `hugo.production.yaml`, etc.).

The command specified in the issue is:

```
hugo build --source .\site --config hugo.yaml,hugo.local.yaml
```

### API Development

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

- Pull requests trigger preview builds
- Merges to main branch deploy to staging
- Release tags deploy to production

## Content Management

- Content is written in Markdown format in the `site/content` directory
- Images are stored in subdirectories alongside content files
- The website uses various taxonomies (tags, categories, etc.) defined in `hugo.yaml`

## Course and Syllabus Management

NKD Agility uses a standardized system for managing training course content:

### Course Structure Standards

- All courses use the **immersive format** with assignments between sessions
- Course content uses external `syllabus.yaml` files for better maintainability
- Course information is stored in the course's front matter

### Required Course Front Matter Fields

When creating or updating course content, ensure these fields are present:

```yaml
course_code: "PSM" # Unique course identifier (e.g., "APS", "PAL-E") Load from `code` field in front matter if present.
course_length: 16 # Total course duration in hours
course_sessions: 8 # Number of sessions (typically course_length / 2)
description: "Course description and learning objectives..."
delivery-audiences: # Target audience list
  - "Scrum Masters"
  - "Product Owners"
course-learning-experiences:
  - "Immersive" # Standard format for all courses
```

### Syllabus System

- **File Location**: `syllabus.yaml` in the course directory
- **Structure**: Sessions with assignments, learning resources, and reflection components
- **Assignment Design**: Outcome-focused rather than output-focused
- **Documentation**: See `docs/syllabus-system.md` for detailed guidance

### Issue Templates

Use `.github/ISSUE_TEMPLATE/update-syllabus.yml` for syllabus updates:

- Automatically extracts course info from front matter using course code
- Updates both syllabus.yaml and course front matter fields
- Validates assignment design against immersive format principles
