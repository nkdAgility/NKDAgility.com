# Ensure PowerShell-YAML module is available
if (-not (Get-Module -ListAvailable -Name PoShLog)) {
    Install-Module -Name PoShLog -Force -Scope CurrentUser
    Import-Module -Name PoShLog
}
else {
    Import-Module -Name PoShLog
}

If (-not $levelSwitch) {
    $levelSwitch = New-LevelSwitch -MinimumLevel Verbose
    # Create new logger
    # This is where you customize, when and how to log
    New-Logger |
    Set-MinimumLevel -ControlledBy $levelSwitch | # You can change this value later to filter log messages
    # Here you can add as many sinks as you want - see https://github.com/PoShLog/PoShLog/wiki/Sinks for all available sinks
    Add-SinkPowerShell |   # Tell logger to write log messages to console 
    #Add-SinkConsole |     # Tell logger to write log messages to console
    #Add-SinkFile -Path './logs/.log' | # Tell logger to write log messages into file
    Start-Logger
    Write-InfoLog "New Logger Started" 
}
Write-InfoLog "LoggingHelper.ps1 loaded" 