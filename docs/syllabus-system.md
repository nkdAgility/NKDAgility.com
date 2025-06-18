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

The main syllabus content organized as modules or sessions. Each session includes:

- `id`: Unique identifier for the session (usually numeric)
- `title`: Name of the session
- `duration`: Time required in minutes
- `content`: Description of the session content (supports Markdown formatting)
- `learningResources`: (Optional) Additional learning materials
  - `title`: Name of the resource
  - `link`: URL or path to the resource
  - `duration`: Time required in minutes
  - `type`: Type of resource (guide, video, blog, etc.)
  - `weight`: Order priority
- `assignment`: (Optional) Follow-up assignment related to the session
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
    title: "Session Title"
    duration: 60
    content: "Session description goes here."
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
{{/* Get syllabus data from file or front matter */}} {{- $syllabusData := partial "functions/get-syllabus-data.html" .Page }} {{- $syllabusBefore := index $syllabusData "syllabusBefore" }} {{- $syllabus := index $syllabusData "syllabus" }}
```

## Example Implementation

The Applying Professional Scrum (APS) course uses the external file method. You can find its syllabus in:

`site/content/capabilities/training-courses/scrumorg-applying-professional-scrum/syllabus.yaml`

This file contains a comprehensive syllabus with multiple sessions, learning resources, and assignments.

## Best Practices

1. **Use External Files for Complex Syllabi**: If your syllabus contains multiple sessions with detailed resources and assignments, use the external file method.
2. **Maintain Consistent Structure**: Keep the structure consistent across all courses for better maintenance.
3. **Use Markdown Formatting**: Take advantage of Markdown formatting in content and description fields.
4. **Set Realistic Durations**: Provide accurate time estimates for sessions and resources.
5. **Organize with Weights**: Use the weight property to control the display order of items.
6. **Provide Comprehensive Descriptions**: Write clear and informative descriptions for each session.
7. **Include Practical Assignments**: Where applicable, include practical assignments to enhance the learning experience.

## Immersive Format Training Structure

NKD Agility's training courses follow an immersive format designed to maximize learning retention and practical application. This format consists of structured sessions and targeted assignments that build upon each other throughout the course duration.

### Session Structure

Each session (except the first) follows a consistent 4-hour format comprising:

- **~2 hours of Facilitated Reflections** - Time for students and their Professional Scrum Trainer to reflect on assignment experiences
- **~2 hours of Learning Module Content** - New concept instruction and practice
- **Assignment** - Practical application tasks to be completed between sessions

### Course Duration Mapping

The immersive format maps course hours to sessions as follows:

- **8-hour course** = 4 sessions (typically delivered over 4 weeks)
- **16-hour course** = 8 sessions (typically delivered over 8 weeks)
- **Custom courses** may have exceptions based on specific learning objectives

### Session Components

#### Facilitated Reflections

Every classroom session following the first one commences with dedicated time for students and their Professional Scrum Trainer to reflect on their experiences with the assignments. These reflections are integral to the learning process and provide a platform for students to:

- Share challenges and successes from assignments
- Ask for help and guidance
- Engage in constructive group discussions
- Foster peer learning through shared experiences
- Receive actionable feedback from both trainer and peers

Reflections focus on sharing the journey and nurturing growth through collective insights rather than evaluation or assessment.

#### Learning Module

Each 2-hour learning module within a session covers new concepts and practical applications. Immersion Training classes are delivered in short, live classroom sessions over several weeks, allowing students to:

- Focus on and internalize learning at a sustainable pace
- Gain thorough understanding of each concept before progressing
- Participate in manageable learning chunks
- Maintain engagement in a conducive learning environment

Each classroom session is designed to last no longer than 4 hours total to optimize learning effectiveness.

#### Assignments

**The heart of Immersion Training lies in the assignments.** Tied to each classroom session, students receive assignments that directly apply the concepts and learning objectives covered in that session.

##### Assignment Design Principles

**Outcome-Focused, Not Output-Focused**: Assignments are intentionally flexible, focusing on achieving specific learning outcomes rather than prescriptive outputs. This approach:

- Accommodates diverse participant backgrounds and proficiency levels
- Allows for creative problem-solving and innovation
- Enables real-world application in various contexts
- Encourages critical thinking over rote completion

**Challenging and Aspirational**: While assignments are designed to push boundaries and encourage experimentation with new approaches, the emphasis is not solely on completion. Instead, the focus is on:

- Pushing personal and professional boundaries
- Experimenting with new approaches and methodologies
- Learning through guided exploration and support
- Ensuring meaningful engagement for both novice and experienced learners

**Context-Relevant**: Assignments are designed to be applied within participants' actual work environments, making learning immediately practical and valuable.

##### What Should Go in Assignments

When creating assignments for your syllabus, include the following elements:

###### 1. Clear Learning Objective Connection

- Directly tie the assignment to the session's learning objectives
- Explain how the assignment reinforces or extends the concepts covered
- Connect to overall course goals and competencies

###### 2. Flexible Implementation Guidelines

- Provide the desired outcome or goal
- Offer multiple pathways to achieve the objective
- Allow for adaptation to different organizational contexts
- Include scalability options for teams of different sizes

###### 3. Real-World Application Focus

- Encourage application within actual work environments
- Connect to current projects or challenges when possible
- Promote practical experimentation over theoretical exercises
- Enable immediate value creation in professional contexts

###### 4. Reflection Prompts

- Include questions that guide meaningful reflection
- Encourage analysis of what worked, what didn't, and why
- Prompt consideration of how to adapt approaches for future use
- Foster preparation for next session's facilitated reflection

###### 5. Support Resources

- Provide optional additional resources for deeper exploration
- Include examples or case studies for inspiration (not copying)
- Offer troubleshooting guidance for common challenges
- Reference relevant frameworks, tools, or methodologies

###### 6. Collaboration Elements

- Encourage peer consultation and learning
- Suggest ways to involve team members or stakeholders
- Promote community engagement and knowledge sharing
- Foster network building within the learning cohort

##### Assignment Examples Structure

When including examples in your assignment section, focus on:

- **Inspiration, not prescription**: Provide examples that spark ideas rather than templates to copy
- **Diverse contexts**: Show how the assignment might be approached in different industries or team structures
- **Varying complexity levels**: Include options for different experience levels and organizational maturity
- **Outcome variations**: Demonstrate different valid approaches to achieving the learning objectives
