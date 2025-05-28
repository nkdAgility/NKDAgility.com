# Module Page Generation from Syllabus

This document describes how to automatically generate individual module pages from `syllabus.yaml` files in the NKDAgility website.

## Overview

The solution generates individual pages for each module defined in a course's `syllabus.yaml` file. Instead of having all modules displayed only within the course page, each module gets its own dedicated page with:

- Complete module content
- Learning resources 
- Assignments and examples
- Proper navigation and metadata

## Implementation

### Python Script: `generate_modules.py`

The main implementation is a Python script that:

1. Reads `syllabus.yaml` files from course directories
2. Extracts module information (title, content, resources, assignments)
3. Generates individual markdown files for each module
4. Places generated files in a separate `modules/` directory to avoid Hugo page bundle conflicts

### Hugo Templates

- **Module Layout**: `site/layouts/module/single.html` - Renders individual module pages
- **Learning Resources Partial**: `site/layouts/partials/modules/learning-resources.html` - Formats learning resources

### Hugo Configuration

- Added `module` permalink configuration in `site/hugo.yaml`
- Module pages use `type: "module"` and `layout: "module"`

## Usage

### Generate modules for a single course:

```bash
python3 generate_modules.py site/content/capabilities/training-courses/scrumorg-professional-scrum-master
```

### Generate modules for all courses with syllabus files:

```bash
find site/content/capabilities/training-courses -name "syllabus.yaml" | 
while read syllabus; do 
    python3 generate_modules.py "$(dirname "$syllabus")"
done
```

## Generated Pages Structure

Module pages are created in:
```
site/content/capabilities/training-courses/modules/
├── [course-slug]-module-1.md
├── [course-slug]-module-2.md
└── ...
```

URLs are generated as:
```
/capabilities/training-courses/modules/[course-slug]-module-[id]/
```

## Features

- **Complete Module Content**: Full text, duration, and metadata
- **Learning Resources**: Formatted list with links and durations
- **Assignments**: Title, description, and examples
- **Course Navigation**: Breadcrumbs and links back to parent course
- **SEO-Friendly**: Proper titles, descriptions, and structured data

## Why This Approach?

1. **Hugo Page Bundle Limitation**: Course directories with custom URL patterns (like `url: /path/:slug/`) are treated as page bundles, preventing other markdown files in the same directory from being processed as individual pages.

2. **Separation of Concerns**: Module pages are logically separate from course pages and deserve their own URLs and navigation.

3. **Content Reuse**: Modules can be referenced and linked independently of their parent course.

## Alternative Approaches Considered

1. **Hugo Content Templates (`_content.gotmpl`)**: Not supported in the current Hugo version or didn't work as expected.
2. **Nested Directories**: Hugo page bundle behavior prevented recognition of nested content.
3. **Same Directory Placement**: Conflicted with course page bundle structure.

## Future Enhancements

- Automated module generation on content updates
- Cross-module navigation
- Module completion tracking
- Module-specific taxonomies