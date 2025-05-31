# OutcomeHero Section Usage Example

Add this to your page's frontmatter to use the OutcomeHero section:

```yaml
sections:
  - type: "outcomehero"
    title: "Transform Your Business Outcomes"
    content: "Discover how our approach delivers measurable results"
    boxes:
      - text: "**Increase Team Velocity** by up to 40% with proven agile practices"
      - text: "**Reduce Time to Market** and deliver value faster to customers"
      - text: "**Improve Quality** through continuous integration and delivery"
    cta:
      text: "Ready to transform your organization? Let's start your journey today."
      button:
        text: "Get Started Now"
        url: "/contact"
```

## Box Color Scheme

1. **First Box**: Uses `--primary-color` (your brand purple: #713183)
2. **Second Box**: Uses `--light-accent-color-alt` (light purple: #dcace8)
3. **Third Box**: Uses custom color `#fbf3fe` (very light purple/pink)

## Features

- **Responsive Design**: Stacks vertically on mobile devices
- **Hover Effects**: Boxes lift up slightly on hover
- **Dark Mode Support**: Colors adjust automatically for dark theme
- **Flexible Content**: Each box supports Markdown formatting
- **Call-to-Action**: Customizable text and button

## Customization

You can customize the content of each box and the call-to-action section. The boxes will automatically cycle through the three defined colors in order.
