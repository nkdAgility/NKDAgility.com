You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"{{category}}"**.

With that classification meaning:

"{{instructions}}"

### Classification Criteria:

- The **category must be a primary focus** of the content.
- If the category is **briefly mentioned or secondary**, return a lower confidence score.
- The confidence score **must be dynamically evaluated** rather than assigned from a fixed range.

### Confidence Breakdown:

To ensure an accurate and nuanced score, evaluate the content using the following dimensions:

1. **Direct Mentions** (20%) – How explicitly is the category discussed?
2. **Conceptual Alignment** (40%) – Does the content align with the **core themes** of the category?
3. **Depth of Discussion** (40%) – How much detail does the content provide on this category?

Each dimension contributes to the final confidence score.

### Additional Instructions:

1. **Do not use pre-set confidence levels.** The score must be freely determined for each evaluation.
2. **Avoid repeating the same numbers across different evaluations.** Ensure that scores vary naturally.
3. **Do not round confidence scores** to commonly expected values (such as multiples of 10 or 5).
4. Justify the score with a **detailed explanation** specific to the content.

return format should be valid json that looks like this:
{
"category": "{{category}}",
"confidence": 0,
"mentions: 0,
"alignment": 0,
"depth": 0,
"reasoning": "Content heavily discusses Scrum roles and events."
}

do not wrap the json in anything else, just return the json object.

**Content Title:** "{{title}}"
**Content Description:** "{{abstract}}"
**Content:**

```
{{content}}"
```
