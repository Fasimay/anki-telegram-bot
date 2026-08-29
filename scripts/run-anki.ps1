$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$env:UV_CACHE_DIR = Join-Path $projectRoot "anki-service\.uv-cache"
Push-Location (Join-Path $projectRoot "anki-service")
try {
    uv run anki-service
}
finally {
    Pop-Location
}
