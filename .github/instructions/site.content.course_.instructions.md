---
applyTo: "site/content/course_**/**"
---

# NKDAgility Courses & Syllabus Guide (scope: `site/content/course_*` taxonomy areas)

## 1. Purpose

Standardizes course metadata & syllabus management for immersive & traditional formats.

## 2. Key Directories

`site/content/course_topics/`, `course_vendors/`, `course_learning_experiences/`, `course_proficiencies/` (taxonomies supporting course classification). Actual course pages may live under topic subfolders (e.g., scrum, product, kanban).

## 3. Required Course Front Matter (Single Source)

```yaml
course_code: "PSM" # Unique code (prefer existing naming pattern)
course_length: 16 # Total hours
course_sessions: 8 # Usually length/2
description: "..." # Learning objective oriented
delivery_audiences:
  - Scrum Masters
  - Product Owners
course_learning_experiences:
  - Immersive
  - Traditional
```

Add additional taxonomies (topics, vendors, proficiencies) where relevant.

## 4. Syllabus Files

- File: `syllabus.yaml` adjacent to the course page or directory.
- Contains ordered sessions with: title, goal (outcome-focused), activities, assignment (outcome-based), reflection prompts.
- Maintain consistent session numbering; avoid output-focused assignments.

## 5. Editing a Syllabus

1. Open `syllabus.yaml`.
2. Modify session blocks (retain keys; avoid reordering unless versioning rationale).
3. Validate assignments state outcomes ("Participants will be able to…").
4. Commit with message: `chore(course): update syllabus <course_code>`.

## 6. Issue Template Workflow

Use `.github/ISSUE_TEMPLATE/update-syllabus.yml`:

- Extracts existing front matter by course code.
- Syncs front matter & syllabus.yaml.
- Validates immersive format principles (sessions + assignments + reflections).

## 7. Adding a New Course

1. Choose `course_code` (check for collisions).
2. Create markdown file under relevant topic taxonomy path.
3. Add required front matter block.
4. Create `syllabus.yaml` with baseline sessions (at least 1) even if draft.
5. Add taxonomies (topics, vendors, proficiencies, learning_experiences).
6. Run local Hugo build & verify rendering.

## 8. Quality Checklist

- All required front matter present.
- Syllabus session goals outcome-oriented.
- Assignments measurable & not prescriptive busywork.
- Taxonomies align with existing casing & pluralization.
- No duplicate course_code.

## 9. Common Pitfalls

| Problem                   | Cause                      | Fix                                           |
| ------------------------- | -------------------------- | --------------------------------------------- |
| Missing sessions          | Empty or mis-indented YAML | Correct indentation; add at least one session |
| Output-focused assignment | Task phrasing              | Rephrase to outcome (ability/result)          |
| Course not listed         | Missing taxonomy linkage   | Add topic/vendor taxonomies                   |
| Syllabus ignored          | Wrong filename             | Ensure `syllabus.yaml` lower-case             |
| Duplicate course_code     | Reuse of ID                | Pick unique code, update references           |

## 10. Principles

- Outcome over output.
- Minimal viable syllabus first; iterate.
- Consistent taxonomy usage.
- One authoritative syllabus per course directory.
- Reference guide first before structural changes.
