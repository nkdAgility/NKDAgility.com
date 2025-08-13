---
applyTo: "site/**"
---

# NKDAgility Hugo Site Guide (scope: `site/` only)

Focus exclusively on authoring & templating in `site/`. PowerShell automation & Functions are documented elsewhere.

## 1. Purpose

`site/` contains the Hugo Extended project generating static output into `public/` (configured via `publishDir`). It defines content, taxonomies, layouts, shortcodes, and environment-specific configuration overlays.

## 2. Directory Map

```
site/
  archetypes/          # (Optional) front matter scaffolds
  content/             # Markdown sources (edit here only)
  data/                # Structured data (YAML/JSON/TOML) for templates
  layouts/             # Templates, partials, shortcodes, section & taxonomy views
  static/              # Pass-through assets (images, css, js, fonts)
  hugo.yaml            # Base configuration
  hugo.local.yaml      # Local dev overrides (drafts+future ON)
  hugo.canary.yaml     # PR (canary) environment
  hugo.preview.yaml    # Preview environment
  hugo.production.yaml # Production environment
```

## 3. Configuration & Environments

Base `hugo.yaml` sets:

- `publishDir: ../public`, `resourceDir: ../resources`
- Output formats: `search`, `coursesJson`, plus standard `html`, `rss`, `json`
- Home outputs: HTML, `pages.json`, `rss.xml`, `search.json`
- Many taxonomies (categories, tags, concepts, marketing, course\_\* groups, delivery_audiences, customer-industries, people-abilities) powering navigation & filtering
- Custom permalinks for taxonomy & term pages; consistent slugs required for downstream automation
- Markup: `goldmark.renderer.unsafe: true` (inline HTML allowed); syntax highlighting configured

Environment overlays modify:

- `baseURL`
- `environment` name (development | canary | preview | production)
- Draft/future rendering and minification

Behavior summary:

- Local (`hugo.local.yaml`): drafts ON, future ON, expired ON, fast iteration
- Canary: drafts ON (PR validation), minify ON
- Preview: drafts OFF, future ON (to preview scheduled content)
- Production: drafts OFF, future default, minify ON

## 4. Content Authoring Guidelines

- Place new pages under logical section in `content/` (e.g., resources, training-courses, outcomes).
- Use YAML front matter (`---` delimiters) with consistent indentation.
- Assign taxonomies using plural keys from config (e.g., `categories`, `delivery_audiences`).
- For course pages include required course front matter (see course docs) or templates may render incomplete blocks.
- Use `draft: true` while iterating; it’s respected by environment toggles.
- Don’t edit generated artifacts in `public/`, `.resources/`, or `.data/`.

## 5. Layout Architecture

Top-level frame: `layouts/baseof.html` (HTML skeleton, metadata, analytics gating, breadcrumbs, headline/trustpilot sections, modular page sections, footer, optional dev debug panel).
Child templates (`single.html`, `list.html`, section/taxonomy variants) fill named blocks.

Key concepts:

- Section templates: `layouts/<section>/single.html` or `list.html`
- Taxonomy templates: `layouts/_default/terms.html` or `layouts/<taxonomy>/terms.html`
- Output format variants: e.g., `list.search.json` or `index.search.json`
- Modular page sections driven by front matter arrays & rendered via `page-sections/` partials

## 6. Partials & Shortcodes

Partials (`layouts/_partials/`) groups:

- `infrastructure/` (head tags, redirects, validation, analytics gating)
- `page-sections/` (each section type partial + dispatcher)
- Navigation (menus, breadcrumbs)
- Cards & listing components
- `jsonld/` structured data
- Utilities (icons, trustpilot)

Shortcodes (`_shortcodes/`): `recent-resources`, `resource-ref`, `nkdref`, `section-cards`, `section-videos`, `events-schedule-single`, `syllabus-single`, `youtube`, `mermaid`, `toc`, etc.
Usage: `{{< youtube id="..." >}}`. Keep logic slim; heavy data shaping belongs in partials.

Adding a shortcode:

1. Create `layouts/_shortcodes/<name>.html`
2. Access params via `.Get "param"`
3. Sanitize / escape outputs; only use `safeHTML` when intentional
4. Document usage in a draft page

