# my-claude-code-setup

Global Claude Code configuration for JavaScript/TypeScript, Golang, and Python projects — with Docker, GCP, and GitHub Actions support.

> *"Do. Or do not. There is no `--dry-run`."* — Yoda, probably
>
> **Warning:** `install.sh` will **replace** your existing `~/.claude/` config files with symlinks to this repo. Existing files are backed up automatically, but you should run the tests first to verify everything works in an isolated environment:
>
> ```bash
> ./test-install.sh   # runs against a temp directory, safe to run anytime
> ./install.sh        # replaces your live config — review the backup location in the output
> ```

## What's Included

### Auto-Formatters (PostToolUse Hooks)

Automatically format files on every save:

| Language | Tool | Trigger |
|----------|------|---------|
| Python | `ruff format` + `ruff check --fix` | `*.py` |
| JS/TS | `prettier --write` | `*.ts, *.tsx, *.js, *.jsx, *.json, *.css` |
| Go | `goimports -w` | `*.go` |

### Linters (PostToolUse Hooks)

Surface lint errors as inline messages on save:

| Target | Tool | Trigger |
|--------|------|---------|
| Dockerfiles | `hadolint` | `Dockerfile*` |
| GitHub Actions | `actionlint` | `.github/workflows/*.yml` |

### Context Management Hook

- **PreCompact** — reminds you to save important context to memory before compaction

### Plugins (10)

| Plugin | Purpose |
|--------|---------|
| superpowers | Skills framework — TDD, plans, debugging, brainstorming |
| github | PR/issue workflows |
| feature-dev | Code architecture, exploration, and review agents |
| claude-md-management | CLAUDE.md auditing and maintenance |
| claude-code-setup | Automation recommendations |
| chrome-devtools-mcp | Browser debugging/automation |
| context7 | Up-to-date library docs lookup |
| claude-mem | Cross-session memory and semantic search |
| visual-explainer | HTML diagrams, slides, project recaps |
| playwright | Browser/UI testing and automation |

### MCP Servers (2)

| Server | Type | Purpose |
|--------|------|---------|
| draw.io | HTTP (hosted) | Architecture diagrams from natural language |
| gcloud | stdio (npx) | GCP resource management via natural language |

### Permissions (26)

Auto-allowed without prompting:

- **Core dev:** `git`, `python`, `uv`, `pytest`, `ruff`
- **Go:** `go`, `golangci-lint`, `gopls`
- **Node:** `npm`, `npx`, `node`
- **Infra:** `gcloud`, `docker`, `docker-compose`, `terraform`
- **CI/CD:** `gh`, `act`, `hadolint`, `actionlint`
- **Filesystem:** `ls`, `mkdir`, `find`, `mdfind`, `which`, `cat`, `wc`

Deliberately excluded (will prompt): `rm`, `curl`, `wget`, `ssh`

### Statusline

Custom status bar showing model name and context usage with color-coded progress:
- Green < 50% | Yellow < 75% | Red 75%+

## Prerequisites

```bash
# Python
pip install ruff
# or: uv tool install ruff

# JavaScript/TypeScript
npm install -g prettier

# Go
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/tools/gopls@latest

# Docker & CI
brew install hadolint actionlint act
```

## Install

```bash
./install.sh
```

Symlinks all config files into `~/.claude/`. Backs up existing files before overwriting.

## Files

| File | Destination | Purpose |
|------|-------------|---------|
| `settings.json` | `~/.claude/settings.json` | Plugins, hooks, statusline |
| `settings.local.json` | `~/.claude/settings.local.json` | Permissions |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions |
| `statusline-command.sh` | `~/.claude/statusline-command.sh` | Context usage bar |
| `mcp.json` | `~/.claude/plugins/custom/.mcp.json` | MCP servers |
