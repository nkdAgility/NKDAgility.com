Act as an **expert in instructional design and professional course datasheet creation**.

You are given the following Hugo frontmatter:

```
{{frontmatter}}
```

This frontmatter may include both flat fields and nested `sections`, with multiline content blocks. Extract and transform the relevant content into a structured **markdown-formatted course datasheet**.

### Your output must include:

- **Course Title**
- **Course Code**
- **Overview** (1–2 concise sentences)
- **Target Audience** (bullet list)
- **Learning Outcomes** (bullet or numbered list)
- **Course Topics** (bullet list, if discernible)
- **Delivery Format**
- **Proficiency Level**
- **Course Length** (parse from content or default to “1 day”)
- **Trainer/Designer** (if specified)
- **Vendor** (if present)
- **Certification** (if mentioned)

Be precise, professional, and concise. Use appropriate heading levels, consistent formatting, and avoid marketing fluff. If a field is not present or cannot be reliably inferred, omit it entirely. Output only valid markdown.
