# Trustpilot Section Usage

The `trustpilot` section type embeds a Trustpilot review widget to display customer reviews and ratings. This is perfect for building trust and showcasing social proof on your website.

## Basic Structure

```yaml
sections:
  - type: "trustpilot"
    title: "What Our Customers Say"
    content: "See why organizations trust us with their agile transformation"
    height: "400px"
    tags: "training,consulting"
```

## Features

- **Trustpilot Integration**: Embeds official Trustpilot widget
- **Customizable Display**: Control height, tags, and styling
- **Light Theme**: Uses light theme for consistency
- **High-Rating Focus**: Shows 4 and 5-star reviews by default
- **Locale Support**: Configured for English (US) locale
- **Grid Layout**: Uses Trustpilot's grid template for optimal display

## Parameters

### Required

- `type`: Must be "trustpilot"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `height`: Widget height (e.g., "400px", "300px")
- `tags`: Comma-separated tags to filter reviews (e.g., "training,consulting")

## Trustpilot Configuration

The widget uses these default settings:

- **Business Unit ID**: `5c12d8d7393a0100015d1c3e` (configured for scrum.org)
- **Template**: Grid layout (`539adbd6dec7e10e686debee`)
- **Locale**: English US (`en-US`)
- **Theme**: Light theme
- **Star Filter**: Shows 4 and 5-star reviews only
- **Width**: 100% responsive width

## Examples

### Basic Trustpilot Widget

```yaml
- type: "trustpilot"
  title: "Customer Reviews"
  content: "Read what our clients say about their experience"
  height: "400px"
```

### Service-Specific Reviews

```yaml
- type: "trustpilot"
  title: "Training Reviews"
  content: "Feedback from our course participants"
  height: "350px"
  tags: "training,scrum,certification"
```

### Consulting Testimonials

```yaml
- type: "trustpilot"
  title: "Consulting Success Stories"
  content: "See how we've helped organizations transform"
  height: "450px"
  tags: "consulting,transformation,devops"
```

### Compact Display

```yaml
- type: "trustpilot"
  title: "Quick Reviews"
  height: "250px"
  tags: "coaching"
```

## Widget Behavior

The Trustpilot widget will:

1. **Load Reviews**: Fetch reviews matching the specified tags and star ratings
2. **Display Grid**: Show reviews in a responsive grid layout
3. **Link to Profile**: Include a link to the full Trustpilot profile
4. **Auto-Update**: Reflect new reviews as they're posted to Trustpilot

## Conditional Display

The widget includes a conditional check:

- Only displays if `trustpilot` parameter is not explicitly set to `false`
- This allows you to disable the widget on specific pages if needed

### Disabling Trustpilot

```yaml
- type: "trustpilot"
  title: "Reviews"
  trustpilot: false # This will prevent the widget from showing
```

## Tag Filtering

Use tags to show relevant reviews:

### Training-Related Tags

```yaml
tags: "training,scrum,certification,learning"
```

### Consulting-Related Tags

```yaml
tags: "consulting,transformation,coaching,devops"
```

### General Service Tags

```yaml
tags: "service,support,agile,professional"
```

## Height Recommendations

Choose appropriate heights based on expected content:

- **Compact**: `"250px"` - For minimal space usage
- **Standard**: `"400px"` - Good balance of content and space
- **Extended**: `"500px"` - For showcasing more reviews
- **Full Display**: `"600px"` - Maximum review visibility

## Styling

The widget uses these attributes:

- `height="100%"`: Full height within container
- `class="trustpilot-widget"`: Trustpilot's widget class
- `data-style-width="100%"`: Full responsive width
- `data-theme="light"`: Light theme for consistency

## Best Practices

1. **Relevant Tags**: Use tags that match your actual Trustpilot review categories
2. **Appropriate Height**: Choose height that displays content without excessive whitespace
3. **Strategic Placement**: Position near conversion points for maximum impact
4. **Regular Monitoring**: Ensure your Trustpilot profile stays active and current
5. **Contextual Usage**: Place on pages where social proof is most valuable

## Integration Requirements

To use this section:

1. **Trustpilot Account**: Must have an active Trustpilot business profile
2. **Business Unit ID**: Configure the correct ID in the template
3. **Review Tags**: Use consistent tagging in your Trustpilot reviews
4. **Domain Verification**: Ensure your domain is verified with Trustpilot

## Responsive Behavior

- **Desktop**: Full grid layout with multiple review columns
- **Tablet**: Responsive grid that adapts to screen size
- **Mobile**: Single-column layout for optimal mobile viewing

## External Dependencies

The widget requires:

- Trustpilot's JavaScript widget library
- Internet connection for loading reviews
- Trustpilot service availability

## Security

- Uses standard Trustpilot embed code
- No custom JavaScript or tracking
- Respects user privacy through Trustpilot's policies
- Links open in new tab with `rel="noopener"`

## Troubleshooting

If the widget doesn't display:

1. **Check Business Unit ID**: Verify the ID matches your Trustpilot profile
2. **Review Tags**: Ensure tags match actual review categories
3. **Account Status**: Confirm Trustpilot account is active and verified
4. **Network**: Check if Trustpilot services are accessible
5. **Console Errors**: Look for JavaScript errors in browser console

This section is ideal for landing pages, service pages, and anywhere you want to showcase customer satisfaction and build trust with potential clients.
