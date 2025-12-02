---
description: Implementing sections for the NKDAgility.com website using Hugo page sections
applyTo: "site/layouts/_partials/page-sections/**"
---

# Page Sections Copilot Instructions

This document provides comprehensive guidance for working with Hugo page sections in the NKDAgility.com website. Each section type has specific functionality and configuration options.

## Section System Architecture

The page section system uses a router-based approach:

- `section-router.html` - Central routing logic that maps section types to their templates
- `section-header.html` - Handles common section headers and titles
- `section-wrapper.html` - Provides consistent wrapping and styling
- `sections.html` - Main entry point for processing page sections
- `headlines.html` - Specialized template for rendering headline sections with sidebar navigation

## Available Section Types

**📋 Section Registry**: See `.github/sections-registry.json` for the complete, machine-readable list of all section types.

The registry contains:

- Section type identifier and name
- Template filename
- Documentation links
- Description and when to use guidance
- Category classification
- Usage restrictions and common mistakes

### Quick Reference by Category

**Outcome & Transformation:**
`outcomehero`, `outcomeboxes`, `casestudy`

**Feature & Benefit:**
`features`, `list`, `textNlist`

**Comparison:**
`boxesrow`, `symmetry`, `options`

**Social Proof:**
`quote`, `trustpilot`, `cards`

**Statistics:**
`counters`

**Action & Navigation:**
`sectioncta`, `otherpages`

**Specialized:**
`audiences`, `phases`, `courses`, `taxonomies`, `taxonomies-card`, `taxonomies-list`, `types`, `videos`

**Hero:**
`headline` (only ONE per page)

**System:**
`content`, `none`, `unknown` (avoid intentional use)

## Section Selection Guidelines

### Marketing Pages vs Content Pages

**Marketing pages** (course pages, service pages, landing pages):

- Need **visual variety** - use 6-10 different section types per page
- Break content into **shorter blocks** (2-4 paragraphs maximum per section)
- Focus on **buyer outcomes** not methodology or teaching content
- Use **outcomehero** for key messages, not quote sections
- Avoid repeated section types - vary the presentation

**Content pages** (blog posts, resources, documentation):

- Can use longer text blocks
- Fewer section types needed
- Educational content appropriate

### Common Section Type Mistakes

| ❌ Wrong Choice              | ✅ Correct Choice        | Why                                                         |
| ---------------------------- | ------------------------ | ----------------------------------------------------------- |
| Multiple `headline` sections | ONE headline only        | Headline creates H1 - only one per page for SEO             |
| `quote` for non-quotes       | `outcomehero`            | Quote only for actual attributed quotations                 |
| `symmetry` for simple text   | `boxesrow` or `features` | Symmetry only for structured comparison tables              |
| `content` on marketing pages | `outcomehero` or `list`  | Content sections are visually boring                        |
| All text in one section      | Multiple varied sections | Break long text into 6-10 visually distinct section types   |
| Generic stats irrelevant     | Outcome-focused counters | Counters must relate to buyer's pain or desired improvement |

### Section Selection Decision Tree

**To display a key outcome or transformation:**

- Single critical message with prominence → `outcomehero`
- 2-3 outcomes in boxes → `outcomeboxes` or `boxesrow`
- Quantified results with icons → `casestudy`

**To list benefits or features:**

- 3-7 items with icons → `features`
- More detailed items with icons and longer text → `list`
- Side-by-side text + bullets → `textNlist`

**To compare options:**

- 2-3 options side-by-side → `boxesrow`
- Structured feature comparison table → `symmetry` (rarely needed)

**To display social proof:**

- Actual customer quote → `quote` (with attribution)
- Review widget → `trustpilot`
- Multiple testimonials → `cards`

**To show statistics:**

- 2-4 pain or outcome metrics → `counters`

**To prompt action:**

- Enrol, contact, view schedule → `sectioncta`

## Usage Guidelines

### Basic Section Structure

All sections follow this basic YAML structure:

