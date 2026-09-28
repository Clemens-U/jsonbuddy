[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ValBuddyPath
)

$ErrorActionPreference = 'Stop'
$scriptsRoot = Join-Path $PSScriptRoot '..\skills\valbuddy-cli\scripts'
$ValBuddyPath = (Resolve-Path -LiteralPath $ValBuddyPath).Path

if (-not ('ValBuddyPluginTests.RecordingServer' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace ValBuddyPluginTests {
    public sealed class RecordingServer : IDisposable {
        private TcpListener listener;
        private Thread thread;
        private volatile bool stopping;
        private int count;
        public int Port { get; private set; }
        public int Count { get { return Interlocked.CompareExchange(ref count, 0, 0); } }
        public void Start() {
            listener = new TcpListener(IPAddress.Loopback, 0);
            listener.Start();
            Port = ((IPEndPoint)listener.LocalEndpoint).Port;
            thread = new Thread(Run); thread.IsBackground = true; thread.Start();
        }
        private void Run() {
            while (!stopping) {
                try {
                    using (TcpClient client = listener.AcceptTcpClient()) {
                        Interlocked.Increment(ref count);
                        byte[] data = Encoding.ASCII.GetBytes("HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n");
                        try { client.GetStream().Write(data, 0, data.Length); } catch { }
                    }
                } catch (SocketException) { if (!stopping) throw; }
                catch (ObjectDisposedException) { if (!stopping) throw; }
            }
        }
        public void Dispose() {
            stopping = true;
            if (listener != null) listener.Stop();
            if (thread != null) thread.Join(2000);
        }
    }
}
'@
}

function Quote-PS([string]$Value) { "'" + $Value.Replace("'", "''") + "'" }

function Invoke-IsolatedPowerShell {
    param([string]$Command)
    $caller = Join-Path ([IO.Path]::GetTempPath()) ("valbuddy-wrapper-" + [Guid]::NewGuid().ToString('N') + '.ps1')
    try {
        [IO.File]::WriteAllText($caller, $Command, [Text.UTF8Encoding]::new($false))
        $start = [Diagnostics.ProcessStartInfo]::new()
        $start.FileName = 'powershell.exe'
        $start.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$caller`""
        $start.UseShellExecute = $false
        $start.RedirectStandardOutput = $true
        $start.RedirectStandardError = $true
        $process = [Diagnostics.Process]::Start($start)
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        [pscustomobject]@{ ExitCode = $process.ExitCode; Output = $stdout + $stderr }
    }
    finally {
        Remove-Item -LiteralPath $caller -Force -ErrorAction SilentlyContinue
    }
}

$server = [ValBuddyPluginTests.RecordingServer]::new()
$server.Start()
$uri = "http://127.0.0.1:$($server.Port)/blocked.json"
$failures = 0

try {
    $cases = @(
        @{ Name = 'generic'; Script = 'invoke-valbuddy.ps1'; Parameters = "-Offline -Arguments @('-v', $(Quote-PS $uri))" },
        @{ Name = 'validate-json'; Script = 'validate-json.ps1'; Parameters = "-Offline -InputFiles $(Quote-PS $uri)" },
        @{ Name = 'validate-xml'; Script = 'validate-xml.ps1'; Parameters = "-Offline -InputFiles $(Quote-PS $uri)" },
        @{ Name = 'generate-schema-docs'; Script = 'generate-schema-docs.ps1'; Parameters = "-Offline -SchemaPath $(Quote-PS $uri) -OutputHtml $(Quote-PS (Join-Path $env:TEMP 'offline-doc.html'))" },
        @{ Name = 'run-settings'; Script = 'run-settings.ps1'; Parameters = "-Offline -SettingsXml $(Quote-PS $uri)" },
        @{ Name = 'format-json'; Script = 'format-json.ps1'; Parameters = "-Offline -Mode minify -InputJson $(Quote-PS $uri)" }
    )

    foreach ($case in $cases) {
        $scriptPath = Join-Path $scriptsRoot $case.Script
        $command = "& $(Quote-PS $scriptPath) $($case.Parameters) -ValBuddyPath $(Quote-PS $ValBuddyPath); exit `$LASTEXITCODE"
        $result = Invoke-IsolatedPowerShell $command
        $ok = ($result.ExitCode -eq 12) -and ($result.Output -match '(?i)offline mode') -and $result.Output.Contains($uri)
        if ($ok) { Write-Host "PASS $($case.Name) forwards -Offline" }
        else {
            $failures++
            Write-Host "FAIL $($case.Name) exit=$($result.ExitCode) output=$($result.Output)"
        }
    }

    foreach ($file in Get-ChildItem -LiteralPath $scriptsRoot -Filter '*.ps1') {
        $hasParameter = (Get-Command -Name $file.FullName).Parameters.ContainsKey('Offline')
        if ($hasParameter) { Write-Host "PASS $($file.Name) help exposes -Offline" }
        else { $failures++; Write-Host "FAIL $($file.Name) omits -Offline" }
    }

    if ($server.Count -eq 0) { Write-Host 'PASS wrapper offline request count is zero' }
    else { $failures++; Write-Host "FAIL wrapper recorder observed $($server.Count) request(s)" }
    Write-Host "WRAPPER_OFFLINE_HTTP_REQUESTS=$($server.Count)"
}
finally {
    $server.Dispose()
}

if ($failures -ne 0) { exit 1 }
