[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SettingsXml,

    [switch]$Offline,
    [string]$ValBuddyPath
)

$args = @($SettingsXml)
$invokeScript = Join-Path $PSScriptRoot 'invoke-valbuddy.ps1'
& $invokeScript -Arguments $args -Offline:$Offline -ValBuddyPath $ValBuddyPath
exit $LASTEXITCODE
