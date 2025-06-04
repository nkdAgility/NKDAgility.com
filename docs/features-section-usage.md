# Features Section Usage

The `features` section type creates an alternating layout of feature descriptions with accompanying images or media. This is perfect for showcasing product features, service highlights, or step-by-step processes.

## Basic Structure

```yaml
sections:
  - type: "features"
    title: "Key Features"
    content: "Discover what makes our approach unique"
    features:
      - title: "Agile Transformation"
        content: "We guide organizations through comprehensive agile transformations that deliver real business value and sustainable change."
        media: "agile-transformation.jpg"
      - title: "DevOps Implementation"
        content: "Our DevOps expertise helps teams achieve continuous integration and deployment with industry best practices."
        media: "devops-pipeline.png"
      - title: "Team Coaching"
        content: "Personalized coaching sessions that empower teams to adopt agile practices and improve collaboration."
        media: "team-coaching.jpg"
```

## Features

- **Alternating Layout**: Odd features show image on left, even features show image on right
- **Responsive Design**: Stacks vertically on mobile devices
- **Image Support**: Supports both local page resources and global images
- **Lightbox Integration**: Images are clickable and open in lightbox overlay
- **Rich Content**: Full Markdown support in titles and content
- **Flexible Media**: Works with various image formats and sizes

## Parameters

### Required

- `type`: Must be "features"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `features`: Array of feature objects
  - `title`: Feature title (supports Markdown)
  - `content`: Feature description (supports Markdown)
  - `media`: Image path (local or global)

## Layout Pattern

Features alternate their image placement:

1. **Odd-numbered features** (1st, 3rd, 5th): Image on left, content on right
2. **Even-numbered features** (2nd, 4th, 6th): Content on left, image on right

This creates a visually appealing zigzag layout that guides the reader's eye down the page.

## Image Handling

The section supports two types of image paths:

### Global Images

```yaml
media: "/images/global-image.jpg"
```

- Images stored in the site's global images directory
- Use absolute paths starting with `/images/`

### Page Resources

```yaml
media: "local-image.jpg"
```

- Images stored alongside the page content
- Use relative filenames without path

## Examples

### Service Features

```yaml
- type: "features"
  title: "Our Methodology"
  content: "A proven approach to agile transformation"
  features:
    - title: "**Assessment & Discovery**"
      content: |
        We begin every engagement with a comprehensive assessment of your current state, 
        identifying opportunities and challenges that will shape your transformation journey.
      media: "assessment-process.jpg"
    - title: "**Custom Strategy Development**"
      content: |
        Based on our findings, we develop a tailored strategy that aligns with your business 
        objectives and organizational culture.
      media: "strategy-development.png"
    - title: "**Hands-on Implementation**"
      content: |
        Our experts work alongside your teams to implement changes, providing guidance and 
        support throughout the transformation process.
      media: "implementation-support.jpg"
```

### Product Capabilities

```yaml
- type: "features"
  title: "Platform Capabilities"
  features:
    - title: "Real-time Analytics"
      content: "Get instant insights into your team's performance with our advanced analytics dashboard that tracks velocity, quality metrics, and team health indicators."
      media: "/images/analytics-dashboard.png"
    - title: "Automated Workflows"
      content: "Streamline your processes with intelligent automation that reduces manual work and ensures consistency across all your projects."
      media: "workflow-automation.jpg"
```

### Process Steps

```yaml
- type: "features"
  title: "How It Works"
  content: "Our simple three-step process gets you started quickly"
  features:
    - title: "1. **Initial Consultation**"
      content: "We discuss your challenges, goals, and current state to understand how we can best help your organization."
      media: "consultation-meeting.jpg"
    - title: "2. **Tailored Solution Design**"
      content: "Our experts design a customized approach that fits your specific needs and organizational constraints."
      media: "solution-design.png"
    - title: "3. **Implementation & Support**"
      content: "We work with your teams to implement solutions and provide ongoing support to ensure long-term success."
      media: "implementation-team.jpg"
```

## Styling

The section uses these CSS classes:

- `.row`: Main container for each feature
- `.col-12`: Full-width feature container
- `.card`: Feature card wrapper
- `.card-body`: Content area
- `.card-title.nkda-heading-secondary`: Feature title styling
- `.card-text`: Feature content styling
- `.order-*`: Bootstrap classes for controlling layout order

## Responsive Behavior

- **Desktop**: Two-column layout with alternating image placement
- **Tablet**: May stack depending on content length
- **Mobile**: Single column with images above content

## Best Practices

1. **Consistent Image Sizes**: Use images with similar aspect ratios for visual consistency
2. **Balanced Content**: Keep feature descriptions roughly the same length
3. **Progressive Disclosure**: Order features from most important to least important
4. **Alt Text**: Ensure image filenames are descriptive for accessibility
5. **Meaningful Titles**: Use action-oriented or benefit-focused titles
6. **Quality Images**: Use high-resolution images that look good at various sizes

## Error Handling

If an image cannot be found, the template displays "failed to get image" along with the image path for debugging purposes.

## Lightbox Integration

All feature images automatically open in a lightbox when clicked, using the feature title as the caption. This allows users to view images in detail without leaving the page.
