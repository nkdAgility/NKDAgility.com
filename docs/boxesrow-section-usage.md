# BoxesRow Section Usage

The `boxesrow` section type (also accessible as `outcomeboxes`) displays a responsive row of boxes with optional content, item lists, and reference links. This is perfect for showcasing features, outcomes, service tiers, or comparison information.

## Basic Structure

```yaml
sections:
  - type: "boxesrow"
    title: "Our Service Packages"
    content: "Choose the package that best fits your needs"
    boxes:
      - title: "Starter Package"
        content: "Perfect for small teams getting started with agile practices"
        items:
          - title: "2-day Scrum Master training"
          - title: "Basic team assessment"
          - title: "3 months email support"
      - title: "Professional Package"
        content: "Comprehensive support for growing organizations"
        items:
          - title: "5-day intensive training program"
          - title: "Team coaching sessions"
          - title: "Custom improvement roadmap"
          - title: "6 months ongoing support"
      - title: "Enterprise Package"
        content: "Full transformation support for large organizations"
        items:
          - title: "Organization-wide assessment"
          - title: "Leadership coaching program"
          - title: "Cross-team coordination"
          - title: "12 months partnership"
```

## Features

- **Responsive Layout**: Automatically adapts to 1, 2, or 3+ column layouts
- **Visual Hierarchy**: Different styling for each box position
- **Item Lists**: Bullet-point lists within each box
- **Reference Links**: Optional links to detailed pages
- **Flexible Content**: Supports both custom content and page references
- **Equal Heights**: Flexbox ensures consistent box heights
- **Call-to-Action**: Optional "Find out more" buttons

## Parameters

### Required

- `type`: Must be "boxesrow" or "outcomeboxes"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `boxes`: Array of box objects
  - `title`: Box title (or uses referenced page title)
  - `content`: Box description (or uses referenced page description)
  - `items`: Array of item objects
    - `title`: Item text
  - `ref`: Optional reference to another page for content

## Box Layout Logic

### Automatic Column Sizing

- **1 Box**: Full width (`col-md-12`)
- **2 Boxes**: Half width each (`col-md-6`)
- **3+ Boxes**: Third width each (`col-md-4`)

### Visual Styling Hierarchy

Boxes automatically cycle through three visual styles:

1. **Primary Style**: First box (index 0)
2. **Accent Style**: Second box (index 1)
3. **Light Style**: Third box (index 2)
4. **Cycle Repeats**: For more than 3 boxes

## Reference System

Instead of defining content directly, boxes can reference existing pages:

```yaml
boxes:
  - ref: "/services/agile-coaching"
  - ref: "/services/devops-consulting"
  - ref: "/services/training-programs"
```

Referenced pages provide:

- **Title**: From page front matter
- **Description**: From page description
- **Link**: Automatic "Find out more" button to page

## Examples

### Service Comparison

```yaml
- type: "boxesrow"
  title: "Training Approaches"
  content: "Different training styles to match your learning preferences"
  boxes:
    - title: "Virtual Training"
      content: "Interactive online sessions with expert instructors"
      items:
        - title: "Live instructor-led sessions"
        - title: "Interactive breakout rooms"
        - title: "Digital collaboration tools"
        - title: "Recorded sessions for review"
    - title: "In-Person Training"
      content: "Traditional classroom experience with hands-on activities"
      items:
        - title: "Face-to-face interaction"
        - title: "Physical simulation exercises"
        - title: "Networking opportunities"
        - title: "Immediate feedback"
```

### Reference-Based Boxes

```yaml
- type: "boxesrow"
  title: "Our Core Services"
  content: "Comprehensive solutions for your agile transformation"
  boxes:
    - ref: "/capabilities/agile-coaching"
    - ref: "/capabilities/devops-consulting"
    - ref: "/capabilities/organizational-change"
```

### Mixed Content Types

```yaml
- type: "boxesrow"
  title: "Implementation Phases"
  boxes:
    - title: "Assessment"
      content: "Understanding your current state and challenges"
      items:
        - title: "Team maturity evaluation"
        - title: "Process analysis"
        - title: "Tool assessment"
    - ref: "/services/transformation-roadmap"
    - title: "Execution"
      content: "Implementing changes with ongoing support"
      items:
        - title: "Gradual rollout"
        - title: "Change management"
        - title: "Continuous monitoring"
```

### Single Box Highlight

```yaml
- type: "boxesrow"
  title: "Special Offer"
  boxes:
    - title: "Early Bird Discount"
      content: "Register before the end of the month and save 20%"
      items:
        - title: "20% off all training courses"
        - title: "Free follow-up coaching session"
        - title: "Lifetime access to materials"
        - title: "Valid until March 31st"
```

## Layout Structure

- **Container**: `.section-boxesrow` main wrapper
- **Grid**: Bootstrap responsive grid with gutters (`.row.g-4`)
- **Boxes**: Flexbox containers with equal heights (`.d-flex.flex-column`)
- **Content**: Flexible content area that grows to fill available space
- **Actions**: Fixed footer area for buttons and links

## Styling

The section uses these CSS classes:

### Box Containers

- `.section-boxesrow`: Main section container
- `.section-boxesrow-box`: Individual box container
- `.section-boxesrow-box-primary`: Primary box styling (first box)
- `.section-boxesrow-box-accent`: Accent box styling (second box)
- `.section-boxesrow-box-light`: Light box styling (third box)

### Content Elements

- `.section-boxesrow-title`: Box title styling
- `.section-boxesrow-content`: Box content/description styling
- `.section-boxesrow-list`: Item list container
- `.section-boxesrow-item`: Individual item styling
- `.section-boxesrow-link`: Call-to-action link area

## Best Practices

1. **Consistent Content**: Keep box descriptions similar in length
2. **Meaningful Titles**: Use clear, descriptive box titles
3. **Balanced Items**: Try to balance the number of items across boxes
4. **Action-Oriented**: Include clear next steps or references
5. **Visual Hierarchy**: Use the natural box styling to guide attention
6. **Mobile Consideration**: Content stacks vertically on mobile
7. **Reference Quality**: Ensure referenced pages have good descriptions

## Error Handling

The section gracefully handles:

- **Missing Content**: Shows boxes without content
- **Missing Items**: Shows boxes without item lists
- **Invalid References**: Skips broken page references
- **Empty Boxes**: Displays placeholder content

## Alternative Type Names

This section can be used with either type identifier:

- `type: "boxesrow"` - General purpose box layout
- `type: "outcomeboxes"` - Specifically for outcome display

Both use the same template and functionality.

## Common Use Cases

- **Service Packages**: Different tiers of offerings
- **Feature Comparisons**: Side-by-side feature lists
- **Process Steps**: Sequential workflow phases
- **Outcome Highlights**: Results and benefits
- **Product Categories**: Different product types
- **Training Options**: Various learning approaches

The `boxesrow` section provides a flexible way to present structured information in an visually appealing, responsive format.
