$ErrorActionPreference = 'Stop'
$baseUrl = 'http://localhost:8080'
$requestsPerScenario = 10
$warmups = 2
$page = 225
$size = 40
$lastId = 9000

$health = Invoke-RestMethod "$baseUrl/actuator/health"
if ($health.status -ne 'UP') { throw 'Backend health is not UP.' }

$resultsDir = Join-Path $PSScriptRoot 'results'
New-Item -ItemType Directory -Force -Path $resultsDir | Out-Null
$output = Join-Path $resultsDir 'baseline.csv'
$rows = @()

function Measure-Endpoint {
    param([string]$Name, [string]$Url)
    Write-Host "`n=== $Name ==="
    1..$warmups | ForEach-Object { Invoke-RestMethod $Url | Out-Null }
    $times = @()
    1..$requestsPerScenario | ForEach-Object {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Invoke-RestMethod $Url | Out-Null
        $sw.Stop()
        $times += $sw.Elapsed.TotalMilliseconds
        Write-Host ("Request {0}: {1:N2} ms" -f $_, $sw.Elapsed.TotalMilliseconds)
    }
    $sorted = $times | Sort-Object
    $avg = ($times | Measure-Object -Average).Average
    $p50 = $sorted[[Math]::Floor(($sorted.Count - 1) * 0.50)]
    $p95 = $sorted[[Math]::Floor(($sorted.Count - 1) * 0.95)]
    $rows += [PSCustomObject]@{ timestamp=(Get-Date).ToString('o'); scenario=$Name; requests=$requestsPerScenario; average_ms=[math]::Round($avg,2); p50_ms=[math]::Round($p50,2); p95_ms=[math]::Round($p95,2); min_ms=[math]::Round($sorted[0],2); max_ms=[math]::Round($sorted[-1],2) }
}

Measure-Endpoint 'offset-page-225' "$baseUrl/api/products?page=$page&size=$size"
Measure-Endpoint 'cursor-lastId-9000' "$baseUrl/api/products/cursor?lastId=$lastId&size=$size"

$rows | Export-Csv -NoTypeInformation -Path $output
Write-Host "`nBaseline complete: $output"
$rows | Format-Table scenario,average_ms,p50_ms,p95_ms,min_ms,max_ms
