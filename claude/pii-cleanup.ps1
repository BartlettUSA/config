# PII Cleanup Script - Remove email addresses and genericize "Bartlett USA" references
# Preserves GitHub URLs (https://github.com/BartlettUSA/*)

$ErrorActionPreference = "Continue"

# Email patterns to replace
$emailPatterns = @(
    @{Pattern='ops@bartlettusa\.com'; Replace='the repository maintainer'},
    @{Pattern='dev@bartlettusa\.com'; Replace='the repository maintainer'},
    @{Pattern='legal@bartlettusa\.com'; Replace='the repository maintainer'},
    @{Pattern='lbartpe@bartlettusa\.com'; Replace='the repository maintainer'}
)

# Text patterns to replace (excluding GitHub URLs)
$textPatterns = @(
    @{Pattern='(?<!github\.com/)Bartlett USA'; Replace='The Software Vendor'},
    @{Pattern='(?<!github\.com/)BartlettUSA(?!/|\.)'; Replace='The Software Vendor'},
    @{Pattern='pypi\.bartlettusa\.internal'; Replace='pypi.internal'}
)

$extensions = @('*.md','*.txt','*.yaml','*.yml','*.toml','*.json','*.py','*.ts','*.tsx','*.rego')
$excludeDirs = @('.git','node_modules','.venv','__pycache__','dist','build')

$totalUpdated = 0

Get-ChildItem -Path 'P:\dev\repos' -Recurse -File -Include $extensions |
    Where-Object {
        $path = $_.FullName
        -not ($excludeDirs | Where-Object { $path -match "[\\/]$_[\\/]" })
    } |
    ForEach-Object {
        $file = $_.FullName
        try {
            $content = Get-Content -Path $file -Raw -ErrorAction Stop
            if ($null -eq $content) { return }

            $original = $content

            # Apply email replacements
            foreach ($p in $emailPatterns) {
                $content = $content -replace $p.Pattern, $p.Replace
            }

            # Apply text replacements
            foreach ($p in $textPatterns) {
                $content = $content -replace $p.Pattern, $p.Replace
            }

            if ($content -ne $original) {
                Set-Content -Path $file -Value $content -NoNewline -ErrorAction Stop
                Write-Host "Updated: $file"
                $script:totalUpdated++
            }
        }
        catch {
            Write-Host "Error processing: $file - $_"
        }
    }

Write-Host "`nTotal files updated: $totalUpdated"
