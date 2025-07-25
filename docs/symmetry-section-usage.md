# Symmetry Section Usage

The `symmetry` section type creates a comparison table layout where multiple columns (boxes) are compared side-by-side with symmetric rows of items. This is perfect for feature comparisons, service tier comparisons, or side-by-side analysis.

## Basic Structure

```yaml
sections:
  - type: "symmetry"
    title: "Training Package Comparison"
    content: "Compare our training packages to find the right fit"
    boxes:
      - title: "Basic Package"
        content: "Essential training for small teams"
        items:
          - title: "2-day workshop"
            icon: "fa-clock"
          - title: "Digital materials"
            icon: "fa-file-pdf"
          - title: "Email support"
            icon: "fa-envelope"
      - title: "Professional Package"
        content: "Comprehensive training with coaching"
        items:
          - title: "5-day intensive program"
            icon: "fa-calendar"
          - title: "Interactive workshops"
            icon: "fa-users"
          - title: "Personal coaching"
            icon: "fa-user-tie"
          - title: "Certification"
            icon: "fa-certificate"
      - title: "Enterprise Package"
        content: "Full organizational transformation"
        items:
          - title: "Custom program design"
            icon: "fa-cogs"
          - title: "Leadership coaching"
            icon: "fa-crown"
          - title: "Change management"
            icon: "fa-chart-line"
          - title: "Ongoing support"
            icon: "fa-headset"
```

## Features

- **Table Layout**: Professional table-based comparison format
- **Symmetric Design**: All columns have the same height structure
- **Icon Support**: FontAwesome icons for each item
- **Visual Hierarchy**: Different styling for each column
- **Responsive**: Horizontal scrolling on mobile devices
- **Empty Cell Handling**: Graceful handling of missing items
- **Flexible Columns**: Supports any number of comparison columns

## Parameters

### Required

- `type`: Must be "symmetry"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `boxes`: Array of comparison column objects
  - `title`: Column header title
  - `content`: Column description
  - `items`: Array of item objects
    - `title`: Item text
    - `icon`: FontAwesome icon class (e.g., "fa-check", "fa-star")

## Table Structure

### Header Row

Each box creates a table header with:

- **Title**: Box title as main header
- **Description**: Box content as subheader

### Body Rows

- **Symmetric Rows**: Table creates rows equal to the longest item list
- **Item Alignment**: Items align horizontally across columns
- **Empty Cells**: Columns with fewer items show empty cells
- **Icon Integration**: Icons display before item text

## Visual Styling Hierarchy

Columns automatically cycle through three visual styles:

### Header Styles

1. **Primary Header**: First column (index 0)
2. **Accent Header**: Second column (index 1)
3. **Light Header**: Third column (index 2)
4. **Cycle Repeats**: For more than 3 columns

### Cell Styles

1. **Primary Cells**: First column content
2. **Accent Cells**: Second column content
3. **Light Cells**: Third column content
4. **Cycle Repeats**: For additional columns

## Examples

### Service Tier Comparison

```yaml
- type: "symmetry"
  title: "Consulting Service Levels"
  content: "Choose the level of support that matches your needs"
  boxes:
    - title: "Starter"
      content: "$5,000/month"
      items:
        - title: "Monthly check-ins"
          icon: "fa-calendar-check"
        - title: "Email support"
          icon: "fa-envelope"
        - title: "Basic reporting"
          icon: "fa-chart-bar"
    - title: "Professional"
      content: "$12,000/month"
      items:
        - title: "Weekly coaching sessions"
          icon: "fa-calendar-week"
        - title: "Priority support"
          icon: "fa-headset"
        - title: "Detailed analytics"
          icon: "fa-chart-line"
        - title: "Custom training"
          icon: "fa-graduation-cap"
    - title: "Enterprise"
      content: "Custom pricing"
      items:
        - title: "Daily availability"
          icon: "fa-calendar-day"
        - title: "Dedicated account manager"
          icon: "fa-user-tie"
        - title: "Real-time dashboards"
          icon: "fa-tachometer-alt"
        - title: "Organization-wide training"
          icon: "fa-building"
        - title: "Strategic planning"
          icon: "fa-chess"
```

### Feature Matrix

```yaml
- type: "symmetry"
  title: "Platform Features"
  boxes:
    - title: "Community"
      content: "Free forever"
      items:
        - title: "Basic project management"
          icon: "fa-check"
        - title: "5 team members"
          icon: "fa-users"
        - title: "Community support"
          icon: "fa-comments"
    - title: "Team"
      content: "$10/user/month"
      items:
        - title: "Advanced project management"
          icon: "fa-check"
        - title: "Unlimited team members"
          icon: "fa-infinity"
        - title: "Priority support"
          icon: "fa-star"
        - title: "Integrations"
          icon: "fa-plug"
    - title: "Enterprise"
      content: "Contact sales"
      items:
        - title: "Custom workflows"
          icon: "fa-check"
        - title: "SSO authentication"
          icon: "fa-lock"
        - title: "Dedicated support"
          icon: "fa-crown"
        - title: "Custom integrations"
          icon: "fa-cogs"
        - title: "SLA guarantee"
          icon: "fa-handshake"
```

