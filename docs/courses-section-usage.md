# Courses Section Usage

The `courses` section type displays a grid of course cards by referencing existing course pages in your site. This is perfect for showcasing training offerings, related courses, or educational content.

## Basic Structure

```yaml
sections:
  - type: "courses"
    title: "Featured Training Courses"
    content: "Enhance your skills with our comprehensive training programs"
    related:
      - "/training-courses/professional-scrum-master"
      - "/training-courses/devops-foundation"
      - "/training-courses/agile-coaching-certification"
```

## Features

- **Dynamic Course Cards**: Automatically generates course cards from existing pages
- **Responsive Grid**: Uses 3-column layout on desktop, stacks on mobile
- **Content Integration**: Pulls course information from the referenced pages
- **Error Handling**: Shows helpful messages when courses aren't found
- **Consistent Styling**: Uses the site's course card component

## Parameters

### Required

- `type`: Must be "courses"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `related`: Array of course page paths
  - Each path should reference an existing course page in your site
  - Paths should be relative to the site root (e.g., `/training-courses/course-name`)

## Course Page Requirements

The referenced course pages should be properly structured course content with:

- Valid front matter configuration
- Course-specific parameters (title, description, duration, etc.)
- Proper course card display parameters

## Examples

### Training Program Showcase

```yaml
- type: "courses"
  title: "Professional Development Programs"
  content: "Advance your career with our industry-recognized certifications"
  related:
    - "/training-courses/professional-scrum-master"
    - "/training-courses/professional-scrum-product-owner"
    - "/training-courses/professional-scrum-developer"
```

### Specialized Training Track

```yaml
- type: "courses"
  title: "DevOps Learning Path"
  content: "Master DevOps practices with our comprehensive curriculum"
  related:
    - "/training-courses/devops-foundation"
    - "/training-courses/continuous-integration-delivery"
    - "/training-courses/infrastructure-as-code"
    - "/training-courses/monitoring-observability"
```

### Related Courses (for course pages)

```yaml
- type: "courses"
  title: "You Might Also Like"
  content: "Continue your learning journey with these related courses"
  related:
    - "/training-courses/advanced-scrum-master"
    - "/training-courses/scaling-agile"
    - "/training-courses/agile-leadership"
```

### Simple Course List

```yaml
- type: "courses"
  title: "Available Courses"
  related:
    - "/training-courses/getting-started-with-scrum"
    - "/training-courses/kanban-fundamentals"
```

## Layout Structure

- **3-Column Grid**: `col-lg-4` for desktop display
- **Responsive**: `col-sm-12 col-md-12` ensures proper mobile stacking
- **Consistent Spacing**: `p-2` padding around each course card

## Course Card Integration

The section uses the `cards-course.html` partial, which should display:

- Course title
- Course description
- Duration/timing information
- Enrollment or "Learn More" buttons
- Course difficulty level (if available)
- Instructor information (if available)

## Error Handling

When a course path cannot be found:

- Displays: "Course `{path}` not found."
- Helps with debugging broken references
- Continues rendering other valid courses

## Fallback Behavior

If no courses are provided in the `related` array:

- Displays: "No courses"
- Section remains visible but indicates empty state

## Best Practices

1. **Valid Paths**: Ensure all course paths exist and are properly formatted
2. **Logical Grouping**: Group related or sequential courses together
3. **Reasonable Quantity**: 3-6 courses per section work best visually
4. **Course Quality**: Only reference completed, published course pages
5. **Regular Maintenance**: Verify course links when content is updated or moved

## Path Format Examples

### Correct Path Formats

```yaml
related:
  - "/training-courses/professional-scrum-master"
  - "/learning/devops-fundamentals"
  - "/certifications/agile-coach"
```

### Incorrect Path Formats

```yaml
related:
  - "professional-scrum-master" # Missing leading slash
  - "/training-courses/professional-scrum-master/" # Trailing slash may cause issues
  - "training-courses/professional-scrum-master" # Missing leading slash
```

## Integration with Hugo

The section leverages Hugo's `$site.GetPage` function to:

- Retrieve page objects from the provided paths
- Access page parameters and content
- Generate appropriate course card displays

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-lg-4.col-sm-12.col-md-12`: Responsive column classes
- `.p-2`: Padding for card spacing
- Course card specific styles from `cards-course.html` partial

## Mobile Responsiveness

- **Desktop**: 3-column grid layout
- **Tablet**: Maintains responsive behavior
- **Mobile**: Single column stack for optimal viewing

This section is ideal for course catalogs, training program pages, and educational content hubs.
