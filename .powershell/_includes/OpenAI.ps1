
function Get-OpenAIEmbedding {
    param (
        [Parameter(Mandatory)]
        [string]$Content,

        [string]$Model = "text-embedding-3-large",
        # OpenAI API Key
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    $response = Invoke-RestMethod `
        -Uri "https://api.openai.com/v1/embeddings" `
        -Headers @{
        "Authorization" = "Bearer $OPEN_AI_KEY"
        "Content-Type"  = "application/json"
    } `
        -Body (ConvertTo-Json @{
            input = $Content
            model = $Model
        }) `
        -Method Post

    return $response.data[0].embedding
}


function Call-OpenAI {
    param (
        [Parameter(Mandatory = $false)]
        [string]$system,
        
        # Prompt text
        [Parameter(Mandatory = $true)]
        [string]$prompt,
    
        # OpenAI API Key
        [Parameter(Mandatory = $true)]
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    # Set the API endpoint and API key
    $apiUrl = "https://api.openai.com/v1/chat/completions"

    # Set default system prompt if not provided
    if ([string]::IsNullOrEmpty($system)) {
        $system = "You are an expert in Generative Experience Optimisation within Agile, Scrum, DevOps, and Evidence-Based Management contexts."
    }

    # Create the body for the API request
    $body = @{
        "model"       = "gpt-4.5-preview"
        "messages"    = @(
            @{ "role" = "system"; "content" = $system },
            @{ "role" = "user"; "content" = $prompt }
        )
        "temperature" = 0
        "max_tokens"  = 16000  # Based on model's max output capacity
    } | ConvertTo-Json -Depth 10

    # Define retry parameters
    $maxRetries = 5
    $retryDelay = 4  # Initial delay in seconds

    for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
        try {
            # Send the request to the ChatGPT API
            $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{
                "Content-Type"  = "application/json; charset=utf-8"
                "Authorization" = "Bearer $OPEN_AI_KEY"
            } -Body $body -TimeoutSec 300

            # Validate response structure
            if ($response -and $response.choices -and $response.choices.Count -gt 0 -and $response.choices[0].message) {
                return $response.choices[0].message.content
            }
            else {
                throw "Invalid response structure received from OpenAI API."
            }
        }
        catch {
            $errorMessage = $_.Exception.Message

            if ($errorMessage -match "429 \(Too Many Requests\)") {
                # API Rate Limit hit; apply exponential backoff
                Write-WarningLog "Rate limit exceeded. Retrying in $retryDelay seconds..."
                Start-Sleep -Seconds $retryDelay
                $retryDelay *= 2  # Exponential backoff
            }
            elseif ($errorMessage -match "500|502|503|504") {
                # Handle server errors
                Write-WarningLog "Server error encountered. Retrying in $retryDelay seconds..."
                Start-Sleep -Seconds $retryDelay
                $retryDelay *= 2
            }
            elseif ($errorMessage -match "HttpClient.Timeout") {
                # Handle server errors
                Write-WarningLog "Server took too long to respond. Retrying in $retryDelay seconds..."
                Start-Sleep -Seconds $retryDelay
                $retryDelay *= 8
            }
            else {
                # Non-retryable errors
                Write-Error "API call failed: $errorMessage"
                return $null
            }
        }
    }

    Write-Error "Max retries reached. Unable to get a valid response from OpenAI."
    return $null
}


function Get-TokenEstimate {
    param (
        [string]$prompt
    )

    # Create a temporary file for the prompt
    $tempFile = [System.IO.Path]::GetTempFileName()

    try {
        # Write the prompt to the temporary file with UTF-8 encoding
        Set-Content -Path $tempFile -Value $prompt -Encoding UTF8
        
        # Escape backslashes for Python compatibility
        $escapedTempFile = $tempFile -replace '\\', '\\'

        # Run Python to count tokens and handle potential errors
        $tokenCount = python -c "import tiktoken; enc = tiktoken.encoding_for_model('gpt-4'); print(len(enc.encode(open(r'$escapedTempFile', 'r', encoding='utf-8').read())))" 2>&1

        # Convert the token count to an integer
        if ($tokenCount -match '^\d+$') {
            return [int]$tokenCount
        }
        else {
            Write-Error "Failed to parse token count. Python output: $tokenCount"
            return $null
        }
    }
    catch {
        Write-Error "An error occurred while estimating tokens: $_"
        return $null
    }
    finally {
        # Ensure the temporary file is deleted
        if (Test-Path $tempFile) {
            Remove-Item -Path $tempFile -ErrorAction SilentlyContinue
        }
    }
}


function Get-TextChunks {
    param ($text, $maxLength)

    $chunks = @()
    $remainingText = $text

    while ($remainingText.Length -gt 0) {
        $currentChunk = $remainingText.Substring(0, [Math]::Min($remainingText.Length, $maxLength))
        $chunks += $currentChunk
        $remainingText = $remainingText.Substring([Math]::Min($remainingText.Length, $maxLength))
    }

    return $chunks
}

function Get-OpenAIResponse {
    param (
        [Parameter(Mandatory = $false)]
        [string]$system,
        
        # Prompt text
        [Parameter(Mandatory = $true)]
        [string]$prompt,
    
        # OpenAI API Key
        [Parameter(Mandatory = $false)]
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    Write-VerboseLog "==============Get-OpenAIResponse:START"
    $sw = [Diagnostics.Stopwatch]::StartNew()
    Write-VerboseLog "-----------------------------------------"

    # Estimate tokens for the prompt
    $tokenEstimate = Get-TokenCountFromServer $prompt
    $maxTokensPerChunk = 50000  # Leave room for model response

    # Split the prompt into chunks if it exceeds the max token size
    if ($tokenEstimate -gt $maxTokensPerChunk) {
        Write-Debug "Prompt exceeds max token size, chunking..."
        $chunks = Get-TextChunks -text $prompt -maxLength ($maxTokensPerChunk * 4)  # Approximate character length
    }
    else {
        $chunks = @($prompt)
    }

    # Initialize result
    $chunkResults = @()

    # Process each chunk
    foreach ($chunk in $chunks) {
        Write-Debug "Processing chunk..."
        $result = Call-OpenAI -system $system -prompt $chunk -OPEN_AI_KEY $OPEN_AI_KEY
        
        # Store the result of each chunk
        $chunkResults += $result
    }

    # Combine results if more than one chunk
    if ($chunkResults.Count -gt 1) {
        Write-Debug "Combining chunked responses..."
        $combinedPrompt = "Here are several responses from different parts of a git diff summarization task: `n`n" + ($chunkResults -join "`n") + "`n`nPlease combine these into a single, coherent summary."
        $fullResult = Call-OpenAI -system $system -prompt $combinedPrompt -OPEN_AI_KEY $OPEN_AI_KEY
    }
    else {
        $fullResult = $chunkResults[0]  # Only one chunk, no need to combine
    }

    Write-VerboseLog "-----------------------------------------"
    $sw.Stop()
    Write-VerboseLog "==============Get-OpenAIResponse:END | Elapsed time: $($sw.Elapsed)"
    
    return $fullResult
}


#######################################################
#######################################################
#######################################################

$batchesInProgress = $null;
$batchesInProgressMax = 10;

function Submit-OpenAIBatch {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY,
        [string]$Model = "gpt-4.5-preview",
        [array]$Prompts,
        [string]$OutputFile = "batch_output.jsonl"
    )
    if (-not $batchesInProgress) {
        # Get current batches in progress
        $batchesInProgress = Get-OpenAIBatchesInProgress -ApiKey $OPEN_AI_KEY
    }
    if ($batchesInProgress -ge $batchesInProgressMax) {
        Write-WarningLog "Maximum number of batches in progress reached. Please wait for some to complete before submitting more."
        return $null
    }
    $tokenEstimate = 0
    $total = $Prompts.Count
    $counter = 0
    $nextPercent = 10
    $BatchData = $Prompts | ForEach-Object {
        $tokenEstimate += $_.TokenEstimate
        $counter++
        $percent = [math]::Floor(($counter / $total) * 100)
        if ($percent -ge $nextPercent) {
            Write-Host "Processed $counter of $total prompts ($percent%)"
            $nextPercent += 10
        }

        [PSCustomObject]@{
            custom_id = "request-$([System.Guid]::NewGuid().ToString())"
            method    = "POST"
            url       = "/v1/chat/completions"
            body      = @{
                model      = $Model
                messages   = @(
                    @{ role = "system"; content = "You are an expert in Generative Experience Optimisation within Agile, Scrum, DevOps, and Evidence-Based Management contexts." },
                    @{ role = "user"; content = $_ }
                )
                max_tokens = 5000
            }
        } | ConvertTo-Json -Depth 10 -Compress
    }

    
    # Ensure each JSON object is written as a new line in the .jsonl file
    $BatchData -join "`n" | Set-Content -Path $OutputFile -Encoding utf8
    
    # Upload the batch file
    $UploadResponse = Invoke-RestMethod -Uri "https://api.openai.com/v1/files" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY" } -Method Post -Form @{purpose = "batch"; file = Get-Item $OutputFile }
    $FileId = $UploadResponse.id
    
    # Create batch
    $BatchRequestMeta = @{tokenEstimate = "$tokenEstimate" }
    $BatchRequest = @{input_file_id = $FileId; endpoint = "/v1/chat/completions"; completion_window = "24h"; metadata = $BatchRequestMeta } | ConvertTo-Json
    $BatchResponse = Invoke-RestMethod -Uri "https://api.openai.com/v1/batches" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY"; "Content-Type" = "application/json" } -Method Post -Body $BatchRequest
    $BatchId = $BatchResponse.id
    if ($batchId) {
        $batchesInProgress++
    }
    Write-Host "Batch submitted. ID: $BatchId"
    return  [PSCustomObject]@{
        BatchId              = $BatchId
        TokenEstimate        = $tokenEstimate
        BatchesInProgress    = $batchesInProgress
        BatchesInProgressMax = $batchesInProgressMax
    }
}

function Get-OpenAIBatchStatus {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY,
        [Parameter(Mandatory = $true)]
        [string]$BatchId
    )
    
    $Response = Invoke-RestMethod -Uri "https://api.openai.com/v1/batches/$BatchId" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY"; "Content-Type" = "application/json" } -Method Get
    return $Response.status
}

