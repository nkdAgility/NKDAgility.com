---
applyTo: "README.md"
---

# NKDAgility Development Environment Guide (root setup & cross-component)

## 1. Repository Components (High-Level)

- `site/` Hugo static site (Hugo Extended, build ~30–60s on cold start).
- `functions/` Azure Functions (API).
- `.powershell/` Automation scripts (front matter, AI enrichment, classification, search, media).
- `.resources/` Generated reference copies (read-only; never edit, regenerate via scripts).
- `.data/` Generated data artifacts (read-only; ephemeral, reproducible).
- `.github/` Workflow & automation configs (GitHub Actions, issue templates, versioning config).

## 2. Prerequisites (Install Once)

| Tool                       | Command / Source                                           |
| -------------------------- | ---------------------------------------------------------- |
| Hugo Extended              | `winget install hugo`                                      |
| SWA CLI                    | `npm install -g @azure/static-web-apps-cli`                |
| Azure Functions Core Tools | `npm i -g azure-functions-core-tools@4 --unsafe-perm true` |
| .NET 8 / (future 10) SDK   | https://dotnet.microsoft.com/download                      |
| PowerShell 7+              | `winget install Microsoft.PowerShell`                      |

## 3. Clone & Run (Core Loop)

```

git clone https://github.com/nkdAgility/NKDAgility.com.git
cd NKDAgility.com
hugo server --source site --config hugo.yaml,hugo.local.yaml

```

Browse: http://localhost:1313

## 4. Add API Runtime (Optional During Site Dev)

Terminal 1: Hugo server (above).
Terminal 2:

```

cd functions
func start

```

Terminal 3 (root):

```

swa start http://localhost:1313 --api-location ./functions

```

## 5. Production / Other Builds

```

hugo build --source site --config hugo.yaml,hugo.production.yaml
hugo build --source site --config hugo.yaml,hugo.preview.yaml

```

Swap second config for environment (canary/preview/production/local).

## 6. Automation Scripts (Selective Use)

Invoke only what you need (see `.powershell` guide). Examples:

```

pwsh ./.powershell/build/Update-HugoFrontMatter.ps1
pwsh ./.powershell/build/Build-SearchIndex.ps1

```

## 7. CI/CD Flow

- Pull Request ⇒ Canary build (preview ring) & environment-specific baseURL.
- Merge to `main` ⇒ Staging / preview ring.
- Release tag ⇒ Production deployment.
  ("Staging" here maps to the preview ring.)
  GitVersion determines ring & environment naming; workflow sets `baseURL` & blob / image host resolution.

## 8. Content Editing Basics

- Edit only under `site/content/**`.
- Use YAML front matter; keep taxonomy keys consistent.
- NEVER edit `.resources/` or `.data/` manually.

## 9. Course & Syllabus Quick Reference

See `courses.instructions.md` (applies to `site/content/course_*`). Ensure required front matter & `syllabus.yaml` present.

## 10. Troubleshooting Cheatsheet

| Symptom                  | Likely Cause               | Action                                   |
| ------------------------ | -------------------------- | ---------------------------------------- |
| Hugo slow start          | Large regeneration         | Limit scope or disable heavy scripts     |
| Missing API responses    | Functions host not running | Start `func start`                       |
| Broken links after build | Permalink config change    | Rebuild & verify taxonomy templates      |
| Repeated AI edits        | Watermark lowered          | Restore watermark (see PowerShell guide) |
| 404 on canary URLs       | Incorrect baseURL/ring     | Inspect workflow output & config merge   |

## 11. Principles

- Minimal necessary scope each run.
- Environment parity—avoid code branching unless essential.
- Generated artifacts are disposable & reproducible (never hand-edit `.resources` / `.data`).
- Reference specialized instructions (site, powershell, courses) first.
