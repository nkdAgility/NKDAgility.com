# OutcomeBoxes Section Usage Guide

The OutcomeBoxes section provides a layout similar to OutcomeHero but displays lists of items within each box instead of single content blocks. It's perfect for showcasing features, benefits, or outcomes in an organized, visually appealing format.

## Basic Structure

```yaml
sections:
  - type: outcomeboxes
    title: "Section Title"
    backgroundColor: primary  # optional: none (default), primary, secondary
    boxes:
      - box:
          content: "Optional descriptive text for this box"  # optional
          items:
            - title: "First item or benefit"
            - title: "Second item or benefit"
            - title: "Third item or benefit"
      - box:
          content: "Another box description"  # optional
          items:
            - title: "Different benefit"
            - title: "Another advantage"
            - title: "Additional feature"
      - box:
          items:
            - title: "Simple list without description"
            - title: "Another item"
```

## Features

- **Responsive Layout**: Automatically adjusts to different screen sizes
- **Color Variations**: Each box gets a different color scheme (primary, accent, light)
- **Flexible Content**: Supports optional content text and lists of items
- **Theme Support**: Adapts styling for light and dark themes
- **Hover Effects**: Interactive hover animations
- **Scalable**: Supports more than 3 boxes with automatic color cycling

## Box Styling

The section automatically applies different color schemes to boxes:

1. **First Box**: Primary color (blue gradient)
2. **Second Box**: Accent color (orange gradient)
3. **Third Box**: Light color (gray gradient)
4. **Additional Boxes**: Cycles through the three color schemes

## Content Options

### With Content and Items
```yaml
- box:
    content: "This box explains the category of benefits below"
    items:
      - title: "Benefit one"
      - title: "Benefit two"
      - title: "Benefit three"
```

### Items Only
```yaml
- box:
    items:
      - title: "Direct benefit statement"
      - title: "Another advantage"
      - title: "Additional feature"
```

## Real-World Example

```yaml
- type: outcomeboxes
  title: "Engineering Excellence ensures"
  boxes:
    - box:
        content: "Development Practices"
        items:
          - title: "Standardise development practices"
          - title: "Implement CI/CD, IaC, test automation"
          - title: "Eliminate waste and drive continuous delivery"
    - box:
        content: "Team Culture"
        items:
          - title: "Build a learning scalable tech culture"
          - title: "Reduce release failure rates"
          - title: "Improve developer satisfaction"
    - box:
        content: "Business Outcomes"
        items:
          - title: "Faster time to market"
          - title: "Higher quality deliverables"
          - title: "Reduced operational costs"
```

## Best Practices

1. **Keep items concise**: Each item should be a clear, single benefit or feature
2. **Use parallel structure**: Start each item with similar grammar patterns
3. **Limit items per box**: 3-5 items per box works best for readability
4. **Balance content**: Try to have similar amounts of content in each box
5. **Clear categories**: If using content text, make it clearly describe the items below

## Differences from OutcomeHero

- **No CTA**: OutcomeBoxes doesn't include call-to-action buttons
- **Lists vs Text**: Contains lists of items rather than single content blocks
- **More Structured**: Better suited for detailed feature lists or benefit breakdowns
- **Expandable**: Can handle more than 3 boxes easily

This section type is ideal for outcome pages, feature comparisons, benefit listings, and any content where you need to present organized lists of related items in an visually engaging format.
