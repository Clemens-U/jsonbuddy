[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('pretty', 'minify')]
    [string]$Mode,

    [Parameter(Mandatory = $true)]
    [string]$InputJson,

    [string]$OutputJson,
    [switch]$Offline,
    [string]$ValBuddyPath
)

$args = @()
$args += $(if ($Mode -eq 'pretty') { '-jspp' } else { '-jsm' })
if ($OutputJson) {
    $args += '-oj'
    $args += $OutputJson
}
$args += $InputJson

$invokeScript = Join-Path $PSScriptRoot 'invoke-valbuddy.ps1'
& $invokeScript -Arguments $args -Offline:$Offline -ValBuddyPath $ValBuddyPath
exit $LASTEXITCODE
