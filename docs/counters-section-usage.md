# Counters Section Usage

The `counters` section type displays statistics, metrics, or key numbers in an eye-catching horizontal layout. Perfect for showcasing achievements, statistics, or key performance indicators.

## Basic Structure

```yaml
sections:
  - type: "counters"
    title: "Our Impact"
    content: "See the results we've delivered for our clients"
    counters:
      - counter: "500"
        counterAfter: "+"
        content: "**Organizations Transformed**"
      - counter: "40"
        counterAfter: "%"
        content: "**Average Velocity Increase**"
      - counter: "20"
        counterAfter: ""
        content: "**Years of Experience**"
      - counter: "95"
        counterAfter: "%"
        content: "**Client Satisfaction Rate**"
```

## Features

- **Dynamic Column Layout**: Automatically adjusts column width based on number of counters
- **Responsive Font Sizing**: Font sizes scale based on column width using CSS clamp()
- **Flexible Counter Format**: Supports numbers with optional suffixes
- **Rich Content**: Support for Markdown in counter descriptions
- **Modern Typography**: Uses `.text-modern` class for contemporary styling
- **Centered Layout**: All content is center-aligned for visual impact

## Parameters

### Required

- `type`: Must be "counters"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `counters`: Array of counter objects
  - `counter`: The main number/statistic
  - `counterAfter`: Optional suffix (%, +, K, M, etc.)
  - `content`: Description of the counter (supports Markdown)

## Layout Logic

The section automatically calculates column widths:

- **Column Width**: `12 / number of counters` (Bootstrap grid system)
- **Minimum Width**: Never smaller than 2 columns (`col-2`)
- **Font Scaling**: Larger numbers for fewer counters, smaller for more counters

### Font Size Calculation

- **Heading Size**: `clamp(1.4rem, {colSize}.5vw, 4rem)`
- **Description Size**: `clamp(1.0rem, {colSize}.5vw, 2rem)`

This ensures counters remain readable across all device sizes.

## Examples

### Business Metrics

```yaml
- type: "counters"
  title: "Proven Results"
  content: "Numbers that demonstrate our effectiveness"
  counters:
    - counter: "50"
      counterAfter: "%"
      content: "**Faster Time to Market**"
    - counter: "2M"
      counterAfter: "$"
      content: "**Average Cost Savings**"
    - counter: "99.9"
      counterAfter: "%"
      content: "**System Uptime**"
```

### Team Statistics

```yaml
- type: "counters"
  title: "Team Performance"
  counters:
    - counter: "300"
      counterAfter: "+"
      content: "**Teams Coached**"
    - counter: "15"
      counterAfter: ""
      content: "**Countries Served**"
    - counter: "85"
      counterAfter: "%"
      content: "**Retention Rate**"
    - counter: "24"
      counterAfter: "/7"
      content: "**Support Available**"
```

### Training Impact

```yaml
- type: "counters"
  title: "Training Excellence"
  content: "Our training programs deliver measurable results"
  counters:
    - counter: "10K"
      counterAfter: "+"
      content: "**Professionals Trained**"
    - counter: "4.9"
      counterAfter: "/5"
      content: "**Average Rating**"
    - counter: "95"
      counterAfter: "%"
      content: "**Certification Pass Rate**"
```

### Simple Two-Counter Layout

```yaml
- type: "counters"
  title: "Core Stats"
  counters:
    - counter: "20"
      counterAfter: ""
      content: "**Years Experience**"
    - counter: "1000"
      counterAfter: "+"
      content: "**Successful Projects**"
```

## Common Counter Formats

### Percentages

```yaml
counter: "95"
counterAfter: "%"
```

### Large Numbers with Suffixes

```yaml
counter: "2.5"
counterAfter: "M"  # Million
# or
counter: "500"
counterAfter: "K"  # Thousand
```

### Plus Indicators

```yaml
counter: "100"
counterAfter: "+" # 100+
```

### Ratios

```yaml
counter: "4.9"
counterAfter: "/5" # 4.9/5
```

### Currency

```yaml
counter: "$2"
counterAfter: "M" # $2M
```

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-{size}`: Dynamic column sizing
- `.text-modern`: Modern typography styling
- `.text-center`: Center alignment for all content

## Responsive Behavior

- **Desktop**: Horizontal layout with all counters in one row
- **Tablet**: May wrap if many counters are present
- **Mobile**: Counters stack vertically but maintain center alignment

Font sizes automatically scale down on smaller screens using CSS clamp() for optimal readability.

## Best Practices

1. **Meaningful Numbers**: Use significant, impressive statistics
2. **Consistent Formatting**: Keep counter formats similar within a section
3. **Bold Descriptions**: Use **bold** text to emphasize key words
4. **Reasonable Quantity**: 2-6 counters work best for visual impact
5. **Accurate Data**: Ensure all statistics are current and verifiable
6. **Clear Context**: Make sure the counter descriptions clearly explain what the numbers represent

## Fallback Behavior

If no counters are provided, the section displays: "No counters available".

## Accessibility

- All counter values are presented as text content, making them screen reader accessible
- Font sizes remain readable across all device sizes
- High contrast maintained with centered, bold typography
