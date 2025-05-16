$root = "site\content\resources\signals"

# Depth-first search ensures child folders are deleted before their parents
Get-ChildItem -Path $root -Recurse -Directory |
Sort-Object FullName -Descending |
Where-Object { ($_ | Get-ChildItem -Force).Count -eq 0 } |
Remove-Item -Force
