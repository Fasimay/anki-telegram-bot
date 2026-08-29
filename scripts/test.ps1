$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$jdkHome = "C:\Program Files\Java\jdk-21"
$env:UV_CACHE_DIR = Join-Path $projectRoot "anki-service\.uv-cache"

Push-Location (Join-Path $projectRoot "anki-service")
try {
    uv run pytest
    if ($LASTEXITCODE -ne 0) {
        throw "Python tests failed."
    }
}
finally {
    Pop-Location
}

$env:JAVA_HOME = $jdkHome
$env:PATH = "$jdkHome\bin;$env:PATH"
Push-Location (Join-Path $projectRoot "bot-service")
try {
    & ".\mvnw.cmd" test
    if ($LASTEXITCODE -ne 0) {
        throw "Java tests failed."
    }
}
finally {
    Pop-Location
}
