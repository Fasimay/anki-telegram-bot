$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$jdkHome = "C:\Program Files\Java\jdk-21"
$env:UV_CACHE_DIR = Join-Path $projectRoot "anki-service\.uv-cache"

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "uv is not available in PATH."
}
if (-not (Test-Path -LiteralPath (Join-Path $jdkHome "bin\java.exe"))) {
    throw "JDK 21 is not installed at $jdkHome"
}

Push-Location (Join-Path $projectRoot "anki-service")
try {
    uv sync --locked --inexact
    if ($LASTEXITCODE -ne 0) {
        throw "Python environment setup failed."
    }

    $venvPython = Join-Path $projectRoot "anki-service\.venv\Scripts\python.exe"
    & $venvPython -m pip --version *> $null
    if ($LASTEXITCODE -ne 0) {
        & $venvPython -m ensurepip --upgrade
        if ($LASTEXITCODE -ne 0) {
            throw "Unable to add pip required by IntelliJ IDEA."
        }
    }
}
finally {
    Pop-Location
}

$env:JAVA_HOME = $jdkHome
$env:PATH = "$jdkHome\bin;$env:PATH"
Push-Location (Join-Path $projectRoot "bot-service")
try {
    & ".\mvnw.cmd" --version
    if ($LASTEXITCODE -ne 0) {
        throw "Maven Wrapper setup failed."
    }
}
finally {
    Pop-Location
}

Write-Output "Local development environment is ready."