function Get-OpenAIBatchResults {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY,
        [string]$BatchId,
        [string]$OutputFile = "batch_output.jsonl"
    )
    
    # Get batch details
    $BatchDetails = Invoke-RestMethod -Uri "https://api.openai.com/v1/batches/$BatchId" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY"; "Content-Type" = "application/json" } -Method Get
    if ($BatchDetails.status -notin @("completed", "expired")) {
        Write-Host "Batch is not yet completed or expired. Current status: $($BatchDetails.status)"
        return $null
    }
    
    # Download the output file
    $OutputFileId = $BatchDetails.output_file_id
    Invoke-RestMethod -Uri "https://api.openai.com/v1/files/$OutputFileId/content" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY" } -OutFile $OutputFile
    
    Write-Host "Batch results saved to $OutputFile"
    return Get-Content $OutputFile
}

function Cancel-OpenAIBatch {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY,
        [string]$BatchId
    )
    
    Invoke-RestMethod -Uri "https://api.openai.com/v1/batches/$BatchId/cancel" -Headers @{"Authorization" = "Bearer $OPEN_AI_KEY"; "Content-Type" = "application/json" } -Method Post
    Write-Host "Batch cancellation requested for $BatchId"
}

function Submit-And-Wait-OpenAIBatch {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY,
        [string]$Model = "gpt-4.1",
        [array]$Prompts,
        [string]$OutputFile = "batch_output.jsonl"
    )
    
    $BatchId = Submit-OpenAIBatch -ApiKey $OPEN_AI_KEY -Model $Model -Prompts $Prompts -OutputFile $OutputFile
    
    Write-Host "Waiting for batch completion..."
    while ($true) {
        Start-Sleep -Seconds 30
        $Status = Get-OpenAIBatchStatus -ApiKey $OPEN_AI_KEY -BatchId $BatchId
        Write-Host "Current batch status: $Status"
        if ($Status -eq "completed") {
            break
        }
    }
    
    return Retrieve-OpenAIBatchResults -ApiKey $OPEN_AI_KEY -BatchId $BatchId -OutputFile $OutputFile
}

