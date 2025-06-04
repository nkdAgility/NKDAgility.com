# Types Section Usage

The `types` section type displays cards for all pages of a specified content type with intelligent layout and optional column control. This is perfect for showcasing content categories, service types, or any collection of related pages.

## Basic Structure

```yaml
sections:
  - type: "types"
    title: "Our Services"
    content: "Explore our comprehensive range of professional services"
    source: "capabilities"
    columns: 3
```

## Features

- **Dynamic Content**: Automatically pulls pages based on content type
- **Intelligent Layout**: Automatically calculates optimal column layout
- **Custom Columns**: Override automatic layout with specific column count
- **Weight-Based Ordering**: Displays pages by their weight parameter
- **Card Integration**: Uses the site's standard card component
- **Responsive Design**: Adapts to different screen sizes

## Parameters

### Required

- `type`: Must be "types"
- `source`: The content type to display (e.g., "capabilities", "services", "products")

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `columns`: Number of columns to display (overrides automatic calculation)

## Source Page Requirements

Pages displayed in this section must:

1. **Have the specified type** in their front matter:

   ```yaml
   ---
   title: "Agile Coaching"
   type: "capabilities" # Must match the 'source' parameter
   weight: 10 # Optional: for ordering
   ---
   ```

2. **Include card parameters**:
   ```yaml
   ---
   title: "Agile Coaching"
   type: "capabilities"
   weight: 10
   card:
     title: "Expert Agile Coaching"
     content: "Transform your teams with professional agile coaching and mentoring services."
     button:
       content: "Learn More"
   ---
   ```

## Layout Logic

The section automatically determines column layout:

### Automatic Layout (no `columns` specified)

- **3 Cards or Multiple of 3**: Uses 3-column layout (`col-xl-4`)
- **Even Number (2, 4, 6, etc.)**: Uses 2-column layout (`col-xl-6`)
- **Other Numbers**: Defaults to 3-column layout

### Manual Override (`columns` specified)

- **Custom Columns**: Uses `12 / columns` for Bootstrap grid
- **Example**: `columns: 4` results in `col-xl-3` (4 columns)

## Examples

### Service Capabilities

```yaml
- type: "types"
  title: "Our Core Capabilities"
  content: "Comprehensive services to accelerate your agile transformation"
  source: "capabilities"
  columns: 3
```

**Corresponding capability pages:**

**File: `/content/capabilities/agile-coaching.md`**

```yaml
---
title: "Agile Coaching"
type: "capabilities"
weight: 10
card:
  title: "Expert Agile Coaching"
  content: "Professional coaching to help teams master agile practices and principles."
  button:
    content: "Get Coaching"
---
```

**File: `/content/capabilities/devops-consulting.md`**

```yaml
---
title: "DevOps Consulting"
type: "capabilities"
weight: 20
card:
  title: "DevOps Transformation"
  content: "End-to-end DevOps implementation and optimization services."
  button:
    content: "Start Transformation"
---
```

### Product Categories

```yaml
- type: "types"
  title: "Product Suite"
  content: "Discover our range of agile and DevOps solutions"
  source: "products"
  columns: 2
```

### Training Types

```yaml
- type: "types"
  title: "Training Categories"
  content: "Professional development programs for every skill level"
  source: "training-types"
```

### Industry Solutions

```yaml
- type: "types"
  title: "Industry Expertise"
  content: "Specialized solutions for different industry verticals"
  source: "industries"
  columns: 4
```

## Column Configuration Examples

### Two-Column Layout

```yaml
columns: 2 # Results in col-xl-6 (50% width each)
```

### Three-Column Layout

```yaml
columns: 3 # Results in col-xl-4 (33.33% width each)
```

### Four-Column Layout

```yaml
columns: 4 # Results in col-xl-3 (25% width each)
```

### Six-Column Layout

```yaml
columns: 6 # Results in col-xl-2 (16.67% width each)
```

## Content Ordering

Pages are displayed using Hugo's `ByWeight` ordering:

- **Lower weight numbers** appear first
- **No weight** or **equal weights** use alphabetical ordering
- **Example ordering**: weight 10, weight 20, weight 30

```yaml
# This appears first
weight: 10

# This appears second
weight: 20

# This appears third
weight: 30
```

## Layout Structure

- **Responsive Grid**: Uses Bootstrap's responsive column classes
- **Flex Layout**: `d-flex` ensures consistent card heights
- **Consistent Spacing**: `p-2` padding around each card
- **Card Integration**: Uses the standard `card.html` partial

## Best Practices

1. **Consistent Content Types**: Ensure all source pages have the correct type
2. **Weight Organization**: Use weight values to control display order
3. **Card Quality**: Provide meaningful card titles and descriptions
4. **Appropriate Columns**: Choose column counts that work well with your content
5. **Mobile Consideration**: Remember cards stack on mobile regardless of column setting

## Common Source Types

### Business Content

- `"capabilities"` - Service capabilities
- `"services"` - Service offerings
- `"solutions"` - Solution types
- `"products"` - Product categories

### Educational Content

- `"training-types"` - Training categories
- `"courses"` - Course types
- `"certifications"` - Certification types
- `"workshops"` - Workshop categories

### Industry Content

- `"industries"` - Industry verticals
- `"case-studies"` - Case study categories
- `"outcomes"` - Outcome types
- `"methodologies"` - Methodology types

## Card Integration

Each displayed card includes:

- **Title**: From `card.title` parameter
- **Content**: From `card.content` parameter
- **Button**: From `card.button.content` parameter
- **Link**: Uses the page's `Permalink`

## Error Handling

The section gracefully handles:

- **No matching pages**: Simply displays no cards
- **Missing card parameters**: Cards may display without certain elements
- **Invalid column numbers**: Falls back to sensible defaults

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-xl-{size}`: Dynamic responsive columns
- `.p-2`: Padding for card spacing
- `.d-flex`: Flexbox for equal heights
- `.sectioncards`: Standard card styling

## Hugo Integration

The section leverages:

- `where $site.RegularPages.ByWeight "Type" $source` - Filters and orders pages
- Hugo's automatic page discovery
- Bootstrap's responsive grid system
- The site's card component for consistent styling

## Use Cases

This section is perfect for:

1. **Service Showcases**: Display different service categories
2. **Product Catalogs**: Show product types or categories
3. **Content Organization**: Present related content in organized grids
4. **Navigation Aids**: Help users find specific types of content
5. **Dynamic Lists**: Automatically update as new content is added

The `types` section provides a powerful way to automatically showcase collections of related content while maintaining design consistency and responsive behavior.
