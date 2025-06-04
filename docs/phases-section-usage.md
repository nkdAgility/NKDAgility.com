# Phases Section Usage

The `phases` section type displays course or project phases in a sequential format. This is perfect for showcasing course syllabi, project timelines, or step-by-step processes.

## Basic Structure

```yaml
sections:
  - type: "phases"
    title: "Course Syllabus"
    content: "What you'll learn in this comprehensive training program"
    sylabus:
      - title: "Phase 1: Foundations"
        content: |
          - Introduction to Agile principles
          - Understanding the Scrum framework
          - Roles and responsibilities overview
          - Setting up your first Scrum team
      - title: "Phase 2: Implementation"
        content: |
          - Sprint planning techniques
          - Daily Scrum best practices
          - Sprint review and retrospective facilitation
          - Managing the product backlog
      - title: "Phase 3: Advanced Practices"
        content: |
          - Scaling Scrum across multiple teams
          - Advanced facilitation techniques
          - Metrics and measurement
          - Continuous improvement strategies
```

## Features

- **Sequential Display**: Shows phases in order from top to bottom
- **Rich Content**: Full Markdown support in both titles and content
- **Flexible Structure**: Can be used for courses, projects, or any sequential process
- **Simple Layout**: Clean, single-column format for easy reading
- **Consistent Spacing**: Proper padding and typography for readability

## Parameters

### Required

- `type`: Must be "phases"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `sylabus`: Array of phase objects (note: parameter name is "sylabus", not "syllabus")
  - `title`: Phase title
  - `content`: Phase description and details (supports Markdown)

## Examples

### Course Syllabus

```yaml
- type: "phases"
  title: "Professional Scrum Master Training"
  content: "A comprehensive 2-day course covering all aspects of Scrum mastery"
  sylabus:
    - title: "Day 1 Morning: Scrum Foundations"
      content: |
        **Learning Objectives:**
        - Understand Agile values and principles
        - Learn the Scrum framework components
        - Explore the Scrum Master role and responsibilities

        **Activities:**
        - Interactive Scrum simulation
        - Role-playing exercises
        - Group discussions on real-world challenges
    - title: "Day 1 Afternoon: Scrum Events"
      content: |
        **Topics Covered:**
        - Sprint planning workshop
        - Daily Scrum facilitation
        - Sprint review best practices
        - Retrospective techniques

        **Hands-on Practice:**
        - Facilitate a sprint planning session
        - Practice different retrospective formats
    - title: "Day 2: Advanced Scrum Master Skills"
      content: |
        **Advanced Topics:**
        - Coaching and mentoring techniques
        - Conflict resolution strategies
        - Organizational change management
        - Metrics and measurement

        **Certification Preparation:**
        - Practice exam questions
        - Key concept review
        - Q&A session
```

### Project Timeline

```yaml
- type: "phases"
  title: "Agile Transformation Journey"
  content: "Our proven approach to organizational transformation"
  sylabus:
    - title: "Phase 1: Assessment & Planning (Weeks 1-2)"
      content: |
        **Assessment Activities:**
        - Current state analysis
        - Team capability evaluation
        - Technology stack review
        - Cultural readiness assessment

        **Deliverables:**
        - Comprehensive assessment report
        - Transformation roadmap
        - Risk mitigation plan
    - title: "Phase 2: Foundation Building (Weeks 3-6)"
      content: |
        **Key Activities:**
        - Team formation and training
        - Process establishment
        - Tool configuration and setup
        - Initial pilot project launch

        **Success Metrics:**
        - Team velocity establishment
        - Process adherence measurement
        - Quality metrics baseline
    - title: "Phase 3: Scaling & Optimization (Weeks 7-12)"
      content: |
        **Scaling Activities:**
        - Multi-team coordination
        - Advanced practice implementation
        - Continuous improvement cycles
        - Organization-wide rollout

        **Optimization Focus:**
        - Performance tuning
        - Process refinement
        - Culture reinforcement
```

