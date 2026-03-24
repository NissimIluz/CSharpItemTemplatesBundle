$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "dist"
$target = Join-Path $env:USERPROFILE "Documents\Visual Studio 18\Templates\ItemTemplates\C#"

Write-Host "==============================="
Write-Host "Source folder: $source"
Write-Host "Target folder: $target"
Write-Host "==============================="

# בדיקה אם source קיים
if (!(Test-Path $source)) {
    Write-Host "ERROR: Source folder not found!"
    exit 1
}

# יצירת תיקיית יעד אם לא קיימת
if (!(Test-Path $target)) {
    Write-Host "Creating target directory..."
    New-Item -ItemType Directory -Path $target -Force | Out-Null
}

# רשימת קבצים להעתקה
$files = Get-ChildItem -Path $source -Filter *.zip

if ($files.Count -eq 0) {
    Write-Host "No zip files found in source."
    exit 0
}

Write-Host "Files to copy:"
$files | ForEach-Object { Write-Host " - $($_.FullName)" }

# העתקה
foreach ($file in $files) {
    $destination = Join-Path $target $file.Name
    Copy-Item $file.FullName -Destination $destination -Force
    Write-Host "Copied: $($file.Name) -> $destination"
}

Write-Host "Templates copied successfully."

# רענון templates
Write-Host "Refreshing Visual Studio templates..."

try {
    & devenv /installvstemplates
    Write-Host "Templates refreshed."
}
catch {
    Write-Host "WARNING: devenv not found or failed."
}

Write-Host "Done."