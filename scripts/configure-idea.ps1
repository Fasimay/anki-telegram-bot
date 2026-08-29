param(
    [string]$IdeaConfigRoot = "$env:APPDATA\JetBrains\IdeaIC2025.2"
)

$ErrorActionPreference = "Stop"

if (Get-Process -Name "idea64" -ErrorAction SilentlyContinue) {
    throw "Close IntelliJ IDEA before running this script."
}

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$pythonExecutable = Join-Path $projectRoot "anki-service\.venv\Scripts\python.exe"
if (-not (Test-Path -LiteralPath $pythonExecutable -PathType Leaf)) {
    throw "Python interpreter not found: $pythonExecutable"
}

$sdkTablePath = Join-Path $IdeaConfigRoot "options\jdk.table.xml"
$librariesPath = Join-Path $IdeaConfigRoot "options\applicationLibraries.xml"
if (-not (Test-Path -LiteralPath $sdkTablePath -PathType Leaf)) {
    throw "IDEA SDK table not found: $sdkTablePath"
}

$backupSuffix = ".codex-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
Copy-Item -LiteralPath $sdkTablePath -Destination ($sdkTablePath + $backupSuffix)
if (Test-Path -LiteralPath $librariesPath -PathType Leaf) {
    Copy-Item -LiteralPath $librariesPath -Destination ($librariesPath + $backupSuffix)
}

function Save-XmlDocument {
    param(
        [xml]$Document,
        [string]$Path
    )

    $settings = [System.Xml.XmlWriterSettings]::new()
    $settings.Indent = $true
    $settings.OmitXmlDeclaration = $true
    $settings.Encoding = [System.Text.UTF8Encoding]::new($false)
    $writer = [System.Xml.XmlWriter]::Create($Path, $settings)
    try {
        $Document.Save($writer)
    }
    finally {
        $writer.Dispose()
    }
}

function Replace-RootNodes {
    param(
        [xml]$Document,
        [System.Xml.XmlElement]$Parent,
        [string[]]$Urls
    )

    while ($Parent.HasChildNodes) {
        $null = $Parent.RemoveChild($Parent.FirstChild)
    }
    foreach ($url in $Urls) {
        $root = $Document.CreateElement("root")
        $root.SetAttribute("url", $url)
        $root.SetAttribute("type", "simple")
        $null = $Parent.AppendChild($root)
    }
}

[xml]$sdkDocument = Get-Content -LiteralPath $sdkTablePath -Raw
$pythonSdk = @($sdkDocument.application.component.jdk) |
    Where-Object { $_.type.value -eq "Python SDK" } |
    Select-Object -First 1
if ($null -eq $pythonSdk) {
    throw "No Python SDK entry exists in IDEA. Add any Python SDK once, then rerun."
}

$pythonSdk.SelectSingleNode("./name").SetAttribute("value", "Python 3.12 (anki-service)")
$pythonSdk.SelectSingleNode("./version").SetAttribute("value", "Python 3.12.14")
$pythonSdk.SelectSingleNode("./homePath").SetAttribute(
    "value",
    '$USER_HOME$/Documents/anki-telegram-bot/anki-service/.venv/Scripts/python.exe'
)

$pythonClassPaths = @(
    'file://$USER_HOME$/AppData/Roaming/uv/python/cpython-3.12-windows-x86_64-none/DLLs',
    'file://$USER_HOME$/AppData/Roaming/uv/python/cpython-3.12-windows-x86_64-none/Lib',
    'file://$USER_HOME$/AppData/Roaming/uv/python/cpython-3.12-windows-x86_64-none',
    'file://$USER_HOME$/Documents/anki-telegram-bot/anki-service/.venv/Lib/site-packages',
    'file://$USER_HOME$/AppData/Local/JetBrains/IdeaIC2025.2/python_stubs/1707616949',
    'file://$APPLICATION_PLUGINS_DIR$/python-ce/helpers/typeshed/stdlib'
)

$classPathRoot = $pythonSdk.SelectSingleNode("./roots/classPath/root")
Replace-RootNodes -Document $sdkDocument -Parent $classPathRoot -Urls $pythonClassPaths
Save-XmlDocument -Document $sdkDocument -Path $sdkTablePath

if (Test-Path -LiteralPath $librariesPath -PathType Leaf) {
    [xml]$librariesDocument = Get-Content -LiteralPath $librariesPath -Raw
    $pythonLibrary = @($librariesDocument.application.component.library) |
        Where-Object { $_.name -like "Python 3.12*interpreter library" } |
        Select-Object -First 1
    if ($null -ne $pythonLibrary) {
        $pythonLibrary.SetAttribute("name", "Python 3.12 (anki-service) interpreter library")
        foreach ($sectionName in @("CLASSES", "SOURCES")) {
            $section = $pythonLibrary.SelectSingleNode("./$sectionName")
            while ($section.HasChildNodes) {
                $null = $section.RemoveChild($section.FirstChild)
            }
            foreach ($url in $pythonClassPaths) {
                $root = $librariesDocument.CreateElement("root")
                $root.SetAttribute("url", $url)
                $null = $section.AppendChild($root)
            }
        }
        Save-XmlDocument -Document $librariesDocument -Path $librariesPath
    }
}

Write-Output "IDEA Python SDK configured: $pythonExecutable"
Write-Output "Backups use suffix: $backupSuffix"
