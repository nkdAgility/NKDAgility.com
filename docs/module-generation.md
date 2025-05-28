# Module Generation

This document explains how module pages are generated in the NKDAgility website.

## Overview

Module pages are dynamically generated at build time from `syllabus.yaml` files found in course directories. This is done using Hugo's Content Adapter feature, which allows Hugo to create pages during the build process without requiring static markdown files in the repository.

## Implementation

### Content Adapter

The system uses a content adapter template (`_content.gotmpl`) located at:

```
site/content/capabilities/training-courses/modules/_content.gotmpl
```

This template:
1. Finds all courses with syllabus.yaml files
2. Extracts module information from each syllabus file
3. Generates individual module pages with front matter and content
4. Creates them in the proper URL path

### Module Structure

Each generated module page includes:
- Complete module content and description
- Duration information
- Learning resources with links and time estimates
- Assignments with examples
- Navigation breadcrumbs back to parent course
- SEO-friendly metadata

## URL Structure

Module pages follow this URL pattern:
```
/capabilities/training-courses/modules/[course-slug]-module-[id]/
```

For example, for the Professional Scrum Master course Module 1:
```
/capabilities/training-courses/modules/scrumorg-professional-scrum-master-module-1/
```

## Benefits of Content Adapter Approach

Using Hugo's Content Adapter approach provides several advantages:

1. **Dynamic Generation:** Pages are created at build time, not stored as static files
2. **Single Source of Truth:** All module data comes from the syllabus.yaml files
3. **Automatic Updates:** When syllabus content changes, module pages update automatically
4. **Clean Repository:** No need to store and commit generated markdown files
5. **Improved Maintenance:** Changes to module formatting can be made in one place