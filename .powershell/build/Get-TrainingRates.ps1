# Define types, scopes, modes, and ratemodifiers
$types = @('training')
$scopes = @('private', 'public')
$modes = @('public', 'direct', 'reseller', 'peer', 'cotrainer')
$rateModifiers = @('none', 'Introductory', 'Beginner', 'Intermediate', 'Advanced')

# Define rates and constants
$baseRate = 210 # GBP/hour for training
$baseRateStudentDay = 125 # GBP/student/day
$BaseRateCoursewareDay = 75 # GBP/student/day

# Function to calculate the base rate based on the ratemodifier
function Get-ModifiedRate($baseRate, $rateModifier) {
    switch ($rateModifier.ToLower()) {
        'advanced' { return $baseRate * 1.5 }
        'intermediate' { return $baseRate * 1.25 }
        'introductory' { return $baseRate * 0.75 }
        default { return $baseRate }
    }
}

# Function to calculate student fees
function Calculate-StudentFee($students, $rateStudentDay, $days) {
    $studentFee = 0
    if ($students -gt 0) {
        $baseStudentDayModifier = 2
        for ($i = 1; $i -le $students; $i++) {
            $baseStudentDayRate = ((($baseStudentDayModifier * 2) / 10) + 1) * $rateStudentDay
            $studentFee += ($baseStudentDayRate * $days)
            if ($i % 6 -eq 0) {
                $baseStudentDayModifier++
            }
        }
    }
    return $studentFee
}

# Hashtable to hold the combinations and results
$results = @{}

# Loop through each combination and calculate the output
foreach ($type in $types) {
    foreach ($scope in $scopes) {
        if (-not $results.ContainsKey($scope)) {
            $results[$scope] = @{}
        }
        foreach ($rateModifier in $rateModifiers) {
            if (-not $results[$scope].ContainsKey($rateModifier)) {
                $results[$scope][$rateModifier] = @()
            }
            foreach ($mode in $modes) {
                # Calculate the modified base rate
                $modifiedRate = Get-ModifiedRate -baseRate $baseRate -rateModifier $rateModifier
                $baseRateTrainingDay = $modifiedRate * 8
                $baseDays = 8 / 8 # Assume 8 hours per day
                
                # Trainer Fee Calculation
                $trainerTotal = $baseRateTrainingDay * $baseDays
                if ($mode -ne 'remote') {
                    $trainerTotal += ($baseRateTrainingDay * 1) # Assuming 1 travel day
                }
                
                # Mode-specific modification
                switch ($mode.ToLower()) {
                    'public' { $trainerTotal = (($baseRateTrainingDay / 8) * $baseDays) * 0.75 }
                    'reseller' { $trainerTotal *= 0.75 }
                    'peer' { $trainerTotal *= 0.7 }
                    'cotrainer' { $trainerTotal *= 0.4 }
                }
                
                # Courseware Fee Calculation
                $coursewareTotal = 0
                $students = 12 # Assuming 12 students
                if ($scope -eq 'private' -and $students -gt 10) {
                    $coursewareTotal = 10 * ($BaseRateCoursewareDay * $baseDays)
                }
                else {
                    $coursewareTotal = $students * ($BaseRateCoursewareDay * $baseDays)
                }
                
                # Student Fee Calculation
                $studentsChargable = if ($students -gt 12) { $students - 12 } else { 0 }
                $studentFee = Calculate-StudentFee -students $studentsChargable -rateStudentDay $baseRateStudentDay -days $baseDays
                
                # Additional Trainer Fee Calculation
                $additionalTrainerFee = 0
                if ($scope -eq 'public' -and $students -gt 20) {
                    $additionalTrainerFee = ($modifiedRate * 8 * $baseDays)
                }
                
                # Total Calculation
                $outTotal = $trainerTotal + $coursewareTotal + $studentFee + $additionalTrainerFee
                
                # Add result to the hashtable
                $results[$scope][$rateModifier] += [PSCustomObject]@{
                    Type                 = $type
                    Mode                 = $mode
                    TrainerTotal         = [math]::Round($trainerTotal, 2)
                    CoursewareTotal      = [math]::Round($coursewareTotal, 2)
                    StudentFee           = [math]::Round($studentFee, 2)
                    AdditionalTrainerFee = [math]::Round($additionalTrainerFee, 2)
                    Total                = [math]::Round($outTotal, 2)
                }
            }
        }
    }
}

# Convert results to JSON and output to file
$jsonOutput = $results | ConvertTo-Json -Depth 4
Set-Content -Path "site\data\training_combinations.json" -Value $jsonOutput

Write-Output "JSON file with training combinations and calculated values has been generated."
