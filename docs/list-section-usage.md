# List Section Usage

The `list` section type creates a styled list where each item has an icon, title, and content without traditional bullet points.

## YAML Configuration

```yaml
sections:
  - title: "Section Title"
    type: list
    listType: default # or "boxed" for two-column bordered layout
    list:
      - title: "First Item Title"
        icon: "fa-code" # Font Awesome icon class
        content: |
          Content for the first item.
          Supports markdown formatting.
      - title: "Second Item Title"
        icon: "fa-cogs"
        content: |
          Content for the second item.
          Multiple paragraphs are supported.
```

## Parameters

### Section Level

- `title` (optional): Section title displayed above the list
- `type`: Must be "list"
- `listType` (optional): Display style - "default" or "boxed" (default: "default")
- `list`: Array of list items

### List Item Level

- `title` (required): The title for the list item
- `icon` (optional): Font Awesome icon class (e.g., "fa-code", "fa-cogs", "fa-rocket")
- `content` (optional): The content below the title. Supports markdown.

## List Types

### Default (`listType: default`)

- Single column layout
- Clean, minimal styling
- Items separated by white space
- Smaller text size for content

### Boxed (`listType: boxed`)

- Two-column grid layout (single column on mobile)
- Bordered boxes with background
- Larger text size for enhanced readability
- Hover effects with shadow and lift
- Each item contained in its own styled box

## Features

- **Icon Support**: Uses Font Awesome icons displayed to the left of titles
- **Clean Layout**: No traditional bullet points - items are separated by spacing
- **Multiple Display Types**: Choose between "default" (single column) and "boxed" (two-column with borders)
- **Responsive**: Adapts to different screen sizes (boxed layout becomes single column on mobile)
- **Theme Support**: Automatically adjusts colors for light/dark themes
- **Markdown Support**: Content fields support markdown formatting

## Example Output

### Default List Type

The default list section renders as:

- Icon and title on the same line
- Content on a new line below, indented to align with the title
- Consistent spacing between items
- Clean, minimal styling

### Boxed List Type

The boxed list section renders as:

- Two-column grid layout (single column on mobile)
- Each item in its own bordered box with background
- Larger text for better readability
- Hover effects with shadow and lift animation
- Enhanced visual separation between items

## Styling

The section uses these CSS classes:

### Default List Type

- `.list-section`: Container for the entire list
- `.list-item`: Individual list item container
- `.list-item-header`: Contains icon and title
- `.list-item-icon`: Font Awesome icon styling
- `.list-item-title`: Title text styling
- `.list-item-content`: Content area styling

### Boxed List Type

- `.list-section-boxed`: Container with grid layout
- `.list-section-boxed .list-item`: Bordered box styling with hover effects
- `.list-section-boxed .list-item-icon`: Larger icon styling
- `.list-section-boxed .list-item-title`: Enhanced title styling
- `.list-section-boxed .list-item-content`: Larger content text styling
