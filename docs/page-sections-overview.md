# Page Sections Overview

This document provides a comprehensive overview of all available page sections in the Hugo website. Each section type has specific functionality and configuration options.

## Section System Architecture

The page section system uses a router-based approach where:

- `section-router.html` - Central routing logic that maps section types to their templates
- `section-header.html` - Handles common section headers and titles
- `section-wrapper.html` - Provides consistent wrapping and styling
- `sections.html` - Main entry point for processing page sections

## Section Registry

**📋 Complete Section Registry**: See [`../.github/sections-registry.json`](../.github/sections-registry.json) for the machine-readable registry of all section types.

The registry contains:

- Section type identifiers and names
- Template filenames
- Documentation links
- Descriptions and "when to use" guidance
- Category classifications
- Usage restrictions and common mistakes

## Available Section Types

### Hero Sections

- **[headline](headline-section-usage.md)** - Hero headlines with images and buttons
  - ⚠️ **Page opening only** (H1 rule: only ONE per page)

### Outcome & Transformation Sections

- **[outcomehero](outcomehero-section-usage.md)** - Hero-style outcome presentations with boxes and CTA
- **[outcomeboxes](outcomeboxes-section-usage.md)** - Outcome display in box format
- **[casestudy](casestudy-section-usage.md)** - Results and achievements with icons

### Feature & Benefit Sections

- **[features](features-section-usage.md)** - Feature showcase with icons and descriptions
- **[list](list-section-usage.md)** - Styled list with icons, titles, and content
- **[textNlist](textnlist-section-usage.md)** - Text content with accompanying list

### Comparison Sections

- **[boxesrow](boxesrow-section-usage.md)** - Flexible box row layout for comparing options
- **[symmetry](symmetry-section-usage.md)** - Symmetric table comparison layout
- **[options](options-section-usage.md)** - Consulting service options

### Social Proof Sections

- **[quote](quote-section-usage.md)** - Large stylized quotes and testimonials
  - ⚠️ **Only for actual quotations** with attribution
- **[trustpilot](trustpilot-section-usage.md)** - Trustpilot review integration
- **[cards](cards-section-usage.md)** - Dynamic card layout with responsive columns

### Statistics Sections

- **[counters](counters-section-usage.md)** - Animated counters and statistics

### Action & Navigation Sections

- **[sectioncta](sectioncta-section-usage.md)** - Call-to-action sections
- **[otherpages](otherpages-section-usage.md)** - Related or other page listings

### Specialized Sections

- **[audiences](audiences-section-usage.md)** - Target audience displays
- **[phases](phases-section-usage.md)** - Project or process phases
- **[courses](courses-section-usage.md)** - Course listings and information
- **[taxonomies](taxonomies-section-usage.md)** - Display of taxonomy terms and categories
- **[taxonomies-card](taxonomies-card-section-usage.md)** - Card-based taxonomy display
- **[taxonomies-list](taxonomies-list-section-usage.md)** - List-style taxonomy display with badges
- **[types](types-section-usage.md)** - Type categorizations
- **[videos](videos-section-usage.md)** - Video content display and embedding

### System Sections

- **content** - Built-in basic content type (avoid on marketing pages)
- **none** - Built-in fallback (no content rendered)
- **unknown** - System error handler (never use intentionally)

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
