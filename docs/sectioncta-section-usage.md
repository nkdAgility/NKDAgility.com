# SectionCTA Section Usage

The `sectioncta` section type displays a simple call-to-action with content and button on the same line. This is perfect for ending sections or pages with a clear action for the user to take.

## Basic Structure

```yaml
sections:
  - type: "sectioncta"
    backgroundColor: "primary"
    cta:
      content: "Ready to transform your business?"
      button:
        text: "Get Started"
        url: "/contact"
```

## Features

- **Inline Layout**: Content and button appear on the same line
- **Background Colors**: Support for primary, secondary, or no background
- **Responsive**: Stacks vertically on mobile devices
- **Rich Content**: Support for Markdown in content field
- **Theme Support**: Works with both light and dark themes

## Parameters

### Required

- `type`: Must be "sectioncta"
- `cta`: Call-to-action configuration

### Optional

- `backgroundColor`: Background color ("primary", "secondary", or none)
- `cta.content`: CTA text (supports Markdown)
- `cta.button`: Button configuration
  - `text`: Button text
  - `url`: Button link

## Styling

The section uses these CSS classes:

- `.sectioncta-section`: Main container
- `.sectioncta-content`: Flex container for content and button
- `.sectioncta-text`: Text content
- `.sectioncta-button`: CTA button

## Examples

### Simple CTA

```yaml
- type: "sectioncta"
  cta:
    content: "Ready to get started?"
    button:
      text: "Contact Us"
      url: "/contact"
```

### With Background Color

```yaml
- type: "sectioncta"
  backgroundColor: "primary"
  cta:
    content: "Transform your team today!"
    button:
      text: "Schedule Consultation"
      url: "/book-consultation"
```

### With Emphasis

```yaml
- type: "sectioncta"
  backgroundColor: "secondary"
  cta:
    content: "We've helped teams like yours. **Let's talk.**"
    button:
      text: "Book a Call"
      url: "/contact"
```

### End of Page CTA

```yaml
- type: "sectioncta"
  backgroundColor: "primary"
  cta:
    content: "Don't let technical debt slow you down any longer."
    button:
      text: "Start Your Transformation"
      url: "/contact"
```

## Best Practices

1. **Clear Action**: Use action-oriented button text like "Get Started", "Schedule Call", "Learn More"
2. **Compelling Content**: Make the CTA content compelling and relevant to the page context
3. **Consistent Styling**: Use background colors that match your page design
4. **Mobile Friendly**: Content automatically stacks on mobile for better readability
5. **Strategic Placement**: Use at the end of sections or pages to guide user actions
