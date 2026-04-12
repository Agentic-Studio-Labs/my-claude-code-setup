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

### Model

Default model: **Opus** (`"model": "opus"`)

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

### Session Hooks

| Hook | Purpose |
|------|---------|
| **PreCompact** | Reminds you to save important context to memory before compaction |
| **SessionStart** | Checks for Claude Code updates via [claude-changelog](https://github.com/Agentic-Studio-Labs/claude-changelog) |

The SessionStart changelog hook requires the [claude-changelog](https://github.com/Agentic-Studio-Labs/claude-changelog) repo to be cloned and its hook symlinked to `~/.claude/changelog-check.sh`. See that repo's README for setup instructions.

### Plugins (12)

| Plugin | Purpose |
|--------|---------|
| superpowers | Skills framework — TDD, plans, debugging, brainstorming |
| github | PR/issue workflows |
| feature-dev | Code architecture, exploration, and review agents |
| claude-md-management | CLAUDE.md auditing and maintenance |
| claude-code-setup | Automation recommendations |
| context7 | Up-to-date library docs lookup |
| visual-explainer | HTML diagrams, slides, project recaps |
| playwright | Browser/UI testing and automation |
| code-simplifier | Code clarity and maintainability refactoring |
| security-guidance | Security best practices and vulnerability detection |
| ralph-loop | Recurring prompt execution loop |
| telegram | Telegram channel integration |

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

### Skills ([gstack](https://github.com/garrytan/gstack))

Installed automatically by `install.sh`. Re-running the installer pulls the latest and picks up any new skills — no hardcoded skill list.

| Skill | Purpose |
|-------|---------|
| `/autoplan` | Auto-review pipeline — runs CEO, design, eng, and DX reviews |
| `/benchmark` | Performance regression detection with baselines |
| `/browse` | Headless Chromium browsing and visual testing |
| `/canary` | Post-deploy canary monitoring for errors and regressions |
| `/careful` | Safety guardrails for destructive commands |
| `/checkpoint` | Save and resume working state checkpoints |
| `/codex` | OpenAI Codex CLI wrapper for code review and generation |
| `/connect-chrome` | Connect to running Chrome for debugging |
| `/cso` | Chief Security Officer mode — infrastructure security audit |
| `/design-consultation` | Create complete design systems from scratch |
| `/design-html` | Production-quality HTML/CSS design finalization |
| `/design-review` | Audit design quality with before/after screenshots |
| `/design-shotgun` | Generate multiple AI design variants for comparison |
| `/devex-review` | Live developer experience audit |
| `/document-release` | Update project docs to match code changes |
| `/find-skills` | Discover and install agent skills |
| `/freeze` | Restrict file edits to a specific directory |
| `/gstack-upgrade` | Self-update gstack |
| `/guard` | Full safety mode — destructive warnings + directory-scoped edits |
| `/health` | Code quality dashboard (type checker, linter, tests, dead code) |
| `/investigate` | Systematic root-cause debugging |
| `/land-and-deploy` | Merge PR, wait for CI/deploy, verify production health |
| `/learn` | Manage project learnings across sessions |
| `/office-hours` | Product reframing before coding begins |
| `/open-gstack-browser` | Launch AI-controlled Chromium with sidebar extension |
| `/pair-agent` | Pair a remote AI agent with your browser |
| `/plan-ceo-review` | CEO/founder-mode scope and strategy review |
| `/plan-design-review` | Rate design dimensions on 0-10 scale |
| `/plan-devex-review` | Interactive developer experience plan review |
| `/plan-eng-review` | Lock in architecture, edge cases, test plans |
| `/qa` | Browser testing, bug fixing, regression tests |
| `/qa-only` | QA testing and reporting (no code changes) |
| `/retro` | Weekly engineering retrospective |
| `/review` | Pre-landing PR review |
| `/setup-browser-cookies` | Import session cookies for authenticated testing |
| `/setup-deploy` | Configure deployment settings for `/land-and-deploy` |
| `/ship` | Merge, test, bump version, push, create PR |
| `/unfreeze` | Clear freeze boundary, allow edits everywhere |

### Optional: Changelog Hook

The SessionStart hook checks for Claude Code releases using [claude-changelog](https://github.com/Agentic-Studio-Labs/claude-changelog). To set it up:

```bash
git clone https://github.com/Agentic-Studio-Labs/claude-changelog.git ~/Projects/claude-changelog
ln -s ~/Projects/claude-changelog/hooks/changelog-check.sh ~/.claude/changelog-check.sh
```

## Install

```bash
./install.sh
```

Symlinks all config files into `~/.claude/`. Clones [gstack](https://github.com/garrytan/gstack) into `~/.claude/skills/gstack/` and symlinks each skill. Backs up existing files before overwriting.

## Files

| File | Destination | Purpose |
|------|-------------|---------|
| `settings.json` | `~/.claude/settings.json` | Model, plugins, hooks, statusline |
| `settings.local.json` | `~/.claude/settings.local.json` | Permissions |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions |
| `statusline-command.sh` | `~/.claude/statusline-command.sh` | Context usage bar |
| `mcp.json` | `~/.claude/plugins/custom/.mcp.json` | MCP servers |
