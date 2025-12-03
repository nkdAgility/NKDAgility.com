````instructions
---
description: Guidelines for creating and editing capability pages
applyTo: 'site/content/capabilities/**'
---

# Capabilities Content Guidelines

Capabilities are marketing pages that showcase NKD Agility's service offerings and training courses. These pages must balance marketing impact with SEO optimization.

## Page Structure Requirements

### Front Matter Standards

```yaml
title: "Capability Name"
description: "SEO-optimized description (150-160 characters)"
preview: "Preview text for cards and listings"
headline:
  title: "H1 Headline (unique, keyword-rich)"
  subtitle: "Supporting subtitle"
  content: "Brief intro paragraph"
  image: "/path/to/hero-image.jpg"
  button:
    text: "Primary CTA"
    url: "/contact-path"
```

### Section-Based Content

Capabilities use a section-based architecture for visual variety and conversion optimization. Content must be broken into 6-10 distinct section types per page.

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

### Key Guidelines for Capability Pages

**Every capability page MUST start with ONE headline section:**
```yaml
headlines:
  - type: headline
    # headline parameters
```

**Critical Rules:**
- ✅ Use 6-10 different section types per page for visual variety
- ✅ Keep sections short (2-4 paragraphs maximum)
- ✅ Focus on buyer outcomes, not methodology
- ✅ Only ONE `headline` per page (H1 SEO rule)
- ❌ Don't use `content` on marketing pages (use `outcomehero` or `list` instead)
- ❌ Don't use `quote` for non-quotes (use `outcomehero` for key messages)
- ❌ Don't repeat the same section type multiple times

## Content Writing Standards

### Tone & Voice
- **Direct and outcome-focused** - state what changes, not how
- **Buyer-centric** - address pain points and desired states
- **Confident without hype** - avoid marketing fluff
- **Professional but conversational** - write like a trusted advisor

### SEO Requirements
- **Title optimization**: Include primary keyword, keep under 60 characters
- **Description optimization**: 150-160 characters, include call-to-action
- **H1 uniqueness**: Only ONE H1 per page (in headline section)
- **Header hierarchy**: Maintain proper H2 → H3 → H4 structure in section titles
- **Keyword density**: Natural integration, avoid stuffing

### Content Formatting
- **Short paragraphs**: 2-4 sentences maximum
- **Bullet points**: Use for lists of 3+ items
- **Bold for emphasis**: Highlight key outcomes or constraints removed
- **Markdown support**: All content fields support standard Markdown

## Capability Types

### Service Capabilities
Pages describing consulting services, implementations, or ongoing support offerings.

**Examples:**
- DevOps Technology Consultancy
- Operating Model Design
- Agile Transformation

**Section Pattern:**
1. `headline` - Service positioning
2. `outcomehero` - Key outcome/transformation
3. `features` - Capabilities or constraints removed
4. `casestudy` - Results and metrics
5. `textNlist` - Approach or methodology
6. `audiences` - Who this is for
7. `phases` - Engagement process
8. `sectioncta` - Book a call

### Training Course Capabilities
Pages describing course offerings and learning experiences.

**Examples:**
- Scrum.org Course Pages
- Custom Training Programs

**Section Pattern:**
1. `headline` - Course positioning
2. `outcomehero` - Learning outcome
3. `features` - Skills gained or problems solved
4. `textNlist` - Why this approach works
5. `counters` - Course statistics
6. `audiences` - Who should attend
7. `otherpages` - Related courses
8. `sectioncta` - View schedule / Enrol

## Related Documentation

- **Section Implementation**: `.github/instructions/site-layout-_partials-sitesections.instructions.md`
- **Content Management**: `.github/instructions/content-management.instructions.md`
- **Training Courses**: `.github/instructions/site-content-training-courses.instructions.md`
- **Section Usage Docs**: `docs/*-section-usage.md`

````
