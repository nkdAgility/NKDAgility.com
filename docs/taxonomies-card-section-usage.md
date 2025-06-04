# Taxonomies-Card Section Usage

The `taxonomies-card` section type is a specialized card component used internally by the `taxonomies` section to display individual taxonomy terms. This documentation covers the card component for reference and customization purposes.

## Overview

This section is primarily used as a partial component within the `taxonomies` section and is not typically called directly in page front matter. It creates detailed cards for taxonomy terms with associated content listings.

## Component Structure

The taxonomy card includes:

1. **Header Section**:

   - Content type badge
   - Taxonomy term title
   - Description text

2. **Content List**:

   - Up to 5 associated pages
   - Optional preview icons
   - Page titles and links

3. **Footer Section**:
   - "View More" link (if applicable)
   - Additional navigation options

## Parameters

When used internally, the card receives:

- `context`: The taxonomy term object
- `subTypes`: Array of content types to filter by
- `site`: Hugo site object

## Card Content Sources

### Title Priority

1. **Custom Card Title**: `$context.Page.Params.card.title`
2. **Page Title**: `$context.Page.Title`

### Content Priority

1. **Custom Card Content**: `$context.Page.Params.card.content`
2. **Default Content**: Auto-generated content

## Content Listing

The card displays associated pages with:

- **Filtering**: Only shows pages matching `subTypes`
- **Ordering**: Uses `ByWeight` sorting
- **Limit**: Maximum of 5 pages
- **Icons**: Optional preview icons from page resources

## Visual Elements

### Badge Display

```html
<span class="badge text-bg-secondary"> <i class="fa-regular fa-tag"></i> {{ Content Type }} </span>
```

### Content List Format

Each listed page includes:

- Optional preview icon
- Page title as clickable link
- Proper HTML structure for accessibility

## Styling Classes

The card uses these CSS classes:

- `.card.sectioncards`: Main card container
- `.card-body`: Content area
- `.card-text.text-muted`: Description text
- `.list-group`: Content listing
- `.list-group-item`: Individual list items
- `.badge.text-bg-secondary`: Type badge

## Icon Integration

Preview icons are loaded from page resources:

```yaml
# In a page's front matter
previewIcon: "scrum-icon.png"
```

The component looks for icons in the page's `images/` directory and displays them alongside page titles in the content list.

## Customization Example

To customize taxonomy term display, create a term page:

**File: `/content/tags/scrum/_index.md`**

```yaml
---
title: "Scrum"
type: "tag"
card:
  title: "Scrum Framework Mastery"
  content: "Comprehensive Scrum training, coaching, and resources to help teams and organizations master the world's most popular agile framework."
previewIcon: "scrum-logo.svg"
---
# Scrum Framework

Detailed content about Scrum methodology, best practices, and implementation guidance...
```

## Template Structure

The card follows this structure:

1. **Outer Container**: Bootstrap card with shadow and flex properties
2. **Header Section**: Badge, title, and description
3. **List Section**: Associated pages with icons and links
4. **Footer Section**: Additional navigation or actions

## Responsive Behavior

- **Desktop**: Full card layout with all elements visible
- **Tablet**: Maintains card structure with adjusted spacing
- **Mobile**: Stacks content vertically within card boundaries

## Content Filtering

The card respects the `subTypes` parameter to only show relevant content:

```javascript
// Only show pages matching specified content types
$pagesToDisplay = where .context.Pages.ByWeight "Type" "in" $subTypes
```

## Best Practices for Taxonomy Pages

1. **Custom Card Content**: Provide meaningful card titles and descriptions
2. **Preview Icons**: Use consistent, high-quality icons
3. **Relevant Content**: Ensure taxonomy terms have sufficient associated content
4. **Descriptive Titles**: Use clear, descriptive taxonomy term names
5. **Content Organization**: Maintain logical content type groupings

## Integration with Taxonomies Section

This card component is automatically used when you configure a `taxonomies` section:

```yaml
- type: "taxonomies"
  title: "Popular Topics"
  source: "tags"
  types:
    - "training-courses"
    - "resources"
```

The `taxonomies` section will:

1. Find matching taxonomy terms
2. Filter by content types
3. Create cards using this component
4. Display in responsive grid layout

## Advanced Customization

To modify card appearance or behavior:

1. **Custom Styling**: Override CSS classes for visual changes
2. **Icon System**: Implement custom icon handling
3. **Content Limits**: Adjust the 5-page limit if needed
4. **Link Behavior**: Modify how links are generated or displayed

## Hugo Template Context

The card operates within Hugo's taxonomy system:

- **Taxonomy Terms**: Accesses term pages and associated content
- **Page Resources**: Loads icons and media from page bundles
- **Content Relationships**: Leverages Hugo's automatic taxonomy associations
- **Weight Ordering**: Respects page weight for content ordering

## Accessibility Features

The card includes:

- **Semantic HTML**: Proper heading hierarchy and list structure
- **Alt Text**: Icon alt attributes for screen readers
- **Keyboard Navigation**: Focusable links and proper tab order
- **ARIA Labels**: Meaningful labels for complex elements

This component provides a rich, interactive way to display taxonomy terms while maintaining consistency with the overall site design and ensuring good user experience across all devices.
