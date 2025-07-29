# Taxonomies-List Section Usage

The `taxonomies-list` section type displays taxonomy terms in a list format with badges showing content type counts. This provides a detailed view of taxonomy usage across different content types with clickable links and descriptions.

## Basic Structure

```yaml
sections:
  - type: "taxonomies-list"
    title: "Training Audiences"
    content: "Explore our training programs by target audience"
    source: "delivery-audiences"
    types:
      - "training-courses"
      - "capabilities"
      - "resources"
    listType: "default"
```

## Features

- **Detailed Listings**: Shows each taxonomy term as a separate list item
- **Content Type Badges**: Displays count and type of content for each term
- **Clickable Links**: Term titles link to their taxonomy pages
- **Optional Descriptions**: Shows term descriptions with "find out more" links
- **Flexible Layout**: Supports default and boxed list styles
- **Smart Filtering**: Only shows terms with matching content types
- **Usage Sorting**: Orders terms by usage count (most used first)

## Parameters

### Required

- `type`: Must be "taxonomies-list"
- `source`: The taxonomy name to display (e.g., "delivery-audiences", "tags", "categories")
- `types`: Array of content types to filter by

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `listType`: Layout style - "default" or "boxed" (defaults to "default")

## List Types

### Default List Type

Standard vertical list layout with icons and badges:

```yaml
- type: "taxonomies-list"
  source: "delivery-audiences"
  types: ["training-courses"]
  listType: "default"
```

### Boxed List Type

Enhanced layout with bordered boxes:

```yaml
- type: "taxonomies-list"
  source: "delivery-audiences"
  types: ["training-courses"]
  listType: "boxed"
```

## Content Type Integration

The section automatically:

1. **Filters Content**: Only shows taxonomy terms used by specified content types
2. **Counts Usage**: Displays number of pages for each content type
3. **Groups by Type**: Shows separate badges for different content types
4. **Maintains Links**: Preserves navigation to taxonomy pages

## Examples

### Training Audience Display

```yaml
- type: "taxonomies-list"
  title: "Who We Train"
  content: "Our training programs are designed for specific roles and responsibilities"
  source: "delivery-audiences"
  types:
    - "training-courses"
    - "capabilities"
  listType: "default"
```

### Skills and Topics

```yaml
- type: "taxonomies-list"
  title: "Popular Topics"
  content: "Explore our most requested training and consulting areas"
  source: "tags"
  types:
    - "training-courses"
    - "resources"
    - "capabilities"
  listType: "boxed"
```

### Industry Categories

```yaml
- type: "taxonomies-list"
  title: "Industry Expertise"
  content: "We serve clients across diverse industry verticals"
  source: "categories"
  types:
    - "case-studies"
    - "capabilities"
    - "resources"
```

### Multi-Type Content

```yaml
- type: "taxonomies-list"
  title: "Learning Paths"
  content: "Comprehensive learning journeys across multiple content types"
  source: "course_topics"
  types:
    - "training-courses"
    - "workshops"
    - "webinars"
    - "resources"
  listType: "default"
```

## Badge Display Logic

Each taxonomy term shows badges indicating:

- **Count**: Number of matching pages
- **Type**: Content type name (e.g., "courses", "capabilities")
- **Multiple Types**: Separate badges for each content type

Example badge display:

- `3 courses` - 3 training courses tagged with this term
- `2 capabilities` - 2 capability pages using this term
- `5 resources` - 5 resource pages tagged with this term

## Taxonomy Page Requirements

For optimal display, taxonomy term pages should include:

```yaml
---
title: "Scrum Masters"
description: "Professional training and coaching for Scrum Masters at all experience levels"
---
```

The section uses:

- **Title**: For the clickable term name
- **Description**: For the description text with "find out more" link
- **Permalink**: For navigation links

## Layout Structure

- **Container**: `.list-section.list-section-{listType}`
- **Items**: `.list-item` for each taxonomy term
- **Headers**: `.list-item-header` with icon and content
- **Icons**: `.list-item-icon` with Font Awesome icons
- **Titles**: `.list-item-title` with linked term names
- **Badges**: `.badge.bg-secondary` for content type counts

## Styling

The section uses these CSS classes:

### List Container

- `.list-section`: Main container
- `.list-section-default`: Default list styling
- `.list-section-boxed`: Boxed list styling (if applicable)

### List Items

- `.list-item`: Individual term container
- `.list-item-header`: Header section with icon and content
- `.list-item-icon`: Font Awesome icon (fa-chalkboard-user)
- `.list-item-title`: Term title styling

### Content Elements

- `.badge.bg-secondary`: Content type count badges
- `.text-muted.small`: Description text styling
- `.text-decoration-none`: Link styling

## Filtering Logic

The section:

1. **Iterates Taxonomies**: Loops through site taxonomies to find the specified source
2. **Sorts by Count**: Orders terms by usage count (most used first)
3. **Filters Content**: Only includes terms with pages matching specified types
4. **Groups Content**: Organizes matching pages by content type
5. **Displays Badges**: Shows separate badges for each content type

## Best Practices

1. **Relevant Types**: Choose content types that actually use the taxonomy
2. **Clear Taxonomy Names**: Use descriptive taxonomy term titles
3. **Good Descriptions**: Provide meaningful descriptions for taxonomy pages
4. **Appropriate Icons**: The default icon works well, but can be customized
5. **Type Selection**: Limit to 3-4 content types for readability
6. **Testing**: Verify that taxonomy terms have content in specified types

## Common Use Cases

- **Audience Targeting**: Show training programs by target audience
- **Topic Exploration**: Display content organized by subject matter
- **Skill Development**: Present learning paths and skill areas
- **Industry Focus**: Showcase expertise in different industries
- **Category Browsing**: Help users find content by category

## Error Handling

The section gracefully handles:

- **Missing Taxonomy**: Skips if taxonomy doesn't exist
- **No Matching Content**: Only shows terms with matching pages
- **Missing Descriptions**: Works without taxonomy page descriptions
- **Empty Results**: Displays nothing if no terms match criteria

## Comparison with Other Taxonomy Sections

- **vs. taxonomies**: More detailed list view vs. card grid
- **vs. taxonomies-card**: List format vs. card format
- **vs. taxonomies**: Shows all matching terms vs. limited display

The `taxonomies-list` section provides a comprehensive way to explore taxonomy terms with detailed usage information and navigation options.
