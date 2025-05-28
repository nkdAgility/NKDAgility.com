#!/usr/bin/env python3
"""
Script to generate module pages from syllabus.yaml files
This script reads a syllabus.yaml file and generates individual module markdown files
"""

import os
import sys
import yaml
from pathlib import Path


def create_module_page(module, course_title, output_dir, course_slug):
    """Create a markdown page for a single module"""
    module_id = module.get('id', 0)
    title = module.get('title', 'Untitled Module')
    duration = module.get('duration', 0)
    content = module.get('content', '')
    
    # Create module file at the same level as the course
    module_slug = f"{course_slug}-module-{module_id}"
    module_file = output_dir / f"{module_slug}.md"
    
    # Create module markdown content
    front_matter = f"""---
title: "Module {module_id}: {title}"
description: "Module {module_id} of {course_title} - {title}"
type: "module"
layout: "module"
course: "{course_title}"
courseSlug: "{course_slug}"
moduleId: {module_id}
duration: {duration}
weight: {module_id}
draft: false
---

"""
    
    # Build the content
    markdown_content = front_matter
    markdown_content += content + "\n\n"
    markdown_content += f"## Duration\n{duration}+ minutes\n\n"
    
    # Add learning resources if they exist
    if 'learningResources' in module and module['learningResources']:
        markdown_content += "## Learning Resources\n\n"
        for resource in module['learningResources']:
            if not resource.get('draft', False):
                resource_title = resource.get('title', 'Untitled Resource')
                resource_duration = resource.get('duration', 0)
                resource_link = resource.get('link', '')
                markdown_content += f"- **{resource_title}** ({resource_duration} min)"
                if resource_link:
                    markdown_content += f" - [Link]({resource_link})"
                markdown_content += "\n"
                
                if 'content' in resource:
                    markdown_content += f"  {resource['content']}\n"
        markdown_content += "\n"
    
    # Add assignment if it exists
    if 'assignment' in module and module['assignment'].get('title'):
        assignment = module['assignment']
        markdown_content += f"## Assignment: {assignment['title']}\n\n"
        markdown_content += assignment.get('content', '') + "\n\n"
        
        if 'examples' in assignment:
            markdown_content += "### Examples\n\n"
            markdown_content += assignment['examples'] + "\n\n"
    
    # Write the module file
    with open(module_file, 'w', encoding='utf-8') as f:
        f.write(markdown_content)
    
    print(f"Created module page: {module_file}")


def generate_modules_from_syllabus(syllabus_file, course_dir):
    """Generate module pages from a syllabus.yaml file"""
    
    # Load syllabus data
    with open(syllabus_file, 'r', encoding='utf-8') as f:
        syllabus_data = yaml.safe_load(f)
    
    # Get course title and slug from index.md
    index_file = course_dir / "index.md"
    course_title = "Course"
    course_slug = course_dir.name
    if index_file.exists():
        with open(index_file, 'r', encoding='utf-8') as f:
            content = f.read()
            # Extract title from front matter
            if content.startswith('---'):
                front_matter_end = content.find('---', 3)
                if front_matter_end > 0:
                    front_matter = content[3:front_matter_end]
                    for line in front_matter.split('\n'):
                        if line.strip().startswith('title:'):
                            course_title = line.split(':', 1)[1].strip().strip('"\'')
                            break
                        elif line.strip().startswith('slug:'):
                            course_slug = line.split(':', 1)[1].strip().strip('"\'')
    
    # Generate modules
    syllabus = syllabus_data.get('syllabus', [])
    for module in syllabus:
        create_module_page(module, course_title, course_dir, course_slug)
    
    print(f"Generated {len(syllabus)} module pages in {course_dir}")


def main():
    if len(sys.argv) != 2:
        print("Usage: python generate_modules.py <course_directory>")
        print("Example: python generate_modules.py site/content/capabilities/training-courses/scrumorg-professional-scrum-master")
        sys.exit(1)
    
    course_dir = Path(sys.argv[1])
    syllabus_file = course_dir / "syllabus.yaml"
    
    if not course_dir.exists():
        print(f"Error: Course directory {course_dir} does not exist")
        sys.exit(1)
    
    if not syllabus_file.exists():
        print(f"Error: syllabus.yaml not found in {course_dir}")
        sys.exit(1)
    
    generate_modules_from_syllabus(syllabus_file, course_dir)


if __name__ == "__main__":
    main()