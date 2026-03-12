[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$InputFiles,

    [string]$SchemaPath,
    [switch]$WellFormedOnly,
    [switch]$VerboseOutput,
    [string]$ValBuddyPath
)

$args = @()
$args += $(if ($WellFormedOnly) { '-wf' } else { '-v' })
if ($VerboseOutput) { $args += '-verbose' }
if ($SchemaPath) {
    $args += '-s'
    $args += $SchemaPath
}
$args += $InputFiles

$invokeScript = Join-Path $PSScriptRoot 'invoke-valbuddy.ps1'
& $invokeScript -Arguments $args -ValBuddyPath $ValBuddyPath
exit $LASTEXITCODE
