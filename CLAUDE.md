# Global Defaults

## Environment

- Default working directory: `/Users/jm/Projects`
- Default cloud provider: GCP (prefer `gcloud` CLI, Cloud Run, Cloud SQL, GCS, etc.)

## Communication

- Explain reasoning briefly — why, not just what
- Be concise but not terse; include enough context to understand decisions

## Python

- Type hints on all function signatures and return types
- Use `pytest` for testing (not unittest)
- Use `ruff` for linting and formatting (not black/flake8/isort)
- Prefer f-strings over `.format()` or `%`

## Code Style

- Prefer editing existing files over creating new ones
- Don't add comments for self-evident code
- Don't over-engineer — solve what's asked, nothing more

## Git

- Never commit unless explicitly asked
- When committing: small, focused, atomic commits
- Always run tests before committing to verify nothing is broken
- Don't push unless explicitly asked
- Use noreply email for commits: `5150911+jonathan-major@users.noreply.github.com`

## Memory & Context Management

- CLAUDE.md + auto-memory for stable knowledge (conventions, architecture, config)
- claude-mem plugin for action context (session continuity, work-in-progress)
- `/clear` when switching to unrelated tasks — reduces context noise
- Compact when accumulated dead-end exploration could confuse current work
- Don't duplicate in memory what's in code, git history, or CLAUDE.md
- If CLAUDE.md gets long, split into `.claude/rules/` files

## Gotchas

- Don't add docstrings, type annotations, or comments to code that wasn't changed
- Don't refactor surrounding code when fixing a bug
- Keep CLAUDE.md concise; put task-specific or domain-specific docs in separate files (e.g., `docs/`, `agent_docs/`) and reference them from CLAUDE.md rather than inlining
