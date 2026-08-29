$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$jdkHome = "C:\Program Files\Java\jdk-21"
if (-not (Test-Path -LiteralPath (Join-Path $jdkHome "bin\java.exe"))) {
    throw "JDK 21 is not installed at $jdkHome"
}

$env:JAVA_HOME = $jdkHome
$env:PATH = "$jdkHome\bin;$env:PATH"
Push-Location (Join-Path $projectRoot "bot-service")
try {
    & ".\mvnw.cmd" "spring-boot:run"
}
finally {
    Pop-Location
}
