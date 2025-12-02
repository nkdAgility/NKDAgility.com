````instructions
---
description: Guidelines for creating and editing outcome pages
applyTo: 'site/content/outcomes/**'
---

# Outcomes Content Guidelines

Outcomes are marketing pages that describe the business results and transformations NKD Agility delivers. These pages focus on the "what changes" rather than "how we do it."

## Page Structure Requirements

### Front Matter Standards

```yaml
title: "Outcome Name"
description: "SEO-optimized description (150-160 characters)"
preview: "Preview text for cards and listings"
headline:
  title: "H1 Headline - The outcome state"
  subtitle: "The contrast from current pain"
  content: "Brief description of the transformation"
  image: "/path/to/outcome-image.jpg"
  button:
    text: "Learn How"
    url: "/contact-path"
```

### Section-Based Content

Outcomes use a section-based architecture to present transformation narratives. Content must demonstrate the journey from pain to resolution.

## Section Types Reference

**For complete section type documentation, selection guidelines, and property validation rules, see:**
- **📋 Master Section Reference**: `.github/instructions/site-layout-_partials-sitesections.instructions.md`
- **📖 Individual Section Docs**: `docs/*-section-usage.md`

The master reference includes:
- Complete table of all section types with "When to Use" guidance
- Section selection decision tree
- Common mistakes and corrections
- Property validation rules
- Template implementation details

### Key Guidelines for Outcome Pages

**Every outcome page MUST start with ONE headline section:**
```yaml
headlines:
  - type: headline
    # headline parameters
```

**Critical Rules:**
- ✅ Present transformation narrative (pain → resolution)
- ✅ Use 6-10 different section types per page
- ✅ Focus on results, not methods ("what changes" not "how")
- ✅ Include proof elements (metrics, testimonials, case studies)
- ✅ Use `outcomehero` WITH boxes/CTA (that's what makes it special)
- ✅ Only ONE `headline` per page (H1 SEO rule)
- ❌ Don't use `content` for key messages (use `outcomehero` with boxes)
- ❌ Don't use `quote` for non-quotes (only for attributed quotations)
- ❌ Don't use generic statistics (counters must relate to this specific outcome)

## Outcome Page Patterns

### Standard Outcome Pattern

```yaml
headlines:
  - type: headline
    # Current pain vs. desired state

sections:
  - type: outcomehero
    # The core transformation with boxes showing pain points
    boxes:
      - content: "Pain point 1"
      - content: "Pain point 2"
      - content: "Pain point 3"
    cta:
      content: "Ready to transform?"
      button:
        text: "Book a Call"
        url: "/contact"

  - type: list
    title: "What Changes"
    listType: boxed
    list:
      - title: "From X to Y"
        content: "The specific transformation"

  - type: casestudy
    title: "Real Results"
    cases:
      - content: "Quantified achievement"
        icon: "fa-chart-line"

  - type: features
    title: "How This Outcome Manifests"
    features:
      - title: "Observable change 1"
        content: "What you'll see/experience"

  - type: textNlist
    title: "Why This Matters"
    sideContent: "The business impact"
    list:
      - content: "Specific benefit"

  - type: counters
    title: "The Numbers"
    counters:
      - count: 40
        suffix: "%"
        text: "Improvement in X"

  - type: sectioncta
    # Final call to action
```

## Content Writing Standards

### Tone & Voice for Outcomes
- **Outcome-focused language** - "You'll achieve X" not "We'll help you with Y"
- **Concrete and specific** - Quantify transformations where possible
- **Present the end state** - Describe the achieved outcome, not the journey
- **Buyer-centric** - Address what matters to decision-makers
- **Evidence-based** - Support claims with metrics or examples

### Outcome vs. Capability Distinction

| Outcomes Pages | Capabilities Pages |
|----------------|-------------------|
| **What** you'll achieve | **How** we deliver |
| Results and transformations | Services and methods |
| "You'll have X" | "We provide Y" |
| Business impact focus | Delivery approach focus |
| End state descriptions | Process and expertise |

### SEO Requirements
- **Title optimization**: Include outcome keyword, keep under 60 characters
- **Description optimization**: 150-160 characters, include result
- **H1 uniqueness**: Only ONE H1 per page (in headline section)
- **Header hierarchy**: Maintain proper H2 → H3 → H4 structure
- **Outcome keywords**: Use result-oriented language throughout

### Content Formatting
- **Short paragraphs**: 2-4 sentences maximum
- **Bullet points**: Use for lists of outcomes or changes
- **Bold for emphasis**: Highlight key transformations or metrics
- **Markdown support**: All content fields support standard Markdown
- **Quantification**: Include numbers and percentages where possible

## Linking Outcomes to Capabilities

Outcome pages should link to relevant capability pages that deliver these outcomes:

```yaml
sections:
  - type: otherpages
    title: "Services That Deliver This Outcome"
    related:
      - "/capabilities/devops-technology-consultancy/"
      - "/capabilities/agile-transformation/"
```

## Related Documentation

- **Section Implementation**: `.github/instructions/site-layout-_partials-sitesections.instructions.md`
- **Content Management**: `.github/instructions/content-management.instructions.md`
- **Capabilities Guidelines**: `.github/instructions/site-content-capabilities.instructions.md`
- **Section Usage Docs**: `docs/*-section-usage.md`

````
