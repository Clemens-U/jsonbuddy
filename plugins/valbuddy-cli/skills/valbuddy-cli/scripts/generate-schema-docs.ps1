[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SchemaPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputHtml,

    [switch]$Offline,
    [string]$ValBuddyPath
)

$arguments = @('-jsdoc', '-o', $OutputHtml, $SchemaPath)

$invokeScript = Join-Path $PSScriptRoot 'invoke-valbuddy.ps1'
& $invokeScript -Arguments $arguments -Offline:$Offline -ValBuddyPath $ValBuddyPath
exit $LASTEXITCODE
