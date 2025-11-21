#!/usr/bin/env pwsh

# Build the Zola site
Write-Host "Building Zola site..." -ForegroundColor Cyan
zola build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Zola build failed!" -ForegroundColor Red
    exit 1
}

function Get-FrontmatterValue {
    param(
        [string]$MarkdownPath,
        [string]$Key
    )

    if (-not (Test-Path $MarkdownPath)) {
        return $null
    }

    $content = Get-Content $MarkdownPath -Raw

    if ($content -match '(?s)\+\+\+(.*?)\+\+\+') {
        $frontmatter = $matches[1]

        # Try quoted values first
        if ($frontmatter -match "$Key\s*=\s*[`"'](.+?)[`"']") {
            return $matches[1]
        }
        # Then unquoted values
        if ($frontmatter -match "$Key\s*=\s*(\S+)") {
            return $matches[1]
        }
    }

    return $null
}

Write-Host "Processing walkthroughs..." -ForegroundColor Cyan

# Get all markdown files in the source directory
$mdFiles = Get-ChildItem -Path "content/walkthrough/*.md" -Exclude "_index.md" -ErrorAction SilentlyContinue

if ($mdFiles.Count -eq 0) {
    Write-Host "No markdown files found in content/walkthrough/" -ForegroundColor Yellow
    exit 0
}

$currentDate = Get-Date

foreach ($mdFile in $mdFiles) {
    # The HTML file will be at public/walkthrough/{basename}/index.html
    echo $mdFile.BaseName
    $htmlFile = "public/walkthrough/$($mdFile.BaseName)/index.html"

    if (-not (Test-Path $htmlFile)) {
        Write-Host "Warning: Expected HTML not found at $htmlFile" -ForegroundColor Yellow
        continue
    }

    # Check if protected
    $isProtected = Get-FrontmatterValue -MarkdownPath $mdFile.FullName -Key "protected"

    if ($isProtected -eq "true") {
        # Check retirement date
        $retiredDateStr = Get-FrontmatterValue -MarkdownPath $mdFile.FullName -Key "retired_date"

        if ($retiredDateStr) {
            try {
                $retiredDate = [DateTime]::Parse($retiredDateStr)

                if ($currentDate -ge $retiredDate) {
                    Write-Host "Skipping: $($mdFile.BaseName) (already retired on $retiredDateStr)" -ForegroundColor Cyan
                    continue
                }
            } catch {
                Write-Host "Warning: Invalid date format for $($mdFile.BaseName): $retiredDateStr" -ForegroundColor Yellow
            }
        }

        # Get password
        $password = Get-FrontmatterValue -MarkdownPath $mdFile.FullName -Key "password"

        if ($password) {
            Write-Host "Encrypting: $($mdFile.BaseName)/index.html" -ForegroundColor Green

            # Optional: Add custom title/instructions
            $title = Get-FrontmatterValue -MarkdownPath $mdFile.FullName -Key "title"
            $instructions = "This machine is still active. Use the flag to show the content."

            staticrypt $htmlFile --password $password `
                --template-title "$title - Protected" `
                --template-instructions $instructions `
                --template-color-secondary "#1F1F1F" `
                --short `
                --directory "public/walkthrough/$($mdFile.BaseName)"

            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to encrypt $($mdFile.BaseName)" -ForegroundColor Red
            }
        } else {
            Write-Host "Warning: $($mdFile.BaseName) marked as protected but no password found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Skipping: $($mdFile.BaseName) (not protected)" -ForegroundColor Gray
    }
}

Write-Host "Done!" -ForegroundColor Green