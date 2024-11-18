# Define the base currency
$baseCurrency = 'GBP'

# Define the target currencies for conversion
$targetCurrencies = @('EUR', 'USD')

# Initialize an empty array to store the results
$exchangeRates = @()

# Loop through each target currency
foreach ($target in $targetCurrencies) {
    # Construct the API URL
    $url = "https://api.frankfurter.app/latest?from=$baseCurrency&to=$target"

    # Send a GET request to the API
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get

        # Extract the exchange rate
        $rate = $response.rates.$target

        # Create a custom object to store the result
        $exchangeRate = [PSCustomObject]@{
            BaseCurrency   = $baseCurrency
            TargetCurrency = $target
            ExchangeRate   = $rate
            Date           = $response.date
        }

        # Add the result to the array
        $exchangeRates += $exchangeRate
    }
    catch {
        Write-Error "Failed to retrieve exchange rate for $baseCurrency to $target : $_"
    }
}

# Convert the results to JSON
$jsonOutput = $exchangeRates | ConvertTo-Json -Depth 1 -Compress

# Define the output file path
$outputFilePath = "site\data\exchangeRates.json"

# Ensure the site\data directory exists
$outputDirectory = Split-Path -Path $outputFilePath -Parent
if (-not (Test-Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force
}

# Write the JSON to the file
try {
    Set-Content -Path $outputFilePath -Value $jsonOutput -Encoding UTF8
    Write-Host "Exchange rates saved to $outputFilePath"
}
catch {
    Write-Error "Failed to write exchange rates to file: $_"
}
