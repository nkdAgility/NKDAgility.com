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

| Section Type      | Template File                      | Documentation                                                      | Description                                       |
| ----------------- | ---------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------- |
| `audiences`       | `sections-audiences.html`          | [📖 Documented](../../../../docs/audiences-section-usage.md)       | Target audience displays                          |
| `boxesrow`        | `sections-boxesrow.html`           | [📖 Documented](../../../../docs/boxesrow-section-usage.md)        | Flexible box row layout with items                |
| `cards`           | `sections-cards.html`              | [📖 Documented](../../../../docs/cards-section-usage.md)           | Dynamic card layout with responsive columns       |
| `casestudy`       | `sections-casestudy.html`          | [📖 Documented](../../../../docs/casestudy-section-usage.md)       | Results and achievements with icons               |
| `content`         | Built-in                           | N/A                                                                | Basic content type (title only)                   |
| `counters`        | `sections-counters.html`           | [📖 Documented](../../../../docs/counters-section-usage.md)        | Animated counters and statistics                  |
| `courses`         | `sections-courses.html`            | [📖 Documented](../../../../docs/courses-section-usage.md)         | Course listings and information                   |
| `features`        | `sections-features.html`           | [📖 Documented](../../../../docs/features-section-usage.md)        | Feature showcase with icons and descriptions      |
| `headline`        | `sections-headline.html`           | [📖 Documented](../../../../docs/headline-section-usage.md)        | Hero headlines with images and buttons            |
| `list`            | `sections-list.html`               | [📖 Documented](../../../../docs/list-section-usage.md)            | Styled list with icons, titles, and content       |
| `none`            | Built-in                           | N/A                                                                | No custom content rendered only title and content |
| `options`         | `sections-consulting-options.html` | [📖 Documented](../../../../docs/options-section-usage.md)         | Consulting service options                        |
| `otherpages`      | `sections-otherpages.html`         | [📖 Documented](../../../../docs/otherpages-section-usage.md)      | Related or other page listings                    |
| `outcomeboxes`    | `sections-boxesrow.html`           | [📖 Documented](../../../../docs/outcomeboxes-section-usage.md)    | Outcome display in box format                     |
| `outcomehero`     | `sections-outcomehero.html`        | [📖 Documented](../../../../docs/outcomehero-section-usage.md)     | Hero-style outcome presentations                  |
| `phases`          | `sections-phases.html`             | [📖 Documented](../../../../docs/phases-section-usage.md)          | Project or process phases                         |
| `quote`           | `sections-quote.html`              | [📖 Documented](../../../../docs/quote-section-usage.md)           | Large stylized quotes and testimonials            |
| `sectioncta`      | `sections-sectioncta.html`         | [📖 Documented](../../../../docs/sectioncta-section-usage.md)      | Call-to-action sections                           |
| `symmetry`        | `sections-symmetry.html`           | [📖 Documented](../../../../docs/symmetry-section-usage.md)        | Symmetric table comparison layout                 |
| `taxonomies`      | `sections-taxonomies.html`         | [📖 Documented](../../../../docs/taxonomies-section-usage.md)      | Display of taxonomy terms and categories          |
| `taxonomies-card` | `sections-taxonomies-card.html`    | [📖 Documented](../../../../docs/taxonomies-card-section-usage.md) | Card-based taxonomy display                       |
| `taxonomies-list` | `sections-taxonomies-list.html`    | [📖 Documented](../../../../docs/taxonomies-list-section-usage.md) | List-style taxonomy display with badges           |
| `textNlist`       | `sections-textnlist.html`          | [📖 Documented](../../../../docs/textnlist-section-usage.md)       | Text content with accompanying list               |
| `trustpilot`      | `sections-trustpilot.html`         | [📖 Documented](../../../../docs/trustpilot-section-usage.md)      | Trustpilot review integration                     |
| `types`           | `sections-types.html`              | [📖 Documented](../../../../docs/types-section-usage.md)           | Type categorizations                              |
| `unknown`         | `section-unknown.html`             | N/A                                                                | Fallback for unrecognized types                   |
| `videos`          | `sections-videos.html`             | [📖 Documented](../../../../docs/videos-section-usage.md)          | Video content display and embedding               |

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