### Training Curriculum

```yaml
- type: "symmetry"
  title: "Learning Path Comparison"
  content: "Different paths to achieve Scrum mastery"
  boxes:
    - title: "Self-Paced"
      content: "Learn at your own speed"
      items:
        - title: "Online modules"
          icon: "fa-laptop"
        - title: "Practice exercises"
          icon: "fa-dumbbell"
        - title: "Self-assessment"
          icon: "fa-clipboard-check"
    - title: "Instructor-Led"
      content: "Guided learning experience"
      items:
        - title: "Live virtual classes"
          icon: "fa-video"
        - title: "Interactive workshops"
          icon: "fa-users"
        - title: "Real-time feedback"
          icon: "fa-comments"
        - title: "Peer collaboration"
          icon: "fa-handshake"
    - title: "Mentored"
      content: "Personalized guidance"
      items:
        - title: "One-on-one sessions"
          icon: "fa-user"
        - title: "Custom curriculum"
          icon: "fa-edit"
        - title: "Project-based learning"
          icon: "fa-project-diagram"
        - title: "Career guidance"
          icon: "fa-route"
        - title: "Ongoing support"
          icon: "fa-infinity"
```

### Methodology Comparison

```yaml
- type: "symmetry"
  title: "Agile Framework Comparison"
  boxes:
    - title: "Scrum"
      content: "Most popular framework"
      items:
        - title: "Sprint-based delivery"
          icon: "fa-sync"
        - title: "Fixed team roles"
          icon: "fa-users-cog"
        - title: "Regular ceremonies"
          icon: "fa-calendar"
    - title: "Kanban"
      content: "Flow-based approach"
      items:
        - title: "Continuous delivery"
          icon: "fa-stream"
        - title: "Flexible roles"
          icon: "fa-random"
        - title: "Visual workflow"
          icon: "fa-columns"
        - title: "WIP limits"
          icon: "fa-stop-circle"
```

## Layout Structure

- **Container**: `.section-symmetry` main wrapper
- **Responsive**: `.table-responsive` for mobile horizontal scrolling
- **Table**: `.table.section-symmetry-table` Bootstrap table
- **Headers**: Styled column headers with titles and descriptions
- **Cells**: Symmetric cells with icons and content

## Styling

The section uses these CSS classes:

### Table Structure

- `.section-symmetry`: Main section container
- `.section-symmetry-table`: Table styling
- `.table-responsive`: Mobile scrolling wrapper

### Header Styles

- `.section-symmetry-header`: Base header styling
- `.section-symmetry-header-primary`: Primary column header
- `.section-symmetry-header-accent`: Accent column header
- `.section-symmetry-header-light`: Light column header

### Cell Styles

- `.section-symmetry-cell`: Base cell styling
- `.section-symmetry-cell-primary`: Primary column cells
- `.section-symmetry-cell-accent`: Accent column cells
- `.section-symmetry-cell-light`: Light column cells

## Best Practices

1. **Balanced Content**: Try to balance the number of items across columns
2. **Meaningful Icons**: Choose icons that represent the content clearly
3. **Consistent Language**: Use parallel phrasing across columns
4. **Clear Headers**: Make column titles distinctive and descriptive
5. **Progressive Enhancement**: Order columns from basic to advanced
6. **Mobile Consideration**: Test horizontal scrolling on mobile
7. **Icon Consistency**: Use similar icon styles throughout

## Responsive Behavior

- **Desktop**: Full table layout with all columns visible
- **Tablet**: Horizontal scrolling with maintained layout
- **Mobile**: Horizontal scrolling with touch-friendly scrolling

## Error Handling

The section gracefully handles:

- **Missing Items**: Shows empty cells with `&nbsp;`
- **Uneven Lists**: Aligns shorter lists to the top
- **Missing Icons**: Shows text without icons
- **Empty Boxes**: Creates empty columns

## Icon Guidelines

### Recommended Icon Sets

- **Checkmarks**: `fa-check`, `fa-check-circle`, `fa-check-square`
- **Features**: `fa-star`, `fa-crown`, `fa-gem`
- **Actions**: `fa-calendar`, `fa-users`, `fa-cogs`
- **Communication**: `fa-envelope`, `fa-phone`, `fa-comments`

### Icon Best Practices

- Use consistent icon styles (solid, regular, light)
- Choose icons that clearly represent the concept
- Avoid overly decorative icons that distract from content
- Test icons at small sizes for readability

## Common Use Cases

- **Service Comparisons**: Different service tiers or packages
- **Feature Matrices**: Product feature comparisons
- **Training Options**: Different learning approaches
- **Methodology Comparisons**: Framework or approach differences
- **Pricing Tables**: Service level pricing comparisons
- **Tool Evaluations**: Software or tool feature comparisons

The `symmetry` section provides a structured way to present comparative information in a clear, professional table format that works well for decision-making scenarios.
