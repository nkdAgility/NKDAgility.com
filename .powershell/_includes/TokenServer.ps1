
# Run Python package install
$output = python -m pip install fastapi uvicorn tiktoken 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-ErrorLog "Python bits install failed with exit code {ExitCode}" -PropertyValues $LASTEXITCODE
}
else {
    Write-InfoLog "Python bits install completed successfully with exit code {ExitCode}" -PropertyValues $LASTEXITCODE
}

# Checks if the token server is reachable
function Test-TokenServer {
    param (
        [string]$ServerUrl = "http://127.0.0.1:8000/count-tokens",
        [int]$Retries = 3,
        [int]$DelaySeconds = 1
    )

    for ($i = 0; $i -lt $Retries; $i++) {
        try {
            $null = Invoke-RestMethod -Uri $ServerUrl -Method Post -Body (@{ content = "some test" } | ConvertTo-Json) -ContentType "application/json" -TimeoutSec 5
            return $true
        }
        catch {
            Write-WarningLog "Failed to get token count from server: {ErrorMessage}" -PropertyValues $_.Exception.Message
            Start-Sleep -Seconds $DelaySeconds
        }
    }

    return $false
}

# Starts the Python FastAPI token server if it's not already running
function Start-TokenServer {
    param (
        [string]$ScriptPath = ".\.powershell\py\token_server.py",
        [string]$BindHost = "127.0.0.1",
        [int]$Port = 8000
    )

    $serverUrl = "http://" + $BindHost + ":" + $Port + "/count-tokens"

    if (Test-TokenServer -ServerUrl $serverUrl) {
        Write-InfoLog "Token Server already responding at {BindHost}:{Port}" -PropertyValues $BindHost, $Port
        return
    }

    # Kill any stuck process before trying to start
    Stop-TokenServer

    $workingDir = Split-Path -Path $ScriptPath -Parent
    if (-not (Test-Path $workingDir)) {
        throw "Working directory '$workingDir' does not exist."
    }

    Write-InfoLog "Starting Token Server on {BindHost}:{Port} using script {ScriptPath}" -PropertyValues $BindHost, $Port, $ScriptPath

    $scriptFilename = Split-Path -Path $ScriptPath -Leaf
    
    $global:TokenServerProcess = Start-Process -FilePath "python" `
        -ArgumentList "$scriptFilename" `
        -WorkingDirectory $workingDir `
        -RedirectStandardError ".\.data\token_server_err.log" `
        -RedirectStandardOutput ".\.data\token_server_out.log" `
        -WindowStyle Hidden `
        -PassThru

    $maxRetries = 10
    $retryCount = 0
    while (-not (Test-TokenServer -ServerUrl $serverUrl) -and $retryCount -lt $maxRetries) {
        Start-Sleep -Seconds 1
        $retryCount++
    }

    if ($retryCount -eq $maxRetries) {
        throw "Token server failed to respond after startup."
    }

    Write-InfoLog "Token Server is now running at {BindHost}:{Port}" -PropertyValues $BindHost, $Port
}

# Calls the token server for a single content string, assumes server is running
function Get-TokenCountFromServer {
    param (
        [string]$Content,
        [string]$ServerUrl = "http://127.0.0.1:8000/count-tokens"
    )

    $body = @{ content = $Content } | ConvertTo-Json -Depth 3

    for ($i = 0; $i -lt 3; $i++) {
        try {
            $response = Invoke-RestMethod -Uri $ServerUrl -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
            Write-VerboseLog "Token count retrieved: {TokenCount}" -PropertyValues $response.token_count
            return [int]$response.token_count
        }
        catch {
            Write-WarningLog "Failed to get token count from server: {ErrorMessage}" -PropertyValues $_.Exception.Message
            Start-Sleep -Seconds 1
        }
    }

    Write-ErrorLog "Failed to get token count from server after 3 retries"
    return Get-TokenCountLocally -Content $Content
}



# Stops the running token server if tracked or detected
function Stop-TokenServer {
    if ($global:TokenServerProcess -and !$global:TokenServerProcess.HasExited) {
        Write-InfoLog "Stopping Token Server with tracked PID {Pid}" -PropertyValues $global:TokenServerProcess.Id
        Stop-Process -Id $global:TokenServerProcess.Id -Force
        Remove-Variable -Name TokenServerProcess -Scope Global
    }
    else {
        # Fallback: find any python process holding port 8000
        $port = 8000
        $listeningProcId = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1 | Select-Object -ExpandProperty OwningProcess

        if ($listeningProcId) {
            $proc = Get-Process -Id $listeningProcId -ErrorAction SilentlyContinue
            if ($proc -and $proc.Path -match "python") {
                Write-InfoLog "Force-stopping Token Server detected on port {Port} with PID {Pid}" -PropertyValues $port, $proc.Id
                Stop-Process -Id $proc.Id -Force
            }
        }
        else {
            Write-InfoLog "No running Token Server found on port {Port}" -PropertyValues $port
        }
    }
}

function Get-TokenCountLocally {
    param ([string]$Content)

    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $Content -Encoding UTF8

    $tokenCount = python -c @"
import tiktoken, sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    text = f.read()
encoding = tiktoken.get_encoding('cl100k_base')
print(len(encoding.encode(text)))
"@ $tempFile

    Remove-Item $tempFile -Force
    return [int]$tokenCount
}


# Restart helper: stop and start
function Restart-TokenServer {
    Stop-TokenServer
    Start-TokenServer
}

Write-InfoLog "TokenServer.ps1 loaded"
