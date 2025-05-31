# CaseStudy Section Usage

The `casestudy` section type displays a list of results or achievements with icons and includes a call-to-action at the end. This is perfect for showcasing project outcomes, success metrics, or benefits.

## Basic Structure

```yaml
sections:
  - type: "casestudy"
    title: "Project Results"
    content: "Here are the key outcomes we achieved:"
    list:
      - icon: "fa-chart-line"
        content: "**50% increase** in team productivity within 3 months"
      - icon: "fa-clock"
        content: "**Reduced delivery time** from 6 weeks to 2 weeks"
      - icon: "fa-users"
        content: "**Improved team satisfaction** scores by 40%"
    cta:
      content: "Ready to achieve similar results for your team?"
      button:
        text: "Get Started"
        url: "/contact"
```

## Features

- **Icons**: Each item can have a FontAwesome icon
- **Rich Content**: Support for Markdown in content fields
- **Call-to-Action**: Optional CTA section with button
- **Responsive**: Adapts to different screen sizes
- **Theme Support**: Works with both light and dark themes

## Parameters

### Required

- `type`: Must be "casestudy"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `list`: Array of achievement items
  - `icon`: FontAwesome icon class (e.g., "fa-chart-line")
  - `content`: Achievement description (supports Markdown)
- `cta`: Call-to-action section
  - `content`: CTA text (supports Markdown)
  - `button`: Button configuration
    - `text`: Button text
    - `url`: Button link

## Styling

The section uses these CSS classes:

- `.casestudy-section`: Main container
- `.casestudy-list`: List container
- `.casestudy-item`: Individual achievement item
- `.casestudy-icon`: Icon container
- `.casestudy-content`: Content area
- `.casestudy-cta`: Call-to-action section
- `.casestudy-button`: CTA button

## Examples

### Simple List

```yaml
- type: "casestudy"
  title: "Key Achievements"
  list:
    - icon: "fa-trophy"
      content: "Won industry award for innovation"
    - icon: "fa-star"
      content: "Achieved 98% customer satisfaction"
```

### With Call-to-Action

```yaml
- type: "casestudy"
  title: "Project Outcomes"
  content: "Our engagement delivered measurable results:"
  list:
    - icon: "fa-arrow-up"
      content: "**Revenue increased** by 35%"
    - icon: "fa-shield-alt"
      content: "**Zero security incidents** in 12 months"
    - icon: "fa-handshake"
      content: "**Client retention** improved to 95%"
  cta:
    content: "Want to see similar improvements in your organization?"
    button:
      text: "Schedule Consultation"
      url: "/book-consultation"
```

### Metrics Focus

```yaml
- type: "casestudy"
  title: "Transformation Results"
  list:
    - icon: "fa-percentage"
      content: "**40% reduction** in deployment failures"
    - icon: "fa-clock"
      content: "**Lead time decreased** from 30 days to 5 days"
    - icon: "fa-chart-bar"
      content: "**Customer NPS score** improved from 6 to 9"
    - icon: "fa-money-bill-wave"
      content: "**Cost savings** of $2M annually"
```

## Best Practices

1. **Use Relevant Icons**: Choose FontAwesome icons that relate to your achievements
2. **Quantify Results**: Include specific numbers and percentages when possible
3. **Bold Key Metrics**: Use **bold** text to highlight important numbers
4. **Clear CTA**: Make your call-to-action compelling and action-oriented
5. **Consistent Tone**: Keep achievement descriptions in a similar style
