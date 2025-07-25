# Headline Section Usage

The `headline` section type creates a hero-style header with title, subtitle, optional images, and call-to-action buttons. This is perfect for landing pages, feature announcements, or prominent content introductions.

## Basic Structure

```yaml
sections:
  - type: "headline"
    headline:
      title: "Transform Your Organization with Agile Excellence"
      subtitle: "Professional training and consulting to accelerate your digital transformation"
      content: "Our proven methodologies help teams deliver better software faster while building high-performing, collaborative cultures that drive sustainable business results."
      images:
        - "/images/partners/microsoft.png"
        - "/images/partners/scrum-org.png"
        - "/images/partners/devops-institute.png"
      buttons:
        - content: "Start Your Journey"
          link: "/contact"
        - content: "View Training"
          link: "/training-courses"
```

## Features

- **Split Layout**: Two-column responsive design with content and text
- **Flexible Headlines**: Uses section configuration or page title/subtitle as fallback
- **Partner Logos**: Automatic image grid with responsive columns
- **Call-to-Action Buttons**: Multiple buttons with internal/external link support
- **Markdown Support**: Full Markdown rendering in all text fields
- **Image Optimization**: Automatic resizing and optimization for logos
- **Responsive Design**: Adapts to different screen sizes

## Parameters

### Required

- `type`: Must be "headline"

### Optional

- `headline`: Headline configuration object
  - `title`: Main headline text (falls back to page title)
  - `subtitle`: Subtitle text (falls back to page subtitle)
  - `content`: Main content description
  - `images`: Array of image paths for partner/logo display
  - `buttons`: Array of call-to-action buttons
    - `content`: Button text
    - `link`: Button URL (supports internal and external links)

## Image Handling

### Image Sources

- **Site Images**: Use paths like `/images/partners/logo.png`
- **Page Resources**: Use relative paths like `partner-logo.png`

### Image Layout

- **3 Images or Multiple of 3**: Uses 3-column layout (`col-sm-4`)
- **Even Numbers (2, 4, 6, etc.)**: Uses 2-column layout (`col-sm-6`)
- **Other Numbers**: Defaults to 3-column layout

### Image Optimization

- **Automatic Resizing**: Page resource images resized to 200x80px
- **Object Fit**: Images maintain aspect ratio with `object-fit: contain`
- **Max Height**: All images constrained to 80px height
- **Lazy Loading**: Images load on scroll for performance

## Button Types

### Internal Links

```yaml
buttons:
  - content: "Learn More"
    link: "/about"
  - content: "Contact Us"
    link: "/contact"
```

### External Links

```yaml
buttons:
  - content: "Visit Website"
    link: "https://example.com"
  - content: "Download PDF"
    link: "https://example.com/file.pdf"
```

External links automatically include:

- `target="_blank"` for new window opening
- `rel="noopener noreferrer"` for security
- External link icon indicator

## Examples

### Simple Hero

```yaml
- type: "headline"
  headline:
    title: "Professional Scrum Training"
    subtitle: "Master the art of agile delivery"
    content: "Join thousands of professionals who have transformed their careers through our comprehensive Scrum training programs."
```

### With Partner Logos

```yaml
- type: "headline"
  headline:
    title: "Trusted by Industry Leaders"
    subtitle: "Partnerships that drive excellence"
    content: "We work with the world's leading organizations to deliver transformational results."
    images:
      - "/images/partners/microsoft.png"
      - "/images/partners/amazon.png"
      - "/images/partners/google.png"
      - "/images/partners/ibm.png"
```

### Call-to-Action Focus

```yaml
- type: "headline"
  headline:
    title: "Ready to Transform Your Team?"
    subtitle: "Start your agile journey today"
    content: "Book a consultation with our experts and discover how agile practices can revolutionize your delivery capabilities."
    buttons:
      - content: "Book Consultation"
        link: "/book-consultation"
      - content: "View Success Stories"
        link: "/case-studies"
      - content: "Download Guide"
        link: "https://example.com/agile-guide.pdf"
```

### Page Title Fallback

```yaml
- type: "headline"
  # Uses page title and subtitle from front matter
```

When no headline configuration is provided, the section automatically uses:

- Page `Title` for the headline
- Page `subtitle` parameter for the subtitle
- No content, images, or buttons

## Layout Structure

- **Container**: `.row.p-2.p-lg-5` with responsive padding
- **Left Column**: `.col-md-6` containing headline, subtitle, images, and buttons
- **Right Column**: `.col-md-6` containing main content
- **Responsive**: Stacks vertically on mobile devices

## Styling

The section uses these CSS classes:

- `.nkda-heading-primary`: Main headline styling
- `.nkda-heading-secondary`: Subtitle styling
- `.nkda-heading-primary-content`: Content area styling
- `.btn.btn-nkdprimary`: Primary button styling
- `.external-link`: External link specific styling
- `.img-fluid`: Bootstrap responsive image class

## Best Practices

1. **Clear Headlines**: Use action-oriented, benefit-focused headlines
2. **Concise Subtitles**: Keep subtitles under 15 words for impact
3. **Scannable Content**: Use short paragraphs and bullet points in content
4. **Logo Quality**: Use high-resolution logos with transparent backgrounds
5. **Button Hierarchy**: Limit to 2-3 buttons with clear primary action
6. **Mobile First**: Test how content stacks on mobile devices
7. **Loading Performance**: Optimize images before upload

## Fallback Behavior

- **Missing Title**: Uses page title from front matter
- **Missing Subtitle**: Uses page subtitle parameter
- **Missing Images**: Section displays without image grid
- **Missing Buttons**: Section displays without CTA area
- **Image Not Found**: Shows error message in development

## Common Use Cases

- **Landing Page Heroes**: Main page introductions
- **Product Launches**: Feature announcement headers
- **Partner Showcases**: Display partner/client logos
- **Campaign Pages**: Marketing campaign headers
- **Course Introductions**: Training program headers

The `headline` section provides a powerful, flexible way to create compelling hero sections that drive engagement and action.
