param(
    [string]$ContainerService = "postgres",
    [string]$ContainerName = "hotel_system_container",
    [string]$DbName = "hotel_system",
    [string]$DbUser = "hotel_system_user",
    [int]$WaitRetries = 30,
    [int]$WaitDelay = 2
)

$ErrorActionPreference = 'Stop'
$scriptPath = $PSScriptRoot
if (-not $scriptPath) { $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path }

function Write-Status {
    param([string]$Message, [string]$Color = 'White')
    Write-Host $Message -ForegroundColor $Color
}

function Wait-For-Container {
    param([string]$Name, [int]$MaxRetries = $WaitRetries, [int]$DelaySeconds = $WaitDelay)
    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        $status = docker ps --filter "name=$Name" --format "{{.Status}}"
        if ($status -match 'healthy|Up') { return $true }
        Start-Sleep -Seconds $DelaySeconds
    }
    return $false
}

Write-Status "Starting seeds load: canonical -> volumetric -> smoke test" "Cyan"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Status "ERROR: Docker command not found" "Red"; exit 1
}

if (-not (Wait-For-Container -Name "$ContainerName-$ContainerService-1")) {
    Write-Status "ERROR: PostgreSQL container not ready" "Red"; exit 1
}

$projectRoot = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent
$seedsDir = Join-Path $projectRoot "infra/db/seeds"
$checksDir = Join-Path $projectRoot "infra/db/checks"

if (-not (Test-Path $seedsDir)) { Write-Status "ERROR: seeds directory not found: $seedsDir" "Red"; exit 1 }
if (-not (Test-Path $checksDir)) { Write-Status "ERROR: checks directory not found: $checksDir" "Red"; exit 1 }

$seedFiles = Get-ChildItem -Path $seedsDir -Filter '*.sql' | Sort-Object Name
$smokeFile = Join-Path $checksDir '001_smoke_test.sql'

if (-not $seedFiles) { Write-Status "No seed files found in $seedsDir" "Red"; exit 1 }
if (-not (Test-Path $smokeFile)) { Write-Status "ERROR: smoke test not found: $smokeFile" "Red"; exit 1 }

try {
    foreach ($f in $seedFiles) {
        Write-Status "Applying seed: $($f.Name)" "Yellow"
        Get-Content -Raw $f.FullName | docker exec -i "$ContainerName-$ContainerService-1" psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1
    }

    Write-Status "Running smoke test..." "Yellow"
    Get-Content -Raw $smokeFile | docker exec -i "$ContainerName-$ContainerService-1" psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1

    Write-Status "Seeds loaded and smoke test passed" "Green"
} catch {
    Write-Status "ERROR: $( ($_.Exception.Message) -replace '\n',' ' )" "Red"
    exit 1
}
