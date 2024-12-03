# Define the HTML content
$htmlContent = @'
<img src="https://nkdagilityblobs.blob.core.windows.net/$web/company/customers/washington-department-of-transport/images/washington-state-DOT_hu2529872147769033792.jpg">
<link href='/styles/site.css'>
<meta content=https://example.com/og-image.webp>
<img src=./images/washington-state-DOT_hu2529872147769033792.png>
<img src="https://example.com/image.svg">
'@

# Define the regex with a named capture group for the full URL or file path
$regex = "(?i)(src|content|href)\s*=\s*([""']?)(?<Url>[^\s""'>]+\.(jpg|jpeg|png|gif|webp|svg))\2"

# Perform the regex match
$matches = [regex]::Matches($htmlContent, $regex)

# Check and output matches
if ($matches.Count -gt 0) {
    foreach ($match in $matches) {
        # Output the captured URL from the named group 'Url'
        Write-Output $match.Groups["Url"].Value
    }
}
else {
    Write-Output "No matches found."
}
