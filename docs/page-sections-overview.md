# Page Sections Overview

This document provides a comprehensive overview of all available page sections in the Hugo website. Each section type has specific functionality and configuration options.

## Section System Architecture

The page section system uses a router-based approach where:

- `section-router.html` - Central routing logic that maps section types to their templates
- `section-header.html` - Handles common section headers and titles
- `section-wrapper.html` - Provides consistent wrapping and styling
- `sections.html` - Main entry point for processing page sections

## Available Section Types

### Content Display Sections

| Section Type | Template File             | Documentation                               | Description                                  |
| ------------ | ------------------------- | ------------------------------------------- | -------------------------------------------- |
| `list`       | `sections-list.html`      | [✅ Documented](list-section-usage.md)      | Styled list with icons, titles, and content  |
| `textNlist`  | `sections-textnlist.html` | [✅ Documented](textnlist-section-usage.md) | Text content with accompanying list          |
| `cards`      | `sections-cards.html`     | [✅ Documented](cards-section-usage.md)     | Dynamic card layout with responsive columns  |
| `features`   | `sections-features.html`  | [✅ Documented](features-section-usage.md)  | Feature showcase with icons and descriptions |

### Interactive & Media Sections

| Section Type | Template File              | Documentation                                | Description                            |
| ------------ | -------------------------- | -------------------------------------------- | -------------------------------------- |
| `quote`      | `sections-quote.html`      | [✅ Documented](quote-section-usage.md)      | Large stylized quotes and testimonials |
| `videos`     | `sections-videos.html`     | [✅ Documented](videos-section-usage.md)     | Video content display and embedding    |
| `trustpilot` | `sections-trustpilot.html` | [✅ Documented](trustpilot-section-usage.md) | Trustpilot review integration          |
| `counters`   | `sections-counters.html`   | [✅ Documented](counters-section-usage.md)   | Animated counters and statistics       |

### Outcome & Results Sections

| Section Type   | Template File                | Documentation                                  | Description                         |
| -------------- | ---------------------------- | ---------------------------------------------- | ----------------------------------- |
| `casestudy`    | `sections-casestudy.html`    | [✅ Documented](casestudy-section-usage.md)    | Results and achievements with icons |
| `outcomehero`  | `sections-outcomehero.html`  | [✅ Documented](outcomehero-section-usage.md)  | Hero-style outcome presentations    |
| `outcomeboxes` | `sections-outcomeboxes.html` | [✅ Documented](outcomeboxes-section-usage.md) | Outcome display in box format       |

### Navigation & Organization Sections

| Section Type | Template File              | Documentation                                | Description                              |
| ------------ | -------------------------- | -------------------------------------------- | ---------------------------------------- |
| `sectioncta` | `sections-sectioncta.html` | [✅ Documented](sectioncta-section-usage.md) | Call-to-action sections                  |
| `taxonomies` | `sections-taxonomies.html` | [✅ Documented](taxonomies-section-usage.md) | Display of taxonomy terms and categories |
| `otherpages` | `sections-otherpages.html` | [✅ Documented](otherpages-section-usage.md) | Related or other page listings           |

### Business & Course Sections

| Section Type | Template File                      | Documentation                               | Description                     |
| ------------ | ---------------------------------- | ------------------------------------------- | ------------------------------- |
| `courses`    | `sections-courses.html`            | [✅ Documented](courses-section-usage.md)   | Course listings and information |
| `audiences`  | `sections-audiences.html`          | [✅ Documented](audiences-section-usage.md) | Target audience displays        |
| `options`    | `sections-consulting-options.html` | [✅ Documented](options-section-usage.md)   | Consulting service options      |
| `phases`     | `sections-phases.html`             | [✅ Documented](phases-section-usage.md)    | Project or process phases       |
| `types`      | `sections-types.html`              | [✅ Documented](types-section-usage.md)     | Type categorizations            |

### Specialized Sections

| Section Type      | Template File                   | Documentation                                     | Description                 |
| ----------------- | ------------------------------- | ------------------------------------------------- | --------------------------- |
| `taxonomies-card` | `sections-taxonomies-card.html` | [✅ Documented](taxonomies-card-section-usage.md) | Card-based taxonomy display |

### System Sections

| Section Type | Template File          | Documentation | Description                     |
| ------------ | ---------------------- | ------------- | ------------------------------- |
| `content`    | Built-in               | N/A           | Basic content type (title only) |
| `none`       | Built-in               | N/A           | No content rendered             |
| `unknown`    | `section-unknown.html` | N/A           | Fallback for unrecognized types |

## Documentation Status

### ✅ Fully Documented (23 sections)

- [audiences](audiences-section-usage.md)
- [boxesrow](boxesrow-section-usage.md)
- [cards](cards-section-usage.md)
- [casestudy](casestudy-section-usage.md)
- [counters](counters-section-usage.md)
- [courses](courses-section-usage.md)
- [features](features-section-usage.md)
- [headline](headline-section-usage.md)
- [list](list-section-usage.md)
- [options](options-section-usage.md)
- [otherpages](otherpages-section-usage.md)
- [outcomeboxes](outcomeboxes-section-usage.md)
- [outcomehero](outcomehero-section-usage.md)
- [phases](phases-section-usage.md)
- [quote](quote-section-usage.md)
- [sectioncta](sectioncta-section-usage.md)
- [symmetry](symmetry-section-usage.md)
- [taxonomies](taxonomies-section-usage.md)
- [taxonomies-card](taxonomies-card-section-usage.md)
- [taxonomies-list](taxonomies-list-section-usage.md)
- [textnlist](textnlist-section-usage.md)
- [trustpilot](trustpilot-section-usage.md)
- [types](types-section-usage.md)
- [videos](videos-section-usage.md)

### 📝 System Components (No documentation needed)

- content (Built-in basic content type)
- none (Built-in no content type)
- unknown (System fallback)
- router (Section routing logic)

## Common Configuration Patterns

Most sections follow these common patterns:

### Basic Structure

```yaml
sections:
  - type: "section-type"
    title: "Section Title"
    content: "Section description"
    # Section-specific parameters
```

### Background Options

Many sections support:

```yaml
backgroundColor: primary | secondary | none
```

### Content Support

Most sections support Markdown in content fields and can include:

- **Bold text**
- _Italic text_
- [Links](https://example.com)
- Lists and other Markdown elements

## Getting Started

To add a new section to a page:

1. Edit your page's front matter
2. Add a section to the `sections` array
3. Specify the `type` and required parameters
4. Refer to the specific section documentation for detailed configuration

## Contributing Documentation

When documenting a new section type:

1. Create a file named `{section-type}-section-usage.md` in the `docs/` folder
2. Follow the existing documentation format:
   - Overview and description
   - Basic structure with YAML example
   - Parameter explanations
   - Examples and use cases
3. Update this overview page to link to the new documentation
4. Include examples of different configuration options

For questions or contributions, please refer to the main project documentation.
