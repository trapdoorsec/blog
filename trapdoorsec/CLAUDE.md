# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cybersecurity blog built with [Zola](https://www.getzola.org), a static site generator written in Rust. The site uses the [tabi](https://welpo.github.io/tabi) theme and focuses on application security, penetration testing, and security walkthroughs.

Base URL: https://trapdoorsec.com

## Build Commands

### Standard Build
```bash
zola build
```
Generates the static site in the `public/` directory.

### Build with Protected Content
```bash
./build.sh
```
Or on Windows with PowerShell:
```powershell
./build.ps1
```

These scripts:
1. Run `zola build`
2. Process walkthrough markdown files in `content/walkthrough/`
3. For posts marked with `protected = true` in frontmatter, encrypt the generated HTML using `staticrypt`
4. Check `retired_date` frontmatter - only encrypts if current date is before retirement date
5. Use the `password` field from frontmatter for encryption

**Note**: Requires `staticrypt` to be installed for protected content encryption.

### Development Server
```bash
zola serve
```
Starts local development server with live reload (typically at http://127.0.0.1:1111).

### Check Content
```bash
zola check
```
Validates content and internal links.

## Content Structure

### Content Types

1. **Blog Posts** (`content/blog/`)
   - General security articles, commentary, and analysis
   - Sorted by date (configured in `content/blog/_index.md`)

2. **Walkthroughs** (`content/walkthrough/`)
   - HackTheBox and other CTF machine walkthroughs
   - Can be password-protected if machine is still active
   - Automatically un-protected after `retired_date`

3. **Projects** (`content/project/`)
   - Security tools and projects (e.g., DVWAPI)

4. **Archive** (`content/archive/`)
   - Historical content organization

### Frontmatter Schema

**Standard Post:**
```toml
+++
title = "Post Title"
date = "2025-11-27"
[taxonomies]
tags = ["cybersecurity", "appsec"]
[extra]
toc = true  # Enable table of contents
+++
```

**Protected Walkthrough:**
```toml
+++
title = "HTB Walkthrough: MachineName"
date = "2025-11-22"
[taxonomies]
tags = ["cybersecurity", "HTB", "walkthrough", "penetration-testing"]
[extra]
toc = true
protected = true
retired_date = "2025-12-22"  # Date when machine retires
password = "md5_hash_of_flag"  # Used for staticrypt encryption
+++
```

## Theme Configuration

The site uses the **tabi** theme located in `themes/tabi/`. Theme configuration is split between:

- **Root `config.toml`**: Site-specific overrides and content
- **`themes/tabi/config.toml`**: Theme defaults

### Key Configuration Sections

**Navigation Menu** (`config.toml` line 43-48):
```toml
menu = [
    { name = "blog", url = "blog", trailing_slash = true },
    { name = "archive", url = "archive", trailing_slash = true },
    { name = "tags", url = "tags", trailing_slash = true },
    { name = "projects", url = "project", trailing_slash = true },
    { name = "walkthroughs", url = "walkthrough", trailing_slash = true }
]
```

**Git Integration** (`config.toml` line 41-42):
Links to source repository for "view source" functionality.

**Search** (`config.toml` line 23-28):
Configured to use elasticlunr for client-side search.

## Architecture Notes

### Protected Content Workflow

The build scripts (`build.sh` / `build.ps1`) implement a content protection system for active CTF machines:

1. **Detection Phase**: Scans `content/walkthrough/*.md` for `protected = true` frontmatter
2. **Date Validation**: Compares current date against `retired_date` - skips encryption if machine is retired
3. **Encryption Phase**: Uses `staticrypt` to password-protect the HTML with custom styling matching the site theme
4. **Output**: Replaces `public/walkthrough/{basename}/index.html` with encrypted version

This ensures walkthrough content remains hidden until HackTheBox machines are officially retired.

### Content Organization Pattern

- Each section (`blog`, `walkthrough`, `project`, `archive`) has an `_index.md` that configures section behavior
- Blog posts use `sort_by = "date"` to display newest first
- Tags are automatically generated from frontmatter taxonomies
- The theme generates feeds (Atom/RSS) automatically

### Theme Customization

Custom CSS is loaded via `config.toml` line 39:
```toml
stylesheets = ["/css/fontawesome.css", "/css/brands.css", "/css/solid.css"]
```

These files should be placed in `static/css/` (not visible in theme directory, loaded from site root).

## Common Workflows

### Adding a New Blog Post

1. Create `content/blog/your-post-slug.md`
2. Add frontmatter with title, date, and tags
3. Write content in Markdown
4. Build with `zola build` or test with `zola serve`

### Adding a Protected Walkthrough

1. Create `content/walkthrough/machine-name.md`
2. Set frontmatter:
   - `protected = true`
   - `retired_date` = machine retirement date
   - `password` = MD5 hash of user flag or root flag
3. Build with `./build.sh` (or `./build.ps1` on Windows) - requires staticrypt

### Updating Navigation

Edit the `menu` array in `config.toml` (line 43-48). Each entry needs `name`, `url`, and `trailing_slash`.

## Dependencies

- **Zola 0.21.0+**: Static site generator
- **Bash** or **PowerShell**: For build scripts (`build.sh` or `build.ps1`)
- **staticrypt**: For password-protecting walkthroughs (optional, only needed for protected content)

## Git Workflow

The repository tracks:
- All source content (`content/`)
- Configuration (`config.toml`)
- Custom assets (`static/` if present)
- Build scripts (`build.sh`, `build.ps1`)

The `public/` directory is generated and should typically be gitignored, though this repository currently tracks it.
