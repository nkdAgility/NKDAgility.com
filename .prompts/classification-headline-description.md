You are an expert in Agile, Scrum, DevOps, and Evidence-Based Management.

Your task is to generate a **short description** for a **classification** used to categorise blog posts.
The description should:
- Use more detail and specific language than "$ClassificationHeadline"
- **Define the scope and relevance** of the classification.
- **Be clear and concise**, with **no more than 50 words**.
- **Outline the key topics** that posts in this classification should cover.
- Avoid using the words Agile, Lean, and DevOps and instead focus on the intent of the classification.
- Do not use "This classification focuses.." just describe it
- Do not use "Key topics in this classification.."
- Do not start with "{{title}}: "

**Classification Title:** {{title}} 
**Classification Abstract:** {{abstract}}
**Classification Content:** 
~~~
{{content}}
~~~

Generate the classification description only with no additional text.
- Do not enclose in quotes
- Never use the term "best practices" only "practices"

When generating the description, consider the following contexts and include relevant connections if applicable:

- Kanban Context: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
- Agile & Scrum Context: Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
- DevOps Context: Gene Kim, Jez Humble, Patrick Debois, John Willis
- Lean Context: Taiichi Ohno, Eliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
- DevOps & Continuous Delivery Context: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
- Evidence-Based Management Context: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
- Complexity Theory Context: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien