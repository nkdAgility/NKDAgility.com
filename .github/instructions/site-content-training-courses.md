---
description: Course and syllabus management standards
applyTo: 'site/content/training-courses/**'
---

# Course Management

## Course Structure Standards

- All courses use the **immersive format** with assignments between sessions
- Course content uses external `syllabus.yaml` files for better maintainability
- Course information is stored in the course's front matter

## Required Course Front Matter Fields

```yaml
course_code: "PSM" # Unique course identifier (e.g., "APS", "PAL-E")
course_length: 16 # Total course duration in hours
course_sessions: 8 # Number of sessions (typically course_length / 2)
description: "Course description and learning objectives..."
delivery_audiences: # Target audience list
  - "Scrum Masters"
  - "Product Owners"
course_learning_experiences:
  - "Immersive" # Standard format for all courses
  - "Traditional" # Standard format for all courses
```

## Syllabus System

- **File Location**: `syllabus.yaml` in the course directory
- **Structure**: Sessions with assignments, learning resources, and reflection components
- **Assignment Design**: Outcome-focused rather than output-focused
- **Documentation**: See `docs/syllabus-system.md` for detailed guidance

## Issue Templates

Use `.github/ISSUE_TEMPLATE/update-syllabus.yml` for syllabus updates:

- Automatically extracts course info from front matter using course code
- Updates both syllabus.yaml and course front matter fields
- Validates assignment design against immersive format principles