```yaml
headlines:
  - type: "section-type"
    title: "Section Title"
    content: "Section description (supports Markdown)"
sections:
  - type: "section-type"
    title: "Section Title"
    content: "Section description (supports Markdown)"
    # Additional parameters specific to each section type
```

headlines is optional and used for sections that require a sidebar.

### Common Parameters

Most sections support these common parameters:

- `type`: Required - the section type identifier
- `title`: Optional - section title
- `content`: Optional - section description (supports Markdown)

### Parameter Context

Templates receive parameters through different context objects:

- Standard sections: `dict "site" $site "page" $page "context" $section`
- Features/Options: `dict "Page" $page "site" $site "context" $section`
- Courses/Videos/Cards/Counters: `dict "site" $site "context" $section`

## Documentation Standards

When documenting sections, include:

1. **Overview**: Purpose and use cases
2. **Basic Structure**: YAML example with minimal configuration
3. **Parameters**: Required and optional parameters with descriptions
4. **Features**: Key capabilities and behaviors
5. **Examples**: Multiple use cases with complete YAML
6. **Styling**: CSS classes and customization options
7. **Best Practices**: Recommendations and common patterns

## ⚠️ CRITICAL: Property Name Validation Rules

**ALWAYS verify property names against the actual template implementation before making changes.**

### Common Property Mistakes to Avoid

| Section Type | ❌ WRONG Property         | ✅ CORRECT Property     | Notes                                                      |
| ------------ | ------------------------- | ----------------------- | ---------------------------------------------------------- |
| `headline`   | `heading.text`            | `headline.title`        | Uses `headline` object with `title`, `subtitle`, `content` |
| `headline`   | `heading.content`         | `headline.content`      | Content goes in headline object                            |
| `features`   | `items`                   | `features`              | Array of feature objects                                   |
| `features`   | `name`                    | `title`                 | Each feature item uses `title` not `name`                  |
| `textNlist`  | Direct string array       | Objects with `content:` | List items MUST be `{content: "text"}` objects             |
| `textNlist`  | `content` (section level) | `sideContent`           | Left column content uses `sideContent`                     |
| `sectioncta` | `text` (in cta)           | `content`               | CTA text uses `content` property                           |
| `sectioncta` | `link` (in button)        | `url`                   | Button link uses `url` not `link`                          |
| `otherpages` | `source`                  | `related`               | Array of page paths uses `related`                         |
| `casestudy`  | Direct string array       | Objects with `content:` | List items MUST be objects                                 |
| `list`       | -                         | -                       | Items use `title`, `icon`, `content` properties            |
| `cards`      | -                         | -                       | Items use `title`, `content`, `button` properties          |

### Property Verification Process

Before making any changes to section structures:

1. **Read the template file** in `site/layouts/_partials/page-sections/sections-{type}.html`
2. **Identify the exact property names** used in the template (e.g., `$section.related`, `$item.content`)
3. **Match the documentation** to use those exact property names
4. **Never assume** property names based on similar sections - always verify
5. **Test with a build** to ensure the section renders correctly

### Template Property Patterns

Templates access properties in these patterns:

```go
{{- $section.propertyName }}           // Section-level property
{{- range $section.arrayName }}        // Loop through array
  {{- .itemProperty }}                 // Item-level property
{{- end }}
```

Example from `textNlist`:

```go
{{- $section.sideContent }}            // NOT $section.content!
{{- range $section.list }}
  {{- $item.content }}                 // NOT just the string!
  {{- $item.icon }}
{{- end }}
```

Example from `otherpages`:

```go
{{- $filteredItems := index .context .context.source }}  // This line is broken!
// Should actually use: $section.related directly
```

## Adding New Sections

To add a new section type:

1. Create the template file in `site/layouts/_partials/page-sections/`
2. Add the routing entry in `section-router.html`
3. Create documentation following the standard format
4. Update this copilot-instructions.md file
5. Test with various configurations

## Error Handling

Unknown section types are handled by `section-unknown.html` which:

- Shows a warning in development mode
- Lists available section types for debugging
- Provides graceful fallback in production
