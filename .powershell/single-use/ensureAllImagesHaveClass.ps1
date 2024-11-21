# Define the directory containing the blog posts
$blogDir = "site\content\resources\blog"

# Recursively find all Markdown files in the blog directory
$markdownFiles = Get-ChildItem -Path $blogDir -Recurse -Filter *.md

# Loop through each markdown file
foreach ($file in $markdownFiles) {
    # Read the contents of the markdown file
    $content = Get-Content -Path $file.FullName

    # Initialize a list to hold the updated content
    $updatedContent = @()

    # Loop through each line of the content
    for ($i = 0; $i -lt $content.Count; $i++) {
        $line = $content[$i]

        # Check if the line contains an image (starts with ![] and is not already followed by {.post-img})
        if ($line -match "!\[.*\]\(.*\)" -and (($i + 1 -lt $content.Count) -and $content[$i + 1] -notmatch "\{.*\.post-img.*\}")) {
            # Add the image line
            $updatedContent += $line
            # Add the {.post-img} line on a new line immediately after the image
            $updatedContent += "{ .post-img }"
        }
        else {
            # Otherwise, add the line as is
            $updatedContent += $line
        }
    }

    # Write the updated content back to the file if changes were made
    if ($updatedContent -ne $content) {
        Set-Content -Path $file.FullName -Value $updatedContent
        Write-Host "Updated file: $($file.FullName)"
    }
    else {
        Write-Host "No changes made to: $($file.FullName)"
    }
}
