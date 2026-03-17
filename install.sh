#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backup-$(date +%Y%m%d-%H%M%S)"

# source:destination pairs
MAPPINGS="
settings.json:$CLAUDE_DIR/settings.json
settings.local.json:$CLAUDE_DIR/settings.local.json
CLAUDE.md:$CLAUDE_DIR/CLAUDE.md
statusline-command.sh:$CLAUDE_DIR/statusline-command.sh
mcp.json:$CLAUDE_DIR/plugins/custom/.mcp.json
"

echo "Installing Claude Code configuration..."
echo "Source: $SCRIPT_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/plugins/custom"

backed_up=false

for mapping in $MAPPINGS; do
  src="${mapping%%:*}"
  dest="${mapping#*:}"
  source_path="$SCRIPT_DIR/$src"

  if [ ! -f "$source_path" ]; then
    echo "SKIP: $src (not found)"
    continue
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    if [ "$backed_up" = false ]; then
      mkdir -p "$BACKUP_DIR"
      backed_up=true
      echo "Backing up existing files to $BACKUP_DIR"
    fi
    cp "$dest" "$BACKUP_DIR/$src"
    echo "  Backed up: $src"
  fi

  rm -f "$dest"
  ln -s "$source_path" "$dest"
  echo "  Linked: $src -> $dest"
done

chmod +x "$SCRIPT_DIR/statusline-command.sh"

echo ""
echo "Done. Restart Claude Code to pick up changes."
if [ "$backed_up" = true ]; then
  echo "Backups saved to: $BACKUP_DIR"
fi
