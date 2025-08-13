---
applyTo: ".powershell/**"
---

# NKDAgility PowerShell Guide (Focused on `.powershell` Only)

Scope: Only the structure, helpers, and usage of the `.powershell` directory. Ignore wider site & CI mechanics here. Trust this; search only if adding a brand‑new capability or something contradicts reality.

## 1. Purpose

Automates: front matter normalization, AI enrichment (description/tldr/short_title), classification & related caches, embeddings, YouTube ingestion (metadata, transcripts, captions), search index generation, economic rates, image offload & link rewriting, data cleanup. Scripts emphasize idempotency via watermarks + queue processing and fail fast (`$ErrorActionPreference='Stop'`).

## 2. Directory Overview

```
.powershell/
   _includes/        # All reusable modules (always load via IncludesForAll.ps1)
   build/            # Primary task scripts (safe entry points)
   dev/              # Experimental / developer utilities
   lib/              # Supporting libraries
   py/               # Python adjuncts (if any integration is needed)
   single-use/       # One-off or legacy scripts (avoid reusing blindly)
```

## 3. Mandatory Loader

At the very top of every runnable script:
`. ./.powershell/_includes/IncludesForAll.ps1`
This ensures: UTF-8 encoding, strict errors, logging (PoShLog), dynamic debug detection, and ordered import of all helper modules (never cherry-pick modules manually).

## 4. Key Helper Modules (Selected Highlights)

- LoggingHelper.ps1: Installs/imports PoShLog if absent; exposes `Write-InfoLog`, `Write-DebugLog`, `Write-WarningLog`, `Write-ErrorLog`, `Set-DebugMode`, `Get-IsDebug`.
- IncludesForAll.ps1: Central orchestrator that imports every dependency in the correct order (Utilities, Blob, TokenServer, OpenAI, PromptManager, HugoHelpers, ResourceHelpers, EmbeddingRepository, RelatedRepository, ClassificationHelpers, RelatedCacheHelpers, YoutubeAPI, Images, Cleanup, etc.).
- ImagesToBlobStorage.ps1: `Upload-ImageFiles` (azcopy sync), `Rewrite-ImageLinks` (regex attribute rewrite), `Delete-LocalImageFiles` (progress % logging).
- ClassificationHelpers.ps1: Builds classification catalog hashtables, processes OpenAI batch outputs, merges results, applies thresholds (score, age, count watermarks), approximate resource ID lookup resilience.
- OpenAI.ps1 + TokenServer.ps1 + PromptManager.ps1: Abstraction for chat/batch/embedding + prompt templating; call `Start-TokenServer` early if script depends on OpenAI.
- HugoHelpers.ps1 / ResourceHelpers.ps1: Enumerate & manipulate Hugo markdown resources, queue-friendly structures, front matter field CRUD.
- RelatedCacheHelpers.ps1 / EmbeddingRepository.ps1 / RelatedRepository.ps1: Compute & cache similarity/relatedness with embeddings + taxonomy interplay.

## 5. Principal Build Scripts (build/)

Invoke from repo root (examples):

- Front matter + AI: `pwsh ./.powershell/build/Update-HugoFrontMatter.ps1`
- Classifications: `pwsh ./.powershell/build/Update-ClassisificationFrontMatter.ps1`
- Related cache: `pwsh ./.powershell/build/Update-HugoRelatedCache.ps1`
- Search index: `pwsh ./.powershell/build/Build-SearchIndex.ps1`
- YouTube ingestion pipeline (order):
  1.  `Update-YoutubeChannelData.ps1`
  2.  `Update-YoutubeMarkdownFiles.ps1`
  3.  `Update-YoutubeTranscriptMarkdown.ps1`
  4.  `Generate-CombinedCaptions.ps1`
- Economic data: `Get-ExchangeRates.ps1`, `Get-TrainingRates.ps1`

Run only what your change requires. Large-scale scripts (front matter, related cache, classifications) can touch many files—avoid unnecessary diff noise.

## 6. Execution Patterns

