. ./.powershell/_includes/CleanupDataFiles.ps1

if ($env:ACTIONS_STEP_DEBUG -eq "true") {
    $levelSwitch.MinimumLevel = 'Debug'
}
else {
    $levelSwitch.MinimumLevel = 'Information'
}
$deletedCount = Delete-LocalDataFiles -LocalPath "public"