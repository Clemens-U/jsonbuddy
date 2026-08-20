[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SettingsXml,

    [string]$ValBuddyPath
)

$args = @($SettingsXml)
$invokeScript = Join-Path $PSScriptRoot 'invoke-valbuddy.ps1'
& $invokeScript -Arguments $args -ValBuddyPath $ValBuddyPath
exit $LASTEXITCODE
