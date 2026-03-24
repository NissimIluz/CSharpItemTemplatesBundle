C# Item Templates Bundle

Included templates:
- Class
- Interface
- Enum
- Record

Installation:
1. Close Visual Studio.
2. Copy the .zip template files into your Visual Studio ItemTemplates folder, for example:
   Documents\Visual Studio 18\Templates\ItemTemplates\Visual C#\
3. Reopen Visual Studio.
4. If needed, run:
   devenv /installvstemplates

Each template uses:
- namespace $rootnamespace$;
- public <type> $safeitemname$

You can also keep the templates inside subfolders if you prefer.

Scripts for PowerShell:
# Create
.\build-templates.ps1

# Deploy & Installation
.\install-templates.ps1

# Installation only (if devenv is not recognized)
Documents\Visual Studio 18\Templates\ItemTemplates\Visual C#>"C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"  /installvstemplates
