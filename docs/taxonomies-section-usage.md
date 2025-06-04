# Taxonomies Section Usage

The `taxonomies` section type displays taxonomy terms (like tags or categories) as cards, filtered by content type and automatically sorted by usage count. This is perfect for showcasing popular topics, categories, or tags.

## Basic Structure

```yaml
sections:
  - type: "taxonomies"
    title: "Popular Topics"
    content: "Explore our most popular training and consulting areas"
    source: "tags"
    types:
      - "training-courses"
      - "capabilities"
      - "resources"
```

## Features

- **Taxonomy Integration**: Works with Hugo's built-in taxonomy system
- **Content Type Filtering**: Shows only terms used by specified content types
- **Automatic Sorting**: Orders by usage count and weight
- **Limited Display**: Shows top 6 most relevant terms
- **Intelligent Layout**: Automatically calculates optimal column layout
- **Card-Based Display**: Each taxonomy term gets its own detailed card

## Parameters

### Required

- `type`: Must be "taxonomies"
- `source`: The taxonomy name to display (e.g., "tags", "categories", "topics")
- `types`: Array of content types to filter by

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)

## Taxonomy Configuration

In your Hugo site configuration, ensure taxonomies are properly defined:

```yaml
# hugo.yaml
taxonomies:
  tag: tags
  category: categories
  topic: topics
  skill: skills
```

## Content Page Setup

Pages should include the specified taxonomy in their front matter:

```yaml
---
title: "Professional Scrum Master"
type: "training-courses"
tags:
  - "scrum"
  - "agile"
  - "leadership"
  - "certification"
categories:
  - "training"
  - "professional-development"
---
```

## Examples

### Popular Training Topics

```yaml
- type: "taxonomies"
  title: "Popular Training Topics"
  content: "Discover our most requested training areas"
  source: "tags"
  types:
    - "training-courses"
    - "workshops"
```

### Service Categories

```yaml
- type: "taxonomies"
  title: "Service Areas"
  content: "Our core consulting and coaching specializations"
  source: "categories"
  types:
    - "capabilities"
    - "services"
    - "consulting"
```

### Skill Development Areas

```yaml
- type: "taxonomies"
  title: "Skill Development"
  content: "Build expertise in these key areas"
  source: "skills"
  types:
    - "training-courses"
    - "certifications"
    - "learning-paths"
```

### Content Topics

```yaml
- type: "taxonomies"
  title: "Resource Topics"
  content: "Browse our knowledge base by topic"
  source: "tags"
  types:
    - "blog"
    - "resources"
    - "case-studies"
    - "whitepapers"
```

## Filtering Logic

The section uses sophisticated filtering:

1. **Taxonomy Matching**: Finds the specified taxonomy (e.g., "tags")
2. **Content Type Filtering**: Only includes terms from pages with specified types
3. **Usage Counting**: Terms must have associated pages to be displayed
4. **Top 6 Selection**: Shows only the 6 most relevant terms
5. **Weight Sorting**: Orders by page weight in descending order

## Layout Logic

Column layout is automatically calculated:

- **3 Terms or Multiple of 3**: Uses 3-column layout (`col-lg-4`)
- **Even Number (2, 4, 6)**: Uses 2-column layout (`col-lg-6`)
- **Other Numbers**: Defaults to 3-column layout

## Taxonomy Card Features

Each taxonomy card displays:

- **Badge**: Shows the content type
- **Title**: The taxonomy term name or custom card title
- **Description**: Term description or custom card content
- **Content List**: Shows up to 5 pages using this term
- **Icons**: Optional preview icons for listed content
- **Links**: Direct links to individual pages

## Card Content Sources

Cards can use two content sources:

### Custom Card Parameters

```yaml
# On a taxonomy term page
card:
  title: "Scrum Mastery"
  content: "Master the art of Scrum with our comprehensive training and resources"
```

### Automatic Content

If no custom card parameters exist, the card uses:

- **Title**: The taxonomy term name
- **Content**: Auto-generated content

## Advanced Configuration

### Taxonomy Term Pages

Create dedicated pages for taxonomy terms:

**File: `/content/tags/scrum/_index.md`**

```yaml
---
title: "Scrum"
type: "tag"
card:
  title: "Scrum Framework"
  content: "Master the most popular agile framework with our comprehensive Scrum training, coaching, and resources."
---
# Scrum Framework

Detailed information about Scrum practices, training, and implementation...
```

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-lg-4` or `.col-lg-6`: Dynamic column classes
- `.col-sm-12.col-md-12`: Mobile responsiveness
- `.p-2`: Padding for card spacing
- `.d-flex`: Flexbox for equal heights

## Best Practices

1. **Consistent Tagging**: Use consistent taxonomy terms across your content
2. **Relevant Types**: Only include content types that actually use the taxonomy
3. **Quality Terms**: Ensure important terms have enough associated content
4. **Custom Cards**: Create custom card content for important taxonomy terms
5. **Strategic Limits**: The 6-term limit keeps the display focused and manageable

## Common Taxonomy Sources

### Content Organization

- `"tags"` - Content tags and keywords
- `"categories"` - Content categories
- `"topics"` - Subject areas
- `"themes"` - Thematic groupings

### Business Classification

- `"services"` - Service types
- `"industries"` - Industry verticals
- `"solutions"` - Solution categories
- `"methods"` - Methodologies

### Educational Classification

- `"skills"` - Skill areas
- `"levels"` - Difficulty levels
- `"formats"` - Training formats
- `"certifications"` - Certification types

## Hugo Integration

The section leverages:

- `$site.Taxonomies` - Hugo's taxonomy system
- `where .Pages "Type" "in" $types` - Content type filtering
- `ByCount` - Usage-based sorting
- `first 6` - Limit to top results
- Custom card partial for rich display

## Use Cases

This section is perfect for:

1. **Topic Discovery**: Help visitors find content by topic
2. **Popular Content**: Showcase trending or popular areas
3. **Navigation Aid**: Provide topic-based navigation
4. **Expertise Showcase**: Highlight areas of specialization
5. **Content Organization**: Present content taxonomy in user-friendly format

The `taxonomies` section provides an intelligent way to surface your most relevant and popular content topics while maintaining visual consistency and user-friendly navigation.