### Workshop Agenda

```yaml
- type: "phases"
  title: "DevOps Workshop Agenda"
  content: "A full-day intensive workshop on DevOps practices"
  sylabus:
    - title: "Morning Session: CI/CD Fundamentals"
      content: |
        **9:00 - 10:30 AM**
        - Introduction to DevOps principles
        - Continuous Integration basics
        - Pipeline design patterns

        **10:45 - 12:00 PM**
        - Hands-on: Building your first pipeline
        - Testing strategies and automation
        - Code quality gates
    - title: "Afternoon Session: Advanced Topics"
      content: |
        **1:00 - 2:30 PM**
        - Infrastructure as Code
        - Container orchestration
        - Monitoring and observability

        **2:45 - 4:00 PM**
        - Security integration (DevSecOps)
        - Performance optimization
        - Troubleshooting common issues
    - title: "Wrap-up: Implementation Planning"
      content: |
        **4:00 - 5:00 PM**
        - Action planning for your organization
        - Resource recommendations
        - Q&A and next steps
        - Certificate presentation
```

### Learning Path

```yaml
- type: "phases"
  title: "Agile Learning Journey"
  content: "Progressive skill development for agile practitioners"
  sylabus:
    - title: "Beginner Level: Agile Foundations"
      content: |
        **Duration:** 2-4 weeks

        **Core Concepts:**
        - Agile manifesto and principles
        - Basic Scrum framework
        - User story writing
        - Simple estimation techniques

        **Recommended Courses:**
        - Introduction to Agile
        - Scrum Fundamentals
    - title: "Intermediate Level: Practice & Application"
      content: |
        **Duration:** 1-3 months

        **Skill Development:**
        - Advanced Scrum practices
        - Facilitation techniques
        - Team dynamics
        - Conflict resolution

        **Recommended Courses:**
        - Professional Scrum Master
        - Agile Coaching Basics
    - title: "Advanced Level: Leadership & Mastery"
      content: |
        **Duration:** 3-6 months

        **Leadership Skills:**
        - Organizational transformation
        - Scaling frameworks
        - Cultural change management
        - Metrics and measurement

        **Recommended Courses:**
        - Advanced Scrum Master
        - Agile Leadership
        - Scaling Agile
```

## Layout Structure

- **Single Column**: Full-width layout (`col-12`)
- **Sequential Order**: Phases display in the order specified
- **Consistent Spacing**: `p-2` padding for each phase
- **Typography**: `h3` headings for phase titles

## Styling

The section uses these CSS classes:

- `.row.p-5`: Main container with padding
- `.col-12.p-2`: Full-width phase containers
- `h3`: Phase title styling
- Markdown rendering for phase content

## Fallback Behavior

If no syllabus is provided:

- Displays: "No Sylabus" (note: contains the same spelling as the parameter)
- Section remains visible but indicates empty state

## Best Practices

1. **Logical Progression**: Order phases from basic to advanced or chronologically
2. **Consistent Format**: Use similar structure and detail level across phases
3. **Clear Objectives**: Include learning objectives or deliverables for each phase
4. **Actionable Content**: Provide specific, actionable information
5. **Reasonable Length**: Keep phase descriptions detailed but manageable

## Common Use Cases

1. **Course Syllabi**: Detailed breakdown of training programs
2. **Project Timelines**: Phase-by-phase project execution plans
3. **Implementation Roadmaps**: Step-by-step transformation guides
4. **Workshop Agendas**: Detailed session breakdowns
5. **Learning Paths**: Progressive skill development journeys

## Markdown Support

Phase content supports full Markdown formatting:

- **Bold** and _italic_ text
- Bullet points and numbered lists
- Code blocks and inline code
- Links and emphasis
- Headings and subheadings

This section is ideal for educational content, project planning, and any scenario where you need to present information in a clear, sequential format.
