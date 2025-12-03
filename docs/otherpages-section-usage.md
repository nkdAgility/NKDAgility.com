# OtherPages Section Documentation

The `otherpages` section provides a flexible way to display a collection of pages as cards with dynamic column layout based on the number of items. It's designed to showcase various pages from your site in an organized, responsive grid format.

> ⚠️ **CRITICAL**: This section requires TWO properties: `source:` (must be set to `"related"`) AND `related:` (the array of page paths).

## Basic Structure

```yaml
sections:
  - type: otherpages
    title: "Section Title"
    content: "Optional description"
    source: related # Required - tells template which property contains the pages
    related: # Required - array of page paths
      - /path/to/page1
      - /path/to/page2
      - /path/to/page3
```

## Features

- **Dynamic Column Layout**: Automatically adjusts columns based on the number of items
  - 3 items or multiples of 3: 3 columns per row (col-lg-4)
  - 2 items or multiples of 2: 2 columns per row (col-lg-6)
  - Other numbers: Default 3 columns per row (col-lg-4)
- **Responsive Design**: Uses Bootstrap responsive classes (col-lg, col-md, col-sm)
- **Card-Based Display**: Each page is displayed as a card component
- **Flexible Content**: Can display any pages from your site
- **Auto-Sizing**: Automatically handles different numbers of items

## Parameters

### Required Parameters

- **type**: Must be "otherpages"
- **source**: Must be set to `"related"` (tells the template which property to use)
- **related**: Array of page paths to display
  - Type: Array
  - Description: List of page paths that should be displayed as cards

### Optional Parameters

- **title**: Section title
- **content**: Section description (supports Markdown)
- **id**: Optional section identifier

## Examples

### Basic Implementation

```yaml
sections:
  - type: otherpages
    title: "Related Resources"
    source: related
    related:
      - /resources/whitepaper-1
      - /resources/whitepaper-2
      - /resources/whitepaper-3
```

### Multiple Pages Display

```yaml
sections:
  - type: otherpages
    title: "Continue Learning"
    content: "Explore these related courses"
    source: related
    related:
      - /training/course-a
      - /training/course-b
      - /training/course-c
      - /training/course-d
```

## ❌ Common Mistakes

### WRONG - Missing source Property

```yaml
sections:
  - type: otherpages
    related: # ❌ WRONG - Missing source property
      - /page1
      - /page2
```

### WRONG - Wrong source Value

```yaml
sections:
  - type: otherpages
    source: pages # ❌ WRONG - Must be "related"
    pages:
      - /page1
      - /page2
```

### ✅ CORRECT - Both source and related

```yaml
sections:
  - type: otherpages
    source: related # ✅ CORRECT
    related: # ✅ CORRECT
      - /page1
      - /page2
```

## Page Requirements

Each page referenced in the `related` array should have the following frontmatter structure:

```yaml
---
card:
  title: "Page Title"
  content: "Brief description of the page content"
---
```

## Layout Behavior

- **3 or multiple of 3 items**: Creates a 3-column layout (col-lg-4)
- **2 or multiple of 2 items**: Creates a 2-column layout (col-lg-6)
- **Other numbers**: Defaults to 3-column layout (col-lg-4)

## Styling

The section uses:

- Bootstrap responsive grid system
- `p-2` padding around each card
- `d-flex` for flexible layout
- Card component with "sectioncards" class
- Responsive breakpoints: lg (large screens), md (medium), sm (small)

## Best Practices

1. **Consistent Card Data**: Ensure all referenced pages have proper `card.title` and `card.content` frontmatter
2. **Balanced Content**: Try to use numbers that work well with the dynamic column system (2, 3, 4, 6, etc.)
3. **Content Length**: Keep card titles and content concise for better visual balance
4. **Page Organization**: Group related pages together for better user experience
5. **Performance**: Don't include too many pages in a single section (consider pagination for large collections)

## Use Cases

- **Resource Collections**: Display related whitepapers, guides, or resources
- **Blog Post Highlights**: Showcase featured or related blog posts
- **Course Recommendations**: Show related training courses or materials
- **Portfolio Items**: Display project or case study pages
- **Navigation Aids**: Create curated collections of important pages

## Integration

This section works seamlessly with:

- Page collections and taxonomies
- Hugo's page lookup system
- Bootstrap responsive framework
- The site's card component system

## Notes

- The section automatically handles missing pages (with Hugo's `with` statement)
- Column layout adapts based on content count for optimal display
- All cards include a "view" button linking to the full page
- Responsive design ensures good display across all device sizes
