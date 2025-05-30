# TextNlist Section Usage

The `textNlist` section type displays content with a two-column layout: sideContent on the left and a list of items with icons on the right. The list area has a light background to distinguish it from the main content.

## Basic Structure

```yaml
sections:
  - type: "textNlist"
    title: "Section Title"
    sideContent: |
      This is the main content that appears on the left side.

      It can contain multiple paragraphs and supports **Markdown formatting**.

      You can include headings, bold text, links, and other Markdown elements.
    list:
      - icon: "fa-check-circle"
        content: |
          **First item** - Description of the first feature or benefit
      - icon: "fa-star"
        content: |
          **Second item** - Another important point or feature
      - icon: "fa-lightbulb"
        content: |
          **Third item** - Additional information or insight
```

## Features

- **Two-Column Layout**: sideContent on left, list on right
- **Light Background**: List area has a subtle background color for visual separation
- **Icon Support**: Each list item can have a FontAwesome icon
- **Rich Content**: Both sideContent and list items support Markdown formatting
- **Responsive**: Automatically stacks on mobile devices
- **Theme Support**: Adapts styling for both light and dark themes

## Parameters

### Required

- `type`: Must be "textNlist"

### Optional

- `title`: Section title (handled by section header)
- `sideContent`: Main content for the left column (supports Markdown)
- `list`: Array of list items for the right column
  - `icon`: FontAwesome icon class (e.g., "fa-check-circle")
  - `content`: Item content (supports Markdown)

## Styling

The section uses these CSS classes:

- `.textnlist-section`: Main container
- `.textnlist-side-content`: Left column container
- `.textnlist-content`: Left column content area
- `.textnlist-list-container`: Right column container
- `.textnlist-list-wrapper`: Right column background wrapper
- `.textnlist-list`: List container
- `.textnlist-item`: Individual list item
- `.textnlist-icon`: Icon container
- `.textnlist-item-content`: Item content area

## Examples

### Basic Usage

```yaml
- type: "textNlist"
  title: "Why Choose Our Approach"
  sideContent: |
    Our methodology combines proven practices with innovative solutions.

    We focus on sustainable transformation that delivers long-term value.
  list:
    - icon: "fa-users"
      content: "**Team-focused** approach that builds capability"
    - icon: "fa-chart-line"
      content: "**Measurable results** with clear KPIs and metrics"
    - icon: "fa-cogs"
      content: "**Process optimization** that reduces waste"
```

### With Rich Content

```yaml
- type: "textNlist"
  title: "Our Consulting Process"
  sideContent: |
    ## Comprehensive Assessment

    We begin with a thorough analysis of your current state.

    Our experienced consultants work closely with your team to understand:
    - Current challenges and pain points
    - Existing processes and workflows
    - Team dynamics and capabilities
    - Organizational goals and constraints
  list:
    - icon: "fa-search"
      content: |
        **Discovery Phase** - In-depth analysis of current state and identification of improvement opportunities
    - icon: "fa-lightbulb"
      content: |
        **Strategy Development** - Custom roadmap creation based on your specific needs and goals
    - icon: "fa-rocket"
      content: |
        **Implementation** - Hands-on support during transformation with continuous guidance
    - icon: "fa-chart-bar"
      content: |
        **Measurement & Optimization** - Ongoing monitoring and refinement to ensure sustained success
```

### Simple Feature List

```yaml
- type: "textNlist"
  title: "Key Benefits"
  sideContent: |
    Transform your development process with our proven approach.

    Join hundreds of teams who have successfully improved their delivery.
  list:
    - icon: "fa-clock"
      content: "Faster delivery cycles with reduced time-to-market"
    - icon: "fa-shield-alt"
      content: "Improved quality through better testing practices"
    - icon: "fa-users-cog"
      content: "Enhanced team collaboration and communication"
    - icon: "fa-chart-line"
      content: "Measurable improvements in key performance metrics"
```

## Best Practices

1. **Balance Content**: Keep left and right content roughly balanced in length
2. **Clear Icons**: Use appropriate FontAwesome icons that relate to the content
3. **Scannable Format**: Make list items easy to scan with clear headers
4. **Logical Flow**: Order list items in a logical sequence
5. **Consistent Structure**: Use similar formatting for all list items
6. **Mobile-Friendly**: Remember content stacks on mobile devices

## Visual Design

- **Light Background**: The list area uses a subtle light background (`#f8f9fa`) to create visual separation
- **Icons**: Primary color icons provide visual interest and easy scanning
- **Typography**: Clear hierarchy with proper spacing and readable fonts
- **Responsive**: Two-column layout on desktop, single column on mobile

This section type is ideal for feature lists, process explanations, benefit overviews, and any content where you want to present detailed information alongside a structured list of items.
