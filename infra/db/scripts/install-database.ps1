param(
    [string]$ContainerService = "postgres",
    [string]$ContainerName = "hotel_system_container",
    [string]$DbName = "hotel_system",
    [string]$DbUser = "hotel_system_user",
    [string]$AppUser = "ariel5253",
    [string]$AppPassword = "ariel5253"
)

$ErrorActionPreference = "Stop"
$scriptPath = $PSScriptRoot
if (-not $scriptPath) {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

$projectRoot = Split-Path (Split-Path (Split-Path $scriptPath -Parent) -Parent) -Parent
$dockerComposePath = Join-Path $projectRoot "docker-compose.yml"

function Write-Status {
    param(
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Host $Message -ForegroundColor $Color
}

function Wait-For-Container {
    param(
        [string]$Name,
        [int]$MaxRetries = 30,
        [int]$DelaySeconds = 2
    )

    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        $status = docker ps --filter "name=$Name" --format "{{.Status}}"
        if ($status -match "healthy|Up") {
            return $true
        }

        Start-Sleep -Seconds $DelaySeconds
    }

    return $false
}

Write-Status "================================================" "Green"
Write-Status "Hotel System Bootstrap" "Green"
Write-Status "================================================" "Green"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Status "ERROR: Docker command not found" "Red"
    exit 1
}

if (-not (Test-Path $dockerComposePath)) {
    Write-Status "ERROR: docker-compose.yml not found at: $dockerComposePath" "Red"
    exit 1
}

Write-Status "Starting PostgreSQL service..." "Yellow"
Push-Location $projectRoot
try {
    docker-compose up -d --force-recreate $ContainerService
} catch {
    Write-Status "ERROR: Failed to start PostgreSQL service: $($_.Exception.Message)" "Red"
    exit 1
} finally {
    Pop-Location
}

Write-Status "Waiting for PostgreSQL container to be ready..." "Yellow"
if (-not (Wait-For-Container -Name "$ContainerName-$ContainerService-1")) {
    Write-Status "ERROR: PostgreSQL did not become ready in time" "Red"
    exit 1
}

$bootstrapSql = @'
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ariel5253') THEN
        CREATE ROLE ariel5253 LOGIN PASSWORD 'ariel5253';
    ELSE
        ALTER ROLE ariel5253 WITH LOGIN PASSWORD 'ariel5253';
    END IF;
END
$$;

ALTER ROLE ariel5253 NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT CONNECT ON DATABASE hotel_system TO ariel5253;
GRANT USAGE, CREATE ON SCHEMA public TO ariel5253;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ariel5253;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO ariel5253;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ariel5253;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO ariel5253;
ALTER ROLE ariel5253 SET search_path = public;
'@

Write-Status "Provisioning application credentials..." "Yellow"
try {
    $bootstrapSql | docker exec -i "$ContainerName-$ContainerService-1" psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1
} catch {
    Write-Status "ERROR: Failed to provision credentials: $($_.Exception.Message)" "Red"
    exit 1
}

Write-Status "Validating login for bootstrap admin (hotel_system_user)..." "Yellow"
try {
    docker exec "$ContainerName-$ContainerService-1" psql -U $DbUser -d $DbName -c "SELECT current_user, current_database();"
} catch {
    Write-Status "ERROR: Login validation failed for $DbUser" "Red"
    exit 1
}

Write-Status "Validating login for ariel5253..." "Yellow"
try {
    docker exec -e PGPASSWORD=$AppPassword "$ContainerName-$ContainerService-1" psql -U $AppUser -d $DbName -c "SELECT current_user, current_database();"
} catch {
    Write-Status "ERROR: Login validation failed for $AppUser" "Red"
    exit 1
}

Write-Status "" "White"
Write-Status "Installation completed successfully" "Green"
Write-Status "Connect with:" "Cyan"
Write-Status "docker exec -it ${ContainerName}-${ContainerService}-1 psql -U $AppUser -d $DbName" "Green"
Write-Status "Admin login: docker exec -it ${ContainerName}-${ContainerService}-1 psql -U $DbUser -d $DbName" "Green"
Write-Status "" "White"
