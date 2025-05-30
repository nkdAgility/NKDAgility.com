# Quote Section Usage

The `quote` section type creates a large, stylized quote display perfect for testimonials, client feedback, or important statements.

## YAML Configuration

```yaml
sections:
  - type: quote
    backgroundColor: primary # optional: none, primary, secondary
    quote: | # or use 'content:' - both work
      "Thanks to Martin's guidance and support we successfully upgraded Azure DevOps from and unstable database, moved our dev teams to the latest Visual Studio, and implemented the finest build process ever known!

      I would recommend Martin to anyone, in fact I would insist they use him as he is the best DevOps consultant i've worked with."
      - **Paul Martin | IT Director**
```

## Parameters

### Section Level

- `type`: Must be "quote"
- `backgroundColor` (optional): Background color for the section
  - `none` or omitted: Default background
  - `primary`: Uses `--primary-color-background`
  - `secondary`: Uses `--secondary-color`
- `quote` or `content` (required): The quote text and attribution. Supports markdown.

## Background Color Options

### None (Default)

- Standard page background
- Normal text colors
- Quote mark in primary color

### Primary (`backgroundColor: primary`)

- Primary brand color background (`--primary-color-background`)
- White text for optimal contrast
- Semi-transparent white quote mark
- Ideal for emphasis and call-to-action quotes

### Secondary (`backgroundColor: secondary`)

- Secondary brand color background (`--secondary-color`)
- White text for optimal contrast
- Semi-transparent white quote mark
- Good for variety and visual hierarchy

## Features

- **Large Typography**: Prominent display with large, readable text
- **Quote Marks**: Decorative opening quote mark using CSS
- **Attribution Support**: Use markdown bold (`**`) for attribution styling
- **Background Colors**: Three background options for visual variety
- **Responsive**: Adapts typography and spacing for mobile devices
- **Theme Support**: Automatically adjusts for light/dark themes
- **Markdown Support**: Full markdown support in content

## Attribution Formatting

For proper attribution styling, place the attribution as the last paragraph and use markdown bold:

```markdown
content: |
"Your quote text here..."

- **Author Name | Title**
```

This will style the attribution differently from the main quote text.

## Example Output

The quote section renders as:

- Large opening quotation mark
- Italicized quote text in large font
- Attribution in smaller, non-italic text
- Proper spacing and visual hierarchy
- Responsive design for all screen sizes

## Styling

The section uses these CSS classes:

### Quote Section

- `.quote-section`: Container for the quote
- `.quote-blockquote`: Main quote container (overrides default blockquote)
- `.quote-blockquote::before`: Large decorative quote mark
- `.quote-content`: Quote text container
- `.quote-content p:last-child strong`: Attribution styling

### Background Colors

- `.section-bg-primary`: Primary background color styling
- `.section-bg-secondary`: Secondary background color styling

## Use Cases

- **Customer testimonials**
- **Company mission statements**
- **Expert endorsements**
- **Case study quotes**
- **Leadership statements**
- **Industry recognition**