## 7. Modular Page Sections

Front matter example:

```yaml
sections:
  - type: headline
    title: "Example"
  - type: features
    items: [...]
```

Dispatcher partial iterates `sections` and includes matching partial by `type`.
Add new section type:

1. Partial `layouts/_partials/page-sections/<type>.html`
2. Update dispatcher if explicit mapping required
3. Add sample usage & verify

## 8. Taxonomies & Permalinks Changes

To add a taxonomy:

1. Append to `taxonomies:` in `hugo.yaml`
2. Optional: define `permalinks.<taxonomy>` / `permalinks.<taxonomy>Term`
3. Add layouts if custom rendering needed
4. Tag content
   Renaming/removing existing taxonomies risks automation & cache breakage—avoid unless essential.

## 9. Environment Logic in Templates

Use `hugo.Environment` conditions sparingly (analytics, debug panel, heavy diagnostics). Keep structural markup consistent to avoid environment drift.

## 10. Debug Panel (Development Only)

Shown when `environment == development` (inspect: path, layout, kind, type, section, groupings, params). Do not replicate outside dev.

## 11. Creating / Modifying Templates Checklist

1. Identify target (section, taxonomy, single, list, JSON output, partial, shortcode)
2. Create/edit appropriate file under `layouts/`
3. Use `partial` or `partialCached` (provide stable key) for reusable blocks
4. If new output format: add to `outputFormats` & `outputs` in `hugo.yaml`
5. Run dev server & verify affected pages
6. Confirm no warnings/errors introduced

## 12. JSON & Search Outputs

`search.json` & `pages.json` produced via custom templates. If changing shape:

- Update consuming code (frontend / scripts)
- Use `| jsonify` for safe serialization
  Avoid manual JSON string assembly.

## 13. Performance Tips

- Prefer iterating `.Pages` scoped to a section rather than `.Site.Pages`.
- Use `where` chains instead of complex nested `if`.
- Cache expensive but deterministic partials (`partialCached "name" .cacheKey .`) — choose a key that invalidates when source context changes.
- Keep shortcodes light; move heavy logic to partials.

## 14. Common Pitfalls

| Problem                            | Likely Cause                     | Remedy                         |
| ---------------------------------- | -------------------------------- | ------------------------------ | --------------- |
| Build fails parsing front matter   | YAML indentation / missing `---` | Fix formatting                 |
| Section not rendering              | Dispatcher missing new type      | Add case / partial mapping     |
| Stale cached output                | Over-broad partial cache key     | Refine cache key               |
| Broken links after taxonomy change | Permalinks mismatch              | Update permalinks & regenerate |
| Missing analytics                  | Environment conditional wrong    | Adjust environment conditional |
| Invalid JSON                       | Manual concatenation             | Use `                          | jsonify` filter |

## 15. Local Commands

Dev (drafts, future): `hugo server --source site --config hugo.yaml,hugo.local.yaml --disableFastRender`
Preview check: `hugo --source site --config hugo.yaml,hugo.preview.yaml`
Production check: `hugo --source site --config hugo.yaml,hugo.production.yaml`
Canary: `hugo --source site --config hugo.yaml,hugo.canary.yaml`

## 16. Validation Before Commit

1. Dev server runs without errors
2. Affected pages visually correct
3. New/modified shortcodes & sections render
4. JSON outputs still valid
5. Environment gating (if added) behaves across at least one alternate build
6. No direct edits to `public/`

## 17. Principles

- Single source of truth: content lives only in `content/`
- Minimal environment divergence
- Deterministic caching only
- Prefer composition (partials) over duplication
- Keep taxonomy & permalink stability unless compelling reason
- Document new patterns inline (comments) briefly

Reference this guide first; explore code only when implementing novel patterns.

## Related Guides

- Environment Setup: `environment.instructions.md` (root prerequisites & multi-service run)
- PowerShell Automation: `powershell.instructions.md`
- Courses & Syllabus: `courses.instructions.md`
- Functions (API): `functions.instructions.md`
- Generated Artifacts: `resources.instructions.md`, `data.instructions.md`
