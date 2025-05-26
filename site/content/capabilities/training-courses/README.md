# Course Syllabus Management

## Overview

Course syllabuses can be managed in two ways:

1. **Traditional Method**: Directly in the course's front matter using `syllabusBefore` and `syllabus` properties.
2. **External File Method**: In a separate `syllabus.yaml` file in the course directory.

The external file method is preferred for courses with extensive syllabus content as it keeps the front matter cleaner and easier to maintain.

## External File Method

To use the external file method:

1. Create a `syllabus.yaml` file in the same directory as your course's `_index.md` file.
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

3. Remove the `syllabusBefore` and `syllabus` sections from your course's front matter if they exist.

The system will automatically detect and use the external file if it exists. If no external file is found, it will fall back to using the front matter data.