# Define the path to the target directory
$targetDirectory = "site\content\resources\videos\youtube"

# Retrieve all .srt files recursively from the target directory
$srtFiles = Get-ChildItem -Path $targetDirectory -Filter *.srt -File -Recurse

# Iterate through each .srt file
foreach ($file in $srtFiles) {
    # Check if the file size is 0 bytes
    if ($file.Length -eq 0) {
        # Delete the empty file
        Remove-Item -Path $file.FullName -Force
        # Output the name of the deleted file
        Write-Output "Deleted empty file: $($file.FullName)"
    }
}
