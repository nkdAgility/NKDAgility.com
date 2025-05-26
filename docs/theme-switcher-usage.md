# Theme Switcher Usage Guide

## Theme Selection Options

The site includes a theme dropdown in the top navigation bar that allows users to choose between:

1. **Light Mode**: Forces the light theme regardless of system settings
2. **Dark Mode**: Forces the dark theme regardless of system settings
3. **System**: Automatically syncs with the user's operating system preference

When "System" is selected, the theme will automatically update if the user changes their system's light/dark mode setting.

### Implementation Details

The theme preference is stored in the browser's localStorage as:

- `'light'` for Light Mode
- `'dark'` for Dark Mode
- `'system'` for System Sync Mode


### Preventing Theme Flash (FOUC)

To ensure the correct theme is applied immediately (with no flash of the wrong theme), the site uses a small inline script that sets the `data-theme` attribute on the `<html>` element **before any CSS loads**. This script is included at the very top of the `<head>` in the main layout:

```html
<script src="/js/theme-switcher-preset.js"></script>
```

The script checks for the user's saved theme preference in localStorage. If set to 'system' or not set, it uses the system's color scheme preference. This ensures the correct theme is applied from the first paint, eliminating any flash of the wrong theme.

The main theme switcher logic (`theme-switcher.js`) continues to handle theme changes and UI updates after the page loads.

## Using Theme-Aware Images

The site's theme switcher includes support for theme-aware images - images that automatically change when switching between light and dark themes.

### How to Use Theme-Aware Images

To make an image adapt to the current theme, add the following data attributes to your `img` tag:

```html
<img src="/path/to/default-image.png" data-theme-src-light="/path/to/light-theme-image.png" data-theme-src-dark="/path/to/dark-theme-image.png" alt="Description of the image" />
```

### Attributes Explained

- `src`: The default image to display before the theme is applied
- `data-theme-src-light`: The image to display in light mode
- `data-theme-src-dark`: The image to display in dark mode
- Other standard attributes like `alt`, `width`, `height`, `loading`, etc. work as normal

### Example

```html
<img src="/images/logo-light.png" data-theme-src-light="/images/logo-light.png" data-theme-src-dark="/images/logo-dark.png" loading="lazy" alt="Company Logo" width="234" height="95" />
```

## CSS Variables

The site uses CSS custom properties (variables) for theming. You can use these variables in your custom CSS to maintain theme consistency.

### Light Mode Variables

```css
/* Light Mode - Brand Colors */
--light-primary-color: #713183;
--light-primary-color-light: #8b49a0;
--light-secondary-color: #007acc;
--light-secondary-color-light: #3399dd;
--light-accent-color: #e37f01;
--light-accent-color-light: #f3952e;
--light-accent-color-alt: #dcace8;
--light-accent-color-alt-light: #eac2f0;

/* Light Mode - UI Colors */
--light-background-color: #ecf0f1;
--light-primary-color-text: #ffffff;
--light-text-color: #333333;
--light-blockquote-bg: #ededed;
--light-blockquote-text: #555555;
--light-blockquote-border: #78c0a8;
```

### Dark Mode Variables

```css
/* Dark Mode - Brand Colors */
--dark-primary-color: #9b5baf;
--dark-primary-color-light: #b27fc2;
--dark-secondary-color: #3399dd;
--dark-secondary-color-light: #66b3ff;
--dark-accent-color: #f3952e;
--dark-accent-color-light: #ffb151;
--dark-accent-color-alt: #eac2f0;
--dark-accent-color-alt-light: #f4e0f7;

/* Dark Mode - UI Colors */
--dark-background-color: #1e1e1e;
--dark-primary-color-text: #ffffff;
--dark-text-color: #f5f5f5;
--dark-blockquote-bg: #333333;
--dark-blockquote-text: #dddddd;
--dark-blockquote-border: #78c0a8;
```

### Using Theme Variables in Custom CSS

For theme-aware styling, use the main variables without the `light-` or `dark-` prefix:

```css
.my-custom-element {
  background-color: var(--background-color);
  color: var(--text-color);
  border: 1px solid var(--primary-color);
}
```

These variables will automatically update when the theme changes.
