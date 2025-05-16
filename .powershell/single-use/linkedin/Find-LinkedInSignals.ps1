# Load JSON files
$postsPath = ".\.data\linkedin-member_share_info-snapshots.json"
$commentsPath = ".\.data\linkedin-all_comments-snapshots.json"

$posts = Get-Content $postsPath -Raw | ConvertFrom-Json
$comments = Get-Content $commentsPath -Raw | ConvertFrom-Json

# Convert date fields to [datetime]
$posts = $posts | ForEach-Object {
    $_ | Add-Member -MemberType NoteProperty -Name ParsedDate -Value ([datetime]::Parse($_.Date)) -Force
    $_
}

$comments = $comments | ForEach-Object {
    $_ | Add-Member -MemberType NoteProperty -Name ParsedDate -Value ([datetime]::Parse($_.Date)) -Force
    $_
}

# Define regex pattern
$resourcePattern = 'https://nkdagility\.com/resources/\w+'
$maxSecondsDiff = 15

# Matched result pairs
$matchedPostCommentPairs = @()

foreach ($comment in $comments) {
    if ($comment.Message -notmatch $resourcePattern) { continue }

    $matchedPost = $posts | Where-Object {
        ($comment.ParsedDate - $_.ParsedDate).TotalSeconds -ge 0 -and
        ($comment.ParsedDate - $_.ParsedDate).TotalSeconds -le $maxSecondsDiff
    } | Sort-Object { ($comment.ParsedDate - $_.ParsedDate).TotalSeconds } | Select-Object -First 1

    if ($matchedPost) {
        $pair = [PSCustomObject]@{
            Post    = $matchedPost
            Comment = $comment
        }
        $matchedPostCommentPairs += $pair
    }
}

# Save combined data
$outputPath = ".\.data\matched_resource_posts_with_comments.json"
$matchedPostCommentPairs | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $outputPath
Write-Host "Saved paired posts and comments to $outputPath"
