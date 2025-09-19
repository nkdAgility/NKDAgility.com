# NKD Agility Documentation

Welcome to the NKD Agility documentation hub. This folder contains comprehensive guides for content creation, technical implementation, and system management for the NKDAgility.com website.

## 📝 Editorial & Content Guidelines

Start here for content creation standards and editorial practices:

### Core Editorial Resources

- **[Editorial Content Style Guide](editorial-content-style-guide.md)** - Complete style guide defining voice, tone, and writing standards for all content
- **[Syllabus System](syllabus-system.md)** - Standardised course syllabus management and structure guidelines

### Course Management Standards

NKD Agility follows strict standards for training course content:

- **Immersive format** with assignments between sessions
- External `syllabus.yaml` files for maintainability
- Standardised front matter fields (course_code, course_length, course_sessions, etc.)
- Outcome-focused assignment design

## 🏗️ Hugo Section Components

Technical documentation for Hugo page sections and components:

### Overview & Architecture

- **[Page Sections Overview](page-sections-overview.md)** - Comprehensive overview of all available page sections and their functionality

### Content Display Sections

- **[Cards Section](cards-section-usage.md)** - Dynamic card layouts with responsive columns
- **[List Section](list-section-usage.md)** - Styled lists with icons, titles, and content
- **[Text & List Section](textnlist-section-usage.md)** - Text content with accompanying lists
- **[Features Section](features-section-usage.md)** - Feature showcases with icons and descriptions

### Specialised Content Sections

- **[Courses Section](courses-section-usage.md)** - Training course display and filtering
- **[Videos Section](videos-section-usage.md)** - Video content display and embedding
- **[Quote Section](quote-section-usage.md)** - Large stylised quotes and testimonials
- **[Case Study Section](casestudy-section-usage.md)** - Client case study presentations

### Navigation & Interaction Sections

- **[Taxonomies Section](taxonomies-section-usage.md)** - Category and tag displays
- **[Taxonomies Card Section](taxonomies-card-section-usage.md)** - Card-based taxonomy displays
- **[Options Section](options-section-usage.md)** - Interactive option selections
- **[Section CTA](sectioncta-section-usage.md)** - Call-to-action components

### Data Display Sections

- **[Counters Section](counters-section-usage.md)** - Animated statistics and metrics
- **[Audiences Section](audiences-section-usage.md)** - Target audience displays
- **[Types Section](types-section-usage.md)** - Service/product type categorisation
- **[Phases Section](phases-section-usage.md)** - Process phase visualisation

### Outcome & Results Sections

- **[Outcome Hero Section](outcomehero-section-usage.md)** - Hero sections focused on outcomes
- **[Outcome Boxes Section](outcomeboxes-section-usage.md)** - Outcome highlight boxes

### Integration Sections

- **[Trustpilot Section](trustpilot-section-usage.md)** - Trustpilot review integration
- **[Other Pages Section](otherpages-section-usage.md)** - Related page recommendations

### UI Components

- **[Theme Switcher](theme-switcher-usage.md)** - Light/dark theme toggle functionality

## ⚙️ PowerShell Automation

Technical documentation for PowerShell scripts and automation:

### Content Processing & AI

- **[Embedding Repository](EmbeddingRepository.md)** - Vector embedding generation and synchronisation system for content analysis
- **[Generate and Store Embeddings](GenerateAndStoreEmbeddings.md)** - Individual content embedding generation process
- **[Related Repository](RelatedRepository.md)** - Related content recommendation system
- **[Update Resources Related Cache](Update-ResourcesRelatedCache.md)** - Cache management for related content features

### Data Analysis

- **[Classification Correlation Analysis](classification-correlation-analysis.md)** - Content classification and correlation analysis tools

## 🛠️ Technical Architecture

### Hugo Components Structure

```text
layouts/
├── partials/
│   ├── sections/
│   │   ├── section-router.html      # Central routing logic
│   │   ├── section-header.html      # Common headers
│   │   ├── section-wrapper.html     # Consistent styling
│   │   ├── sections.html           # Main entry point
│   │   └── sections-[type].html    # Individual section templates
│   └── ...
└── ...
```

### PowerShell Scripts Location

```text
.powershell/
├── EmbeddingRepository.ps1
├── GenerateAndStoreEmbeddings.ps1
├── RelatedRepository.ps1
├── Update-ResourcesRelatedCache.ps1
└── ...
```

### Generated Directories ⚠️

**Important**: These directories contain generated files and should **never be manually edited**:

#### `.resources/` Directory

- **Purpose**: Reference copies of content organized by type and year
- **Generated by**: PowerShell scripts in `.powershell/build/` including:
  - `Update-ResourcesFrontMatter.ps1` - Individual resource files by type/year
  - `Update-ClassificationFrontMatter.ps1` - Classification JSON files
- **Structure**: Organized by resource type (blog, videos, etc.) and year
- **Usage**: Reference and analysis only

#### `.data/` Directory

- **Purpose**: Generated data files for processing and analysis
- **Generated by**: Various PowerShell automation scripts
- **Content**: XML files, JSON files, processing artifacts
- **Usage**: Internal processing reference only

> **Edit Policy**: Always edit original files in `site/content/` - never the generated copies

## 📋 Quick Reference

### Content Creation Workflow

1. Review [Editorial Content Style Guide](editorial-content-style-guide.md) for voice and tone
2. For courses: Follow [Syllabus System](syllabus-system.md) standards
3. Use appropriate section components from the Hugo documentation
4. Validate content structure using available PowerShell tools

### Technical Implementation Workflow

1. Choose appropriate sections from [Page Sections Overview](page-sections-overview.md)
2. Implement using individual section documentation
3. Test with Hugo development server
4. Update embeddings and related content cache as needed

### Maintenance Tasks

- **Weekly**: Run embedding repository updates for new content
- **Monthly**: Analyse classification correlations for content optimisation
- **As needed**: Update related content caches for performance

---

_This documentation is maintained alongside the NKDAgility.com website and should be updated when new features or processes are added._
