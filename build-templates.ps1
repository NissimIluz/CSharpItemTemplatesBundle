$root = "$PSScriptRoot"
$output = Join-Path $root "dist"

if (Test-Path $output) {
    Remove-Item $output -Recurse -Force
}
New-Item -ItemType Directory -Path $output | Out-Null

function Create-TemplateZip($name, $csContent, $defaultName) {
    $tempFolder = Join-Path $root "tmp_$name"

    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force
    }

    New-Item -ItemType Directory -Path $tempFolder | Out-Null

    $csFile = "$name.cs"
    $vstemplateFile = "$name.vstemplate"

    # CS file
    $csPath = Join-Path $tempFolder $csFile
    Set-Content -Path $csPath -Value $csContent -Encoding UTF8

    # vstemplate
    $vstemplate = @"
<VSTemplate Version="3.0.0" Type="Item"
 xmlns="http://schemas.microsoft.com/developer/vstemplate/2005">
  <TemplateData>
    <Name>$name</Name>
    <Description>$name template</Description>
    <ProjectType>CSharp</ProjectType>
    <DefaultName>$defaultName</DefaultName>
    <SortOrder>10</SortOrder>
  </TemplateData>
  <TemplateContent>
    <ProjectItem ReplaceParameters="true">$csFile</ProjectItem>
  </TemplateContent>
</VSTemplate>
"@

    $vstemplatePath = Join-Path $tempFolder $vstemplateFile
    Set-Content -Path $vstemplatePath -Value $vstemplate -Encoding UTF8

    # zip
    $zipPath = Join-Path $output "$name.zip"
    Compress-Archive -Path "$tempFolder\*" -DestinationPath $zipPath -Force

    Remove-Item $tempFolder -Recurse -Force
}

# ===== Templates =====

Create-TemplateZip "Class" @"
namespace `$rootnamespace$;

public class `$safeitemname$
{
}
"@ "MyClass.cs"

Create-TemplateZip "Interface" @"
namespace `$rootnamespace$;

public interface `$safeitemname$
{
}
"@ "IMyInterface.cs"

Create-TemplateZip "Enum" @"
namespace `$rootnamespace$;

public enum `$safeitemname$
{
}
"@ "MyEnum.cs"

Create-TemplateZip "Record" @"
namespace `$rootnamespace$;

public record `$safeitemname$
{
}
"@ "MyRecord.cs"

Write-Host "Templates created in /dist 🚀"