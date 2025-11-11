---
description: CI/CD workflows and deployment process
applyTo: '.github/workflows/**'
---

# GitHub Workflows

The repository uses GitHub Actions for CI/CD:

- Pull requests trigger preview builds
- Merges to main branch deploy to staging
- Release tags deploy to production
