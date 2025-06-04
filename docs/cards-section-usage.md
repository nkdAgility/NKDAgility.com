# Cards Section Usage

The `cards` section type creates a responsive card layout that automatically adjusts column widths based on the number of cards provided. This is perfect for showcasing services, features, or any grid-based content.

## Basic Structure

```yaml
sections:
  - type: "cards"
    title: "Our Services"
    content: "Explore our comprehensive range of services"
    cards:
      - title: "Agile Coaching"
        content: "Transform your team's agile practices with expert guidance and mentoring."
        button:
          content: "Learn More"
          link: "/services/agile-coaching"
      - title: "DevOps Consulting"
        content: "Streamline your development and deployment processes for faster delivery."
        button:
          content: "Get Started"
          link: "/services/devops-consulting"
      - title: "Training Programs"
        content: "Comprehensive training programs to upskill your entire organization."
        button:
          content: "View Courses"
          link: "/training-courses"
```

## Features

- **Responsive Layout**: Automatically adjusts to 2 or 3 columns based on card count
- **Dynamic Sizing**: Cards adapt to content length
- **Button Support**: Each card can have an optional call-to-action button
- **Rich Content**: Support for Markdown in all text fields
- **Consistent Styling**: Uses the site's card component for uniform appearance

## Parameters

### Required

- `type`: Must be "cards"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `cards`: Array of card objects
  - `title`: Card title (supports Markdown)
  - `content`: Card content/description (supports Markdown)
  - `button`: Optional button configuration
    - `content`: Button text
    - `link`: Button URL

## Layout Logic

The section automatically determines column layout:

- **3 Cards or Multiple of 3**: Uses 3-column layout (`col-xl-4`)
- **Even Number (2, 4, 6, etc.)**: Uses 2-column layout (`col-xl-6`)
- **Other Numbers**: Defaults to 3-column layout

## Examples

### Two-Column Layout

```yaml
- type: "cards"
  title: "Key Benefits"
  cards:
    - title: "Increased Velocity"
      content: "Deliver features **40% faster** with improved agile practices"
      button:
        content: "Learn How"
        link: "/outcomes/velocity"
    - title: "Better Quality"
      content: "Reduce bugs by **60%** through enhanced testing and CI/CD"
      button:
        content: "See Results"
        link: "/outcomes/quality"
```

### Three-Column Layout

```yaml
- type: "cards"
  title: "Training Options"
  content: "Choose the learning path that fits your needs"
  cards:
    - title: "Professional Scrum Master"
      content: "Master the fundamentals of Scrum and agile leadership"
      button:
        content: "Enroll Now"
        link: "/training-courses/professional-scrum-master"
    - title: "DevOps Foundation"
      content: "Learn essential DevOps practices and tooling"
      button:
        content: "Get Started"
        link: "/training-courses/devops-foundation"
    - title: "Agile Coaching"
      content: "Advanced techniques for coaching agile teams"
      button:
        content: "Register"
        link: "/training-courses/agile-coaching"
```

### Cards Without Buttons

```yaml
- type: "cards"
  title: "Why Choose Us"
  cards:
    - title: "20+ Years Experience"
      content: "Decades of experience in agile transformation and DevOps implementation"
    - title: "Proven Results"
      content: "Helped **500+** organizations achieve their agile and DevOps goals"
    - title: "Global Reach"
      content: "Supporting teams across **40+ countries** with local expertise"
```

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-xl-4` or `.col-xl-6`: Dynamic column classes
- `.p-2`: Padding for card spacing
- `.sectioncards`: Card component class

## Best Practices

1. **Consistent Card Count**: Use even numbers (2, 4, 6) for balanced layouts
2. **Similar Content Length**: Keep card content roughly the same length for visual harmony
3. **Clear CTAs**: Use action-oriented button text like "Learn More", "Get Started", "Explore"
4. **Meaningful Icons**: If using icons in content, choose relevant FontAwesome classes
5. **Mobile-First**: Remember cards stack vertically on mobile devices

## Fallback Behavior

If no cards are provided, the section displays: "No courses" (note: this appears to be legacy text that should be updated to "No cards available").