function Get-OpenAIBatchesInProgress {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    $headers = @{
        "Authorization" = "Bearer $OPEN_AI_KEY"
        "Content-Type"  = "application/json"
    }

    $totalBatches = 0
    $after = $null  # Cursor for pagination

    do {
        # Construct the API URL with pagination support
        $url = "https://api.openai.com/v1/batches"
        if ($after) {
            $url += "?after=$after"
        }

        # Get the list of all batches
        $batchesResponse = Invoke-RestMethod -Uri $url -Headers $headers -Method Get

        if (-not $batchesResponse.data -or $batchesResponse.data.Count -eq 0) {
            Write-DebugLog "No active batches found."
            return 0
        }

        # Loop through each batch and retrieve details
        foreach ($batch in $batchesResponse.data) {
            $batchId = $batch.id
            Write-VerboseLog "Batch ID: $batchId | Status: $($batch.status)"
            if ($batch.status -eq "in_progress" -or $batch.status -eq "queued") {
                $totalBatches++;
            }
        }

        # Use the last batch ID as the 'after' cursor for the next request
        $after = if ($batchesResponse.has_more -and $batchesResponse.last_id) { $batchesResponse.last_id } else { $null }

    } while ($after)  # Continue fetching pages until all batches are retrieved

    Write-DebugLog "Total enqueued batches: $totalBatches"
    return $totalBatches
}

