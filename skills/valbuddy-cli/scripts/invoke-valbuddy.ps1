[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$Arguments,

    [string]$ValBuddyPath
)

function Resolve-ValBuddyPath {
    param([string]$ExplicitPath)

    if ($ExplicitPath) {
        if (Test-Path -LiteralPath $ExplicitPath) { return $ExplicitPath }
        throw "valbuddy.exe not found at explicit path: $ExplicitPath"
    }

    if ($env:VALBUDDY_EXE -and (Test-Path -LiteralPath $env:VALBUDDY_EXE)) {
        return $env:VALBUDDY_EXE
    }

    $cmd = Get-Command valbuddy.exe -ErrorAction SilentlyContinue
    if ($cmd -and $cmd.Source) {
        return $cmd.Source
    }

    $candidates = @(
        (Join-Path $env:ProgramFiles 'XML ValidatorBuddy\valbuddy.exe'),
        (Join-Path $env:ProgramFiles 'JSONBuddy\valbuddy.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'XML ValidatorBuddy\valbuddy.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'JSONBuddy\valbuddy.exe')
    )

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    throw 'Unable to locate valbuddy.exe. Pass -ValBuddyPath or set VALBUDDY_EXE.'
}

$exe = Resolve-ValBuddyPath -ExplicitPath $ValBuddyPath
& $exe @Arguments
exit $LASTEXITCODE
