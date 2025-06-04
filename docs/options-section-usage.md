# Options Section Usage (Consulting Options)

The `options` section type displays a predefined set of consulting service packages in a card-based layout. This section is specifically designed to showcase different levels of consulting engagement.

## Basic Structure

```yaml
sections:
  - type: "options"
    title: "Consulting Packages"
    content: "Choose the level of support that best fits your needs"
```

## Features

- **Predefined Options**: Shows three fixed consulting packages
- **Card Layout**: Professional card design with detailed information
- **Service Tiers**: Basic, Extended, and Comprehensive packages
- **Detailed Descriptions**: Each option includes scope, deliverables, and benefits
- **Responsive Design**: Three-column layout that adapts to screen size

## Parameters

### Required

- `type`: Must be "options"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)

Note: This section displays predefined content and doesn't accept custom options.

## Predefined Consulting Options

### Option 1: Basic Package (1 week)

**Duration**: 1 week  
**Focus**: Minimal ongoing assistance

**Includes**:

- Technical consulting and support for migrations
- Onboarding support and optimization for critical workflows
- One demo session on practices or tools best practices

**Best For**: Organizations that primarily need a little help with minimal ongoing assistance.

### Option 2: Extended Package (1 month)

**Duration**: 1 month  
**Focus**: Early-stage support and best practices

**Includes**:

- Everything from Option 1
- Up to four training/workshop sessions on Azure DevOps tools and best practices

**Best For**: Teams seeking initial assistance with a focus on establishing best practices and optimizing DevOps features from the start.

### Option 3: Comprehensive Package (3 months)

**Duration**: 3 months  
**Focus**: Complete transformation support

**Includes**:

- Everything from Options 1 and 2
- Extended consulting and support
- Comprehensive training program
- Ongoing optimization and best practice implementation

**Best For**: Organizations requiring comprehensive transformation support and long-term guidance.

## Examples

### Service Page Usage

```yaml
- type: "options"
  title: "Azure DevOps Consulting Packages"
  content: "Flexible engagement options to maximize your Azure DevOps investment"
```

### Landing Page Display

```yaml
- type: "options"
  title: "How We Can Help"
  content: "Choose from three proven engagement models designed to deliver maximum value"
```

### Pricing Page Integration

```yaml
- type: "options"
  title: "Consulting Options"
  content: "Transparent pricing for every level of engagement"
```

## Layout Structure

- **3-Column Grid**: `col-xl-4` for each option
- **Card Design**: Professional cards with headers, content, and lists
- **Consistent Heights**: Flexbox ensures equal card heights
- **Visual Hierarchy**: Clear distinction between title, description, and features

## Card Components

Each option card includes:

1. **Header Section**:

   - Package name and duration
   - Brief overview description

2. **Feature List**:

   - Bullet-pointed list of included services
   - Uses Bootstrap list-group styling

3. **Footer Section**:
   - Target audience description
   - Ideal use case explanation

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-xl-4`: Three-column layout
- `.card.sectioncards`: Professional card styling
- `.card-body`: Content padding and spacing
- `.list-group`: Feature list styling
- `.text-muted`: Subtle text for descriptions

## Responsive Behavior

- **Desktop**: Three-column layout showing all options side-by-side
- **Tablet**: May stack to two columns depending on screen size
- **Mobile**: Single column stack for optimal mobile viewing

## Use Cases

This section is perfect for:

1. **Service Pages**: Showcase different engagement levels
2. **Pricing Pages**: Display transparent consulting options
3. **Landing Pages**: Help visitors choose appropriate support level
4. **Proposal Templates**: Standardized options for client proposals

## Content Strategy

The predefined options help:

- **Simplify Decision Making**: Clear tiers reduce choice paralysis
- **Set Expectations**: Detailed descriptions clarify what's included
- **Qualify Leads**: Different options attract appropriate client types
- **Standardize Offerings**: Consistent packages for sales and delivery

## Customization Notes

This section currently displays fixed content. To customize:

1. **Template Modification**: Edit the HTML template directly
2. **Content Updates**: Modify the predefined text in the template
3. **Styling Changes**: Adjust CSS classes for different appearance
4. **Additional Options**: Extend the template to include more packages

## Best Practices

1. **Clear Differentiation**: Ensure each option clearly shows added value
2. **Progressive Value**: Structure options from basic to comprehensive
3. **Specific Deliverables**: Include concrete, measurable outcomes
4. **Target Audience**: Clearly identify who each option serves best
5. **Call-to-Action**: Consider adding booking or contact buttons

## Integration Considerations

When using this section:

- **Page Context**: Works best on service or consulting-focused pages
- **Supporting Content**: Pair with testimonials or case studies
- **Contact Forms**: Include nearby contact options for inquiries
- **Pricing Information**: Consider if pricing should be displayed

This section provides a professional way to present standardized consulting packages, helping potential clients understand and choose appropriate engagement levels.