function Get-OpenAIEnqueuedTokens {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    $headers = @{
        "Authorization" = "Bearer $OPEN_AI_KEY"
        "Content-Type"  = "application/json"
    }

    $totalTokens = 0
    $after = $null  # Cursor for pagination

    do {
        # Construct the API URL with pagination support
        $url = "https://api.openai.com/v1/batches"
        if ($after) {
            $url += "?after=$after"
        }

        # Get the list of all batches
        $batchesResponse = Invoke-RestMethod -Uri $url -Headers $headers -Method Get

        if (-not $batchesResponse.data -or $batchesResponse.data.Count -eq 0) {
            Write-DebugLog "No active batches found."
            return 0
        }

        # Loop through each batch and retrieve details
        foreach ($batch in $batchesResponse.data) {
            $batchId = $batch.id
            Write-DebugLog "Batch ID: $batchId | Status: $($batch.status)"

            if ($batch.status -eq "in_progress" -or $batch.status -eq "queued") {
                $totalTokens += $batch.request_counts.total * 10000

            }
        }

        # Use the last batch ID as the 'after' cursor for the next request
        $after = if ($batchesResponse.has_more -and $batchesResponse.last_id) { $batchesResponse.last_id } else { $null }

    } while ($after)  # Continue fetching pages until all batches are retrieved

    Write-DebugLog "Total enqueued tokens: $totalTokens"
    return $totalTokens
}

function Get-OpenAIBatchList {
    param (
        [string]$OPEN_AI_KEY = $env:OPENAI_API_KEY
    )

    $headers = @{
        "Authorization" = "Bearer $OPEN_AI_KEY"
        "Content-Type"  = "application/json"
    }

    $totalTokens = 0
    $after = $null  # Cursor for pagination

    do {
        # Construct the API URL with pagination support
        $url = "https://api.openai.com/v1/batches"
        if ($after) {
            $url += "?after=$after"
        }

        # Get the list of all batches
        $batchesResponse = Invoke-RestMethod -Uri $url -Headers $headers -Method Get

        if (-not $batchesResponse.data -or $batchesResponse.data.Count -eq 0) {
            Write-DebugLog "No active batches found."
            return 0
        }

        # Loop through each batch and retrieve details
        foreach ($batch in $batchesResponse.data) {
            Write-DebugLog "Batch ID: $($batch.id) | Status: $($batch.status)"
            # Write-DebugLog "Batch: {batch}" -PropertyValues $batch
        }

        # Use the last batch ID as the 'after' cursor for the next request
        $after = if ($batchesResponse.has_more -and $batchesResponse.last_id) { $batchesResponse.last_id } else { $null }

    } while ($after)  # Continue fetching pages until all batches are retrieved

    Write-DebugLog "Total enqueued tokens: $totalTokens"
    return $totalTokens
}





Write-InfoLog "OpenAI.ps1 loaded" 