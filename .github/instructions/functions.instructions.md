---
applyTo: "functions/**"
---

# NKDAgility Azure Functions Guide (scope: `functions/` only)

## 1. Purpose

Provides API endpoints & server capabilities (auth helpers, future integrations) consumed by the static site via Azure Static Web Apps (SWA).

## 2. Tech Stack Overview

- .NET 8 isolated worker (`Microsoft.Azure.Functions.Worker` preview packages) — roadmap: migrate to .NET 10 once stable & packages exit preview.
- Application Insights telemetry (`AddApplicationInsightsTelemetryWorkerService`)
- HTTP triggers (Extensions.Http / AspNetCore)

## 3. Project Layout

```

functions/
Program.cs # Host builder & DI
\*.cs # Function classes (HTTP triggers, etc.)
host.json # Runtime config (logging, concurrency)
local.settings.json # Local secrets/settings (NOT committed)
functions.csproj # Dependencies
bin/ obj/ # Build outputs (ignore edits)

```

## 4. Local Development

Restore & build:

```

dotnet build functions/functions.csproj

```

Run Functions host (from `functions/` or project root specifying path):

```

func start

```

Run SWA (in another terminal) to unify with Hugo site already running on :1313:

```

swa start http://localhost:1313 --api-location ./functions

```

## 5. Adding a New Function

1. Create `<Name>Function.cs` with a `public static` method or instance method if DI needed.
2. Add `[Function("Name")]` and `[HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "...path...")]` parameters.
3. Use DI by adding services in `Program.cs` (`ConfigureServices`).
4. Return `HttpResponseData` with proper status + content type.
5. Log via `ILogger` or `FunctionContext.GetLogger` (ensure no sensitive data).

## 6. Configuration & Secrets

- Local secrets in `local.settings.json` (not committed).
- Production keys managed via Azure SWA configuration / Key Vault (not in repo).
- Avoid hardcoded secrets; use environment variables (prefixed if necessary).

## 7. Telemetry

Application Insights auto-collects traces & dependencies.

- Add custom logs sparingly; prefer structured messages.
- Correlation flows automatically for a single request; include operation IDs only if cross-system correlation required.

## 8. Preview / Canary Behavior

Distinguished by environment variables injected by GitHub Actions & SWA (e.g., ring, environment). If branching logic is added, isolate it in a small helper to keep functions testable.

## 9. Testing

- Lightweight: create a test project (future improvement) referencing the functions assembly.
- For now: manual curl / browser calls via local host after `func start`.

## 10. Deployment Flow (High-Level)

CI builds site + functions, then SWA deploy handles packaging. Avoid manual publish unless debugging (`dotnet publish -c Release`).

## 11. Performance & Reliability Tips

- Keep cold start low: avoid heavy static initialization.
- Use async I/O (HttpClient reuse via DI singleton if added).
- Prefer small, composable functions over monoliths.

## 12. Common Pitfalls

| Issue                | Cause                             | Fix                                          |
| -------------------- | --------------------------------- | -------------------------------------------- |
| 404 for function     | Route mismatch                    | Confirm `[Function]` attribute & route path  |
| Missing env setting  | Not in local.settings.json        | Add key & restart host                       |
| Telemetry silent     | Instrumentation key misconfigured | Ensure AI connection set in Azure / env vars |
| Preview config drift | Conditional logic in code         | Centralize environment branching             |

## 13. Principles

- Keep function code minimal; push business logic to plain services.
- Avoid premature optimization; measure with AI logs.
- No secrets in code or logs.
- Reference this guide first; explore only for novel patterns.
