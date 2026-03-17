#!/bin/bash
set -euo pipefail

# Test install.sh by running it against a temp HOME directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_HOME=$(mktemp -d)
TEST_CLAUDE="$TEST_HOME/.claude"
passed=0
failed=0

cleanup() {
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

assert() {
  local desc="$1"
  shift
  if "$@" > /dev/null 2>&1; then
    echo "  PASS: $desc"
    passed=$((passed + 1))
  else
    echo "  FAIL: $desc"
    failed=$((failed + 1))
  fi
}

echo "=== Test 1: Fresh install (no existing config) ==="
HOME="$TEST_HOME" "$SCRIPT_DIR/install.sh"

assert "settings.json is symlinked" test -L "$TEST_CLAUDE/settings.json"
assert "settings.local.json is symlinked" test -L "$TEST_CLAUDE/settings.local.json"
assert "CLAUDE.md is symlinked" test -L "$TEST_CLAUDE/CLAUDE.md"
assert "statusline-command.sh is symlinked" test -L "$TEST_CLAUDE/statusline-command.sh"
assert "mcp.json is symlinked" test -L "$TEST_CLAUDE/plugins/custom/.mcp.json"
assert "statusline is executable" test -x "$SCRIPT_DIR/statusline-command.sh"
assert "settings.json points to source" test "$(readlink "$TEST_CLAUDE/settings.json")" = "$SCRIPT_DIR/settings.json"
assert "no backup dir created" test "$(find "$TEST_CLAUDE" -maxdepth 1 -name 'backup-*' | wc -l)" -eq 0

echo ""
echo "=== Test 2: Re-install over symlinks (idempotent) ==="
HOME="$TEST_HOME" "$SCRIPT_DIR/install.sh"

assert "settings.json still symlinked" test -L "$TEST_CLAUDE/settings.json"
assert "no backup dir (symlinks don't trigger backup)" test "$(find "$TEST_CLAUDE" -maxdepth 1 -name 'backup-*' | wc -l)" -eq 0

echo ""
echo "=== Test 3: Install over existing files (backup created) ==="
rm -rf "$TEST_CLAUDE"
mkdir -p "$TEST_CLAUDE/plugins/custom"
echo "old-settings" > "$TEST_CLAUDE/settings.json"
echo "old-claude" > "$TEST_CLAUDE/CLAUDE.md"

HOME="$TEST_HOME" "$SCRIPT_DIR/install.sh"

assert "settings.json is now symlinked" test -L "$TEST_CLAUDE/settings.json"
assert "CLAUDE.md is now symlinked" test -L "$TEST_CLAUDE/CLAUDE.md"
assert "backup dir created" test "$(find "$TEST_CLAUDE" -maxdepth 1 -name 'backup-*' -type d | wc -l)" -eq 1

BACKUP_DIR=$(find "$TEST_CLAUDE" -maxdepth 1 -name 'backup-*' -type d | head -1)
assert "settings.json backed up" test -f "$BACKUP_DIR/settings.json"
assert "CLAUDE.md backed up" test -f "$BACKUP_DIR/CLAUDE.md"
assert "backup contains original content" grep -q "old-settings" "$BACKUP_DIR/settings.json"

echo ""
echo "=== Results ==="
echo "Passed: $passed"
echo "Failed: $failed"

if [ "$failed" -gt 0 ]; then
  exit 1
fi
echo "All tests passed."
