# Videos Section Usage

The `videos` section type displays YouTube videos in a responsive grid layout. It can show specific related videos or fallback to default promotional videos when no specific videos are provided.

## Basic Structure

```yaml
sections:
  - type: "videos"
    title: "Watch and Learn"
    content: "Explore our video content to deepen your understanding"
    related:
      - "/resources/videos/agile-transformation-basics"
      - "/resources/videos/devops-pipeline-setup"
      - "/resources/videos/scrum-master-tips"
```

## Features

- **YouTube Integration**: Embeds YouTube videos directly in responsive iframes
- **Responsive Grid**: 3-column layout on desktop, stacks on mobile
- **Fallback Content**: Shows default videos when no specific videos are provided
- **16:9 Aspect Ratio**: Maintains proper video proportions across devices
- **Clean Embedding**: Videos use YouTube's modest branding and minimal controls

## Parameters

### Required

- `type`: Must be "videos"

### Optional

- `title`: Section title
- `content`: Section description (supports Markdown)
- `related`: Array of video page paths
  - Each path should reference an existing video page in your site
  - Video pages should have a `videoId` parameter with the YouTube video ID

## Video Page Requirements

Referenced video pages should include:

```yaml
# In the video page's front matter
videoId: "yCyjGBNaRqI" # YouTube video ID
title: "Video Title"
# other video metadata
```

The `videoId` parameter is extracted from the YouTube URL:

- Full URL: `https://www.youtube.com/watch?v=yCyjGBNaRqI`
- Video ID: `yCyjGBNaRqI`

## Examples

### Educational Video Series

```yaml
- type: "videos"
  title: "Agile Fundamentals"
  content: "Master the basics with our foundational video series"
  related:
    - "/resources/videos/what-is-agile"
    - "/resources/videos/scrum-overview"
    - "/resources/videos/kanban-basics"
```

### Product Demonstrations

```yaml
- type: "videos"
  title: "See It In Action"
  content: "Watch our tools and methodologies at work"
  related:
    - "/resources/videos/platform-demo"
    - "/resources/videos/case-study-transformation"
    - "/resources/videos/customer-testimonial"
```

### Default Videos (No Related)

```yaml
- type: "videos"
  title: "Featured Videos"
  content: "Get to know NKD Agility"
  # No 'related' parameter - shows default videos
```

When no `related` videos are specified, the section displays:

- **Left video**: "NKD Agility Mission and Purpose" (ID: yCyjGBNaRqI)
- **Right video**: Default promotional video (ID: BJZdyEqHhXc)

## YouTube Embed Configuration

Videos are embedded with these settings:

- `controls=0`: Minimal player controls
- `showinfo=0`: Reduced video information overlay
- `modestbranding=1`: YouTube logo minimized
- `rel=0`: Reduced related video suggestions
- `autohide=1`: Controls auto-hide

## Layout Structure

- **3-Column Grid**: `col-lg-4` for desktop
- **Responsive**: `col-sm-12 col-md-12` for mobile stacking
- **Consistent Spacing**: `p-4` padding around video containers
- **Aspect Ratio**: `ratio ratio-16x9` maintains video proportions

## Error Handling

When a video page cannot be found:

- Displays: "Video `{path}` not found."
- Helps with debugging broken references
- Continues rendering other valid videos

## Fallback Behavior

If no videos are provided in the `related` array:

- Shows 2 default promotional videos
- Uses a 2-column layout for the default videos
- Maintains responsive behavior

## Best Practices

1. **Valid Video IDs**: Ensure all referenced video pages have correct `videoId` parameters
2. **Consistent Duration**: Group videos of similar length for better user experience
3. **Logical Sequencing**: Order videos from introductory to advanced topics
4. **Quality Content**: Only reference high-quality, relevant video content
5. **Accessibility**: Ensure video pages include proper titles and descriptions
6. **Mobile Testing**: Verify videos display properly on mobile devices

## YouTube Video ID Extraction

To get the video ID from a YouTube URL:

```
https://www.youtube.com/watch?v=yCyjGBNaRqI
                                 ^^^^^^^^^^^
                                 This is the videoId
```

## Video Page Example

```yaml
---
title: "Agile Transformation Basics"
date: 2024-01-15
videoId: "yCyjGBNaRqI"
description: "Learn the fundamentals of agile transformation"
tags:
  - agile
  - transformation
  - basics
---
Video content description and transcript can go here...
```

## Styling

The section uses these CSS classes:

- `.row`: Bootstrap row container
- `.col-lg-4.col-sm-12.col-md-12`: Responsive column classes
- `.p-4`: Padding for video spacing
- `.bg-white`: White background for video containers
- `.ratio.ratio-16x9`: Maintains 16:9 aspect ratio
- `.w-100`: Full-width iframe

## Security and Privacy

- Uses `referrerpolicy="strict-origin-when-cross-origin"`
- Allows necessary permissions for video playback
- Minimal data sharing with YouTube through embed parameters

## Performance Considerations

- Videos are embedded as iframes (not auto-playing)
- Users must click to start playback
- Reduces initial page load impact
- Responsive loading based on viewport size

This section is perfect for educational content, product demonstrations, testimonials, and any video-based learning materials.
