---
applyTo: "site/layouts/**"
---

# NKDAgility Hugo Layouts Guide (Modern Layout Architecture)

Scope: ONLY `site/layouts/**` (templates, partials, shortcodes, output format JSON, infrastructure). For content authoring see `site.instructions.md`.

## 1. Philosophy (Modern Hugo)

- Single `baseof.html` defines page chrome (head, analytics gating, nav, breadcrumbs, headline, dynamic page sections, footer, environment debug panel).
- Content pages supply structured front matter (sections array) rendered by modular partials under `page-sections/`.
- Heavy reusable logic isolated in namespaced partial groups (infrastructure, components, jsonld, page-sections).
- Caching (`partialCached`) used only for deterministic, environment-stable outputs (taxonomy validation, publish redirects) to reduce build time.

## 2. Key Entry Layouts

```
baseof.html          # Master frame; defines blocks (breadcrumbs, headline, main, siteSectionCallback)
index.html           # Home overrides (if any)
index.search.json    # Custom search output format
list.html / list.json# Section & list rendering (fallback)
single.html          # Fallback single page template
section.rss.xml      # RSS feed for sections
sitemap.xml          # Site map
404.html             # Error page
robots.txt           # Robots directives
```

Custom section/taxonomy templates (e.g., `resources/`, `course/`, `categories/`, `tags/`, `concepts/`) override defaults when present.

## 3. Directory Groups

```
_partials/
  infrastructure/     # head, redirects, validation, footer, header, breadcrumbs
  page-sections/      # modular section partials + dispatcher (sections.html)
  components/         # widgets (trustpilot, icon globals, etc.)
  jsonld/             # structured data (schema.org) partials
  functions/          # helper partials (utility transforms)
_shortcodes/          # markdown-level embeds (youtube, mermaid, recent-resources, etc.)
_markup/              # (If used) markup render hooks (e.g., images, links)
```

## 4. Modern Blocks & Overrides

`baseof.html` defines blocks consumed/overridden by page type templates:

- `breadcrumbs` (default renders breadcrumbs partial)
- `headline` (default hero + trustpilot carousel for non-home pages)
- `main` (injects modular page sections renderer)
- `siteSectionCallback` (post-main connection/callback CTA region)
  To create a specialized layout (e.g., a landing page): define a template file and override one or more blocks:

```html
{{ define "main" }}
<section class="container my-5">{{ partial "page-sections/sections.html" . }} {{/* or custom composition */}}</section>
{{ end }}
```

## 5. Modular Page Sections Pattern

Front matter example:

```yaml
sections:
  - type: headline
    title: "Agility Accelerated"
  - type: features
    items:
      - title: Value Stream
        icon: bolt
```

Dispatcher: `_partials/page-sections/sections.html` loops `.Params.sections` and includes matching partial (`page-sections/<type>.html`).
Add a new section type:

1. Create `_partials/page-sections/<type>.html`.
2. Keep interface: receives full `.Page` context; section data accessible via the loop variable.
3. (If needed) update any switch or mapping logic inside dispatcher.
4. Add minimal CSS/JS in `static/` or integrate existing utility classes.
5. Test with dev server.

## 6. Shortcodes Guidelines

- Implement in `_shortcodes/<name>.html`.
- Access params via `.Get "param"`.
- Keep logic minimal; heavy data shaping → partial in `functions/` or `infrastructure/`.
- Avoid site-wide iteration inside shortcodes (performance). Pre-compute sets or rely on `.Page` context.
- Sanitize output; only use `safeHTML` intentionally.

## 7. Output Formats & JSON

- `index.search.json` builds site search index (home output format `search`).
- `list.json` / custom JSON templates enabled via `outputs` in `hugo.yaml`.
  Adding a new JSON output:

1. Define output format in `hugo.yaml` under `outputFormats` + attach to a kind in `outputs`.
2. Create template `index.<format>.json` (home) or `list.<format>.json` (section) or `single.<format>.json`.
3. Serialize via `.| jsonify` to guarantee valid JSON.

## 8. Partial Caching Rules

Use `partialCached` ONLY when:

- Input (context + explicit keys) fully determines output.
- No environment-specific differences (unless key includes environment).
  Examples in `baseof.html` (taxonomy validation, redirects). Include a discriminatory key if output depends on current page (e.g., `.RelPermalink`).

## 9. Environment-Aware Rendering

`hugo.Environment` drives:

- Analytics & consent scripts (only `preview` + `production`).
- Debug panel (development only) with introspection table (path, template, layout, kind, type, section, ancestors, grouped pages).
  Avoid environment branching in content structure; keep differences to instrumentation & diagnostics.

## 10. Adding a Custom Section or Taxonomy Template

1. Create directory: `site/layouts/<section>/` or `<taxonomy>/`.
2. Add `list.html` or `single.html` depending on need.
3. Override blocks selectively, reuse partials.
4. Validate with dev server + at least one alternate environment build (`preview`/`production`).

## 11. Naming & Conventions

- Lowercase filenames (`headline.html`, `resources-card.html`).
- Hyphenate multi-word partial names.
- Keep experimental / deprecated partials prefixed (`zz.`) until removal.
- Place helper-only partials (no direct output) under `functions/` for clarity.

## 12. Performance Tips

| Concern                  | Guidance                                                                   |
| ------------------------ | -------------------------------------------------------------------------- |
| Large loops              | Filter early with `where`, avoid full `.Site.Pages` unless necessary       |
| Repeated taxonomy checks | Cache if deterministic                                                     |
| Shortcode overhead       | Keep loops shallow; prefer partial + front matter over shortcode iteration |
| CSS/JS bloat             | Centralize in `static/` and reference once in head/footer partials         |

## 13. Common Pitfalls

| Problem               | Cause                                   | Resolution                                                                         |
| --------------------- | --------------------------------------- | ---------------------------------------------------------------------------------- | -------- |
| Section not rendering | Missing section partial or wrong `type` | Add partial named exactly `<type>.html`                                            |
| Cached stale output   | Over-broad cache key                    | Refine key or remove caching                                                       |
| JSON invalid          | Manual concatenation                    | Always use `                                                                       | jsonify` |
| Analytics in dev      | Condition misapplied                    | Wrap in `if or (eq hugo.Environment "preview") (eq hugo.Environment "production")` |
| Missing styles        | New section lacks classes               | Reuse existing utility classes / add minimal CSS                                   |

## 14. Extending Debug Panel (Optional)

Add rows inside the development-only block in `baseof.html`; keep cheap evaluations only. Do NOT expose in non-development environments.

## 15. Change Checklist (Layouts)

1. Define scope (partial, shortcode, template, JSON output).
2. Implement minimal change.
3. Run local server (development env) & verify target pages.
4. Build with another env config (e.g., preview) to catch environment gating issues.
5. Confirm no unexpected diffs or performance regressions (watch build time).
6. Document new section/shortcode briefly if novel.

## 16. Principles

- DRY via partials, not copy-paste.
- Deterministic caching only; purge uncertainty.
- Minimal environment branching.
- Modular sections drive page assembly (extensible, testable).
- Validate JSON outputs; never handcraft raw JSON strings.

Reference this guide first; explore code only for new patterns.
