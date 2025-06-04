# Audiences Section Usage

The `audiences` section type automatically displays cards for all pages of type "audience" in your site. This is perfect for showcasing target audiences, customer segments, or user personas.

## Basic Structure

```yaml
sections:
  - type: "audiences"
    title: "Who We Serve"
    content: "Our solutions are designed for diverse audiences across industries"
```

## Features

- **Automatic Content**: Pulls all pages with `Type: "audience"` from your site
- **Responsive Grid**: 3-column layout on desktop, stacks on mobile
- **Card Display**: Uses the site's standard card component
- **Dynamic Content**: Automatically updates when new audience pages are added
- **No Manual Configuration**: No need to specify individual audience pages

## Parameters

### Required

- `type`: Must be "audiences"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)

Note: This section does not use a `related` parameter - it automatically finds all audience pages.

## Audience Page Requirements

For pages to appear in this section, they must:

1. **Have Type "audience"** in their front matter:

   ```yaml
   ---
   title: "Software Development Teams"
   type: "audience"
   ---
   ```

2. **Include card parameters** in their front matter:
   ```yaml
   ---
   title: "Software Development Teams"
   type: "audience"
   card:
     title: "Development Teams"
     content: "Accelerate your software delivery with agile practices and DevOps automation."
     button:
       content: "Learn More"
   ---
   ```

## Audience Page Structure

Each audience page should include:

```yaml
---
title: "Target Audience Name"
type: "audience"
card:
  title: "Card Title"
  content: "Brief description of this audience and how you serve them"
  button:
    content: "Button Text"
# Additional audience-specific content
---
# Detailed content about this audience
```

## Examples

### Business Audiences

Create audience pages like:

**File: `/content/audiences/executives.md`**

```yaml
---
title: "Executive Leadership"
type: "audience"
card:
  title: "C-Suite & Executives"
  content: "Strategic guidance for leaders driving organizational transformation and digital innovation."
  button:
    content: "Executive Solutions"
---
```

**File: `/content/audiences/development-teams.md`**

```yaml
---
title: "Development Teams"
type: "audience"
card:
  title: "Software Development Teams"
  content: "Accelerate delivery with proven agile and DevOps practices tailored for technical teams."
  button:
    content: "Team Solutions"
---
```

**File: `/content/audiences/product-owners.md`**

```yaml
---
title: "Product Owners"
type: "audience"
card:
  title: "Product Owners & Managers"
  content: "Master product strategy and backlog management with professional Scrum techniques."
  button:
    content: "Product Training"
---
```

### Section Usage

```yaml
- type: "audiences"
  title: "Who We Help"
  content: "Our expertise serves professionals across the entire software delivery spectrum"
```

This will automatically display cards for all three audience pages above.

### Industry Focus

```yaml
- type: "audiences"
  title: "Industry Expertise"
  content: "Specialized solutions for different industry verticals"
```

With audience pages for:

- Healthcare Technology Teams
- Financial Services Organizations
- Manufacturing & Supply Chain
- Government & Public Sector

## Layout Structure

- **3-Column Grid**: `col-lg-4` for desktop display
- **Responsive**: `col-sm-12 col-md-12` ensures proper mobile stacking
- **Flex Layout**: `d-flex` for consistent card heights
- **Consistent Spacing**: `p-2` padding around each audience card

## Card Integration

Each audience card displays:

- **Title**: From `card.title` parameter
- **Content**: From `card.content` parameter
- **Button**: From `card.button.content` parameter
- **Link**: Links to the audience page (`RelPermalink`)

## Automatic Updates

When you:

- Add a new audience page with `type: "audience"`
- The section automatically includes it
- No need to update the section configuration
- Cards appear in the order Hugo processes the pages

## Best Practices

1. **Consistent Card Format**: Use similar title and content length across audience cards
2. **Clear Value Propositions**: Each card should clearly state how you serve that audience
3. **Action-Oriented Buttons**: Use compelling button text like "Learn More", "Get Solutions"
4. **Audience-Specific Content**: Tailor the card content to speak directly to each audience
5. **Strategic Ordering**: Consider file naming or front matter to control display order

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-lg-4.col-sm-12.col-md-12`: Responsive column classes
- `.p-2`: Padding for card spacing
- `.d-flex`: Flexbox for equal height cards
- `.sectioncards`: Card component class

## Content Strategy

Use this section to:

- **Segment Solutions**: Show how your services apply to different audiences
- **Build Relevance**: Help visitors quickly identify if you serve their role/industry
- **Guide Navigation**: Provide clear paths for different types of visitors
- **Demonstrate Breadth**: Showcase the range of your expertise

## Hugo Integration

The section leverages:

- `where $site.RegularPages "Type" "audience"` to find all audience pages
- Hugo's automatic page discovery and processing
- The standard card partial for consistent display
- Page parameters for card content

This approach ensures your audience showcase stays current as you add new audience pages to your site.
