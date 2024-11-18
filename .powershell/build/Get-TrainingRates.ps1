# Define all possible values for type, scope, mode, and rate modifier
$scopes = @('private', 'public')
$learningLevels = @('introductory', 'beginner', 'intermediate', 'advanced')

# Function to calculate role modifier
function Get-RoleModifier {
    param (
        [string]$SkillLevel
    )
    switch ($SkillLevel.ToLower()) {
        'training' { return 3.125 }
        'strategic' { return 1.5625 }
        'leadership' { return 1.3333 }
        'tactical' { return 0.75 }
        'admin' { return 0.5 }
        default { return 1 }
    }
}

# Function to calculate level modifier
function Get-LevelModifier {
    param (
        [string]$Level
    )
    switch ($Level.ToLower()) {
        'introductory' { return 0.7 }
        'beginner' { return 0.8 }
        'intermediate' { return 0.9 }
        'advanced' { return 1 }
        default { return -1 }
    }
}

# Function to calculate student graduated fee
function Calculate-StudentGraduatedFee {
    param (
        [int]$StudentsChargable,
        [decimal]$RateStudentDay,
        [int]$Days
    )
    $studentFee = 0
    $baseStudentDayModifier = 2
    for ($i = 1; $i -le $StudentsChargable; $i++) {
        $baseStudentDayRate = ((($baseStudentDayModifier * 2) / 10) + 1) * $RateStudentDay
        $studentFee += ($baseStudentDayRate * $Days)
        if ($i % 6 -eq 0) {
            $baseStudentDayModifier++
        }
    }
    return $studentFee
}

# Loop through all combinations of scope and rate modifier
$output = @{}
foreach ($scope in $scopes) {
    $scopeData = @{}
    foreach ($learningLevel in $learningLevels) {
        # Base parameters
        $baseRate = 275
        $hours = 8
        $travelDays = 1
        $baseDays = [math]::Ceiling($hours / 8)
        $baseRateDay = $baseRate * 8

        # Calculate level modifier
        $levelModifier = Get-LevelModifier -Level $learningLevel

        # Calculate total price
        $total = $baseRateDay * $baseDays * $levelModifier

        # Add learning level to scope data
        $scopeData[$learningLevel] = [PSCustomObject]@{
            TotalPrice = [math]::Round($total, 2)
        }
    }
    $output[$scope] = $scopeData
}




# Convert the output to JSON and save to a file
$output | ConvertTo-Json -Depth 5 | Set-Content -Path 'site/data/coursePrices.json'


Write-Output "JSON file 'coursePrices.json' has been generated in 'site/data' with pre-calculated fees."