Queue Pattern: Gather markdown objects via `Get-RecentHugoMarkdownResources` (scoped by `-YearsBack`) then enqueue for sequential processing (front matter script demonstrates). This preserves order and enables progress reporting.
Watermarks: Hard-coded date thresholds (e.g., description / tldr / short_title watermarks) limit expensive AI regeneration. Adjust deliberately if a full refresh is intended.
Field Updates: Use `Update-Field` / `Remove-Field` helpers—avoid directly editing hashtables to ensure consistent serialization.
AI Response Parsing: Strip code fences, validate JSON where applicable (classification batch parsing handles this). Always log skipped malformed AI outputs.

## 7. Image Offload Workflow (If Used Manually)

1. `Upload-ImageFiles -LocalPath <site build path> -BlobUrlBase <https://.../$web> -AzureSASToken <token>`
2. `Rewrite-ImageLinks -LocalPath <site build path> -BlobUrl <public blob prefix or /blob>`
3. `Delete-LocalImageFiles -LocalPath <site build path>`
   Ensure azcopy is installed; only rewrite after successful upload; deletion last.

## 8. OpenAI / Batch Classification Nuances

- Batch statuses: monitor with `Get-OpenAIBatchStatus`; only process completed/expired outputs.
- Results may appear with fenced JSON; pattern matching extracts JSON segment.
- Confidence & filtering: Score/age/count thresholds (e.g., `$watermarkScoreLimit`, `$watermarkAgeLimit`) enforce quality; replicate threshold usage if extending classification logic.

## 9. Logging & Debugging

- Automatic debug elevation when debugger/VS Code/Verbose preferences detected.
- To force debug: `Set-DebugMode -EnableDebug:$true` after includes.
- Progress: For long loops log every N% (see image deletion & batch processing examples).
- Keep error logs specific; rely on intrinsic `Stop` behavior to avoid silent failures.

## 10. Generated & Cache Files

- Temporary / derived data in `.data/` (e.g., batch outputs, classification interim JSON) must not be manually edited.
- If a rebuild is necessary (e.g., schema changes), document & limit scope (e.g., reduce `YearsBack`).

## 11. Creating a New Script (Template Steps)

1. Add to `.powershell/build/Your-ScriptName.ps1`.
2. Dot-source includes loader first line.
3. (Optional) Parameters for scope (e.g., `-YearsBack 2`, `-Classification tags`).
4. Collect resources with minimal scope.
5. Implement queue; log counts; respect watermarks.
6. Use helpers for any front matter or classification mutation.
7. Provide safe fallbacks (skip & log rather than partial writes on AI errors).
8. Return summary metrics (counts processed, skipped, regenerated) via `Write-InfoLog`.

## 12. Common Failure Modes (Focused)

| Problem                 | Cause                                 | Action                                              |
| ----------------------- | ------------------------------------- | --------------------------------------------------- |
| Missing functions       | Forgot includes loader                | Add `. ./.powershell/_includes/IncludesForAll.ps1`  |
| Repeated AI regen       | Watermark lowered or removed          | Restore watermark or consciously accept larger diff |
| Large unwanted diff     | Ran multiple heavy scripts            | Revert & rerun minimal subset                       |
| Classification mismatch | Resource title/ID changed after batch | Re-run batch or adjust approximate lookup logic     |
| AzCopy errors           | Tool absent/auth invalid              | Install azcopy & validate SAS token                 |
| PoShLog install blocked | No Gallery access                     | Pre-install module or vendor it temporarily         |

## 13. Quick Commands

Front matter: `pwsh ./.powershell/build/Update-HugoFrontMatter.ps1`
Classifications: `pwsh ./.powershell/build/Update-ClassisificationFrontMatter.ps1`
Related cache: `pwsh ./.powershell/build/Update-HugoRelatedCache.ps1`
Search index: `pwsh ./.powershell/build/Build-SearchIndex.ps1`
YouTube full ingest: run the 4-step pipeline in order (see §5)
Exchange rates: `pwsh ./.powershell/build/Get-ExchangeRates.ps1`
Training rates: `pwsh ./.powershell/build/Get-TrainingRates.ps1`

## 14. Principles (Strictly for `.powershell` Work)

- ALWAYS load via IncludesForAll.
- MINIMIZE scope (YearsBack, specific folders) before broad runs.
- RESPECT watermarks; change only with intent.
- LOG clearly; prefer explicit progress + skip messages.
- DO NOT hand-edit generated `.data/` or `.resources/` outputs.
- TRUST this guide; search only for novel patterns.
