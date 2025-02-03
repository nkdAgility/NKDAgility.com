# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1

$inputDir = "site\content\resources\videos\youtube"
$outputDir = "site\data"
$maxWordCount = 5000

# Function to split data based on word count and create index
function Split-Data {
    param (
        [array]$data,
        [string]$baseName,
        [string]$extension,
        [int]$wordLimit
    )
    $chunk = @()
    $currentWordCount = 0
    $chunkIndex = 1
    $indexList = @()

    foreach ($item in $data) {
        $cleanCaptions = ($item.captions -replace "\s+", " ").Trim()
        $itemWords = ($cleanCaptions -split '\s+').Count
        Write-Host "Processing item: $item.id - Word count: $itemWords"
        
        if (($currentWordCount + $itemWords) -gt $wordLimit -and $chunk.Count -gt 0) {
            $chunkFileName = "${baseName}_part$chunkIndex" + ($extension -ne "" ? ".$extension" : "")
            $chunkFilePath = "$outputDir\$chunkFileName"
            
            if ($extension -eq "json") {
                $chunk | ConvertTo-Json -Depth 3 | Set-Content -Path $chunkFilePath -Encoding UTF8
            }
            else {
                $chunk | ConvertTo-Yaml | Set-Content -Path $chunkFilePath -Encoding UTF8
            }
            
            Write-Host "Saved chunk: $chunkFilePath with word count: $currentWordCount"
            $indexList += @{ part = $chunkIndex; file = $chunkFileName }
            
            $chunk = @()
            $currentWordCount = 0
            $chunkIndex++
        }
        
        $chunk += $item
        $currentWordCount += $itemWords
    }
    
    if ($chunk.Count -gt 0) {
        $chunkFileName = "${baseName}-chunk$chunkIndex" + ($extension -ne "" ? ".$extension" : "")
        $chunkFilePath = "$outputDir\$chunkFileName"
        
        if ($extension -eq "json") {
            $chunk | ConvertTo-Json -Depth 3 | Set-Content -Path $chunkFilePath -Encoding UTF8
        }
        else {
            $chunk | ConvertTo-Yaml | Set-Content -Path $chunkFilePath -Encoding UTF8
        }
        
        Write-Host "Saved chunk: $chunkFilePath with final word count: $currentWordCount"
        $indexList += @{ part = $chunkIndex; file = $chunkFileName }
    }
    
    # Save index files
    $indexJsonPath = "$outputDir\collection.captions.index.json"
    $indexYamlPath = "$outputDir\collection.captions.index.yml"
    
    $indexList | ConvertTo-Json -Depth 3 | Set-Content -Path $indexJsonPath -Encoding UTF8
    $indexList | ConvertTo-Yaml | Set-Content -Path $indexYamlPath -Encoding UTF8
    
    Write-Host "Saved index JSON: $indexJsonPath"
    Write-Host "Saved index YAML: $indexYamlPath"
}

# Function to generate combined captions in YAML and JSON
function Generate-CombinedCaptions {
    Write-Host "Starting caption processing..."
    $captionsData = @()
    
    # Iterate through each video folder
    Get-ChildItem -Path $inputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $videoId = $_.Name
        Write-Host "Processing video: $videoId"

        $hugoDataMarkdown = "$videoDir\index.md"
        if (Test-Path $hugoDataMarkdown) {
            $HugoData = Get-HugoMarkdown -Path $hugoDataMarkdown
            Write-Host "Loaded metadata for $videoId"
        }
        else {
            Write-Host "Warning: Missing index.md for $videoId"
            return
        }

        $captionsFile = "$videoDir\index.captions.en.md"
        if (Test-Path $captionsFile) {
            $videoCaptions = Get-Content -Path $captionsFile -Raw
            Write-Host "Loaded captions for $videoId"
        }
        else {
            $videoCaptions = ""
            Write-Host "Warning: No captions found for $videoId"
        }

        $videoTitle = $HugoData.FrontMatter.title
        $videoDescription = $HugoData.FrontMatter.description

        $captionsData += [PSCustomObject]@{
            id          = $videoId
            title       = $videoTitle
            description = $videoDescription
            captions    = $videoCaptions
        }
    }

    # Save full YAML file
    $yamlFilePath = "$outputDir\collection.captions.yml"
    $captionsData | ConvertTo-Yaml | Set-Content -Path $yamlFilePath -Encoding UTF8
    Write-Host "Saved full YAML file: $yamlFilePath"

    # Save full JSON file
    $jsonFilePath = "$outputDir\collection.captions.json"
    $captionsData | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonFilePath -Encoding UTF8
    Write-Host "Saved full JSON file: $jsonFilePath"

    # Split into word count-based chunks and generate index files
    #Write-Host "Splitting YAML file into word-based chunks..."
    #Split-Data -data $captionsData -baseName "collection.captions" -extension "yml" -wordLimit $maxWordCount

    #Write-Host "Splitting JSON file into word-based chunks..."
    #Split-Data -data $captionsData -baseName "collection.captions" -extension "json" -wordLimit $maxWordCount

    Write-Host "Caption processing completed."
}

Generate-CombinedCaptions
