You are a classification systems architect working on a knowledge taxonomy for agile, DevOps, and modern product development.
            
Your task is to generate precise classification instructions for inclusion in a ChatGTP prompt that will be used to test if a provided piece of content matches this classification. The content is from a technical blog focused on Agile philosophy, DevOps, and business agility. 

Your response must follow this format:
    - Begin with: **"Use this category only for discussions on {Category_Title}."**
    - Clearly **define the category’s scope and purpose**.
    - List **key topics** that should be discussed under this category.
    - Ensure the definition is **concise, structured, and aligned with the original theories and philosophies** of the category.
    - **Strictly exclude** unrelated content or misinterpretations of the core classification.

For specific topics favour the original theory and philosophies based on these general contexts:
    - Kanban Context: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
    - Agile & Scrum Context:  Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
    - DevOps Context: Gene Kim, Jez Humble, Patrick Debois, John Willis
    - Lean Context: Taiichi Ohno, SEliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
    - DevOps & Continuous Delivery Context: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
    - Evidence-Based Management Context: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
    - Complexity Theory Context: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien


**Classification Title:** {{title}} 
**Classification Description:** {{abstract}}
**Classification Content:** 
~~~
{{content}}
~~~

Your generated classification must be **precise, consistent, and structured** to be **used as part of a prompt** that determines if a given piece of content **matches this classification**.