---
title: Syllabus System Documentation
description: A detailed guide on how the course syllabus management system works at NKD Agility
date: 2023-05-26
weight: 100
---

# Course Syllabus System

## Overview

NKD Agility's syllabus system provides a flexible way to manage course content structures for training courses. This system allows course creators to define the syllabus content either directly in the course's front matter or in a separate YAML file for better maintainability.

## Implementation Methods

There are two ways to implement a syllabus for a course:

1. **Traditional Method**: Define syllabus directly in the course's front matter
2. **External File Method**: Define syllabus in a separate `syllabus.yaml` file in the course directory

The external file method is recommended for courses with extensive syllabus content as it keeps the front matter cleaner and more maintainable.

## Syllabus Structure

A syllabus consists of two main components:

### 1. `syllabusBefore` (Optional)

Contains preliminary content items that should be displayed before the main syllabus, such as preparation materials or introductory content. Each item typically includes:

- `title`: Name of the content
- `link`: URL or path to the content
- `duration`: Time required in minutes
- `type`: Type of content (page, video, etc.)
- `weight`: Order priority (lower numbers appear first)

### 2. `syllabus`

The main syllabus content organized as modules or sessions. Each module includes:

- `id`: Unique identifier for the module (usually numeric)
- `title`: Name of the module or session
- `duration`: Time required in minutes
- `content`: Description of the module content (supports Markdown formatting)
- `learningResources`: (Optional) Additional learning materials
  - `title`: Name of the resource
  - `link`: URL or path to the resource
  - `duration`: Time required in minutes
  - `type`: Type of resource (guide, video, blog, etc.)
  - `weight`: Order priority
- `assignment`: (Optional) Follow-up assignment related to the module
  - `title`: Assignment title
  - `content`: Assignment description (supports Markdown formatting)
  - `examples`: Examples or suggestions for completing the assignment (supports Markdown formatting)

## External File Method

To use the external file method:

1. Create a `syllabus.yaml` file in the same directory as your course's `index.md` file.
2. Structure the file as follows:

```yaml
syllabusBefore:
- title: "Preparation"
  link: "./preparation/"
  duration: 15
  type: page
  weight: 1

syllabus:
- id: 1
  title: "Module Title"
  duration: 60
  content: "Module description goes here."
  learningResources:
  - title: "Resource Title"
    link: "https://example.com"
    duration: 10
    type: guide
    weight: 1
  assignment:
    title: "Assignment Title"
    content: "Assignment content goes here."
    examples: "Assignment examples go here."
```

3. Remove any `syllabusBefore` and `syllabus` sections from your course's front matter if they exist.

## File Detection Logic

The system automatically detects whether to use an external syllabus file or the front matter data:

1. It first checks if a `syllabus.yaml` file exists in the course directory.
2. If the file exists, it reads and uses that data.
3. If the file doesn't exist, it falls back to using the front matter data.

## Content Types

The `type` attribute can have various values to indicate different content types:

- `page`: Regular web page content
- `video`: Video content
- `guide`: Instructional guide
- `blog`: Blog post
- `newspaper`: News article
- `learning`: General learning resource
- `handshake-angle`: Interactive or hands-on content
- Any [Font Awesome icon name](https://fontawesome.com/icons) can be used

## Usage in Templates

To use the syllabus data in templates, use the `get-syllabus-data.html` partial:

```html
{{/* Get syllabus data from file or front matter */}}
{{- $syllabusData := partial "functions/get-syllabus-data.html" .Page }}
{{- $syllabusBefore := index $syllabusData "syllabusBefore" }}
{{- $syllabus := index $syllabusData "syllabus" }}
```

## Example Implementation

The Applying Professional Scrum (APS) course uses the external file method. You can find its syllabus in:

`site/content/capabilities/training-courses/scrumorg-applying-professional-scrum/syllabus.yaml`

This file contains a comprehensive syllabus with multiple modules, learning resources, and assignments.

## Best Practices

1. **Use External Files for Complex Syllabi**: If your syllabus contains multiple modules with detailed resources and assignments, use the external file method.
2. **Maintain Consistent Structure**: Keep the structure consistent across all courses for better maintenance.
3. **Use Markdown Formatting**: Take advantage of Markdown formatting in content and description fields.
4. **Set Realistic Durations**: Provide accurate time estimates for modules and resources.
5. **Organize with Weights**: Use the weight property to control the display order of items.
6. **Provide Comprehensive Descriptions**: Write clear and informative descriptions for each module.
7. **Include Practical Assignments**: Where applicable, include practical assignments to enhance the learning experience.