#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

TEST_HOME="$TEST_ROOT/home"
TEST_BIN="$TEST_ROOT/bin"
COMMAND_LOG="$TEST_ROOT/commands.log"
mkdir -p "$TEST_HOME" "$TEST_BIN"

cat > "$TEST_BIN/claude" <<'EOF'
#!/usr/bin/env bash
printf 'claude %s\n' "$*" >> "$FAKE_COMMAND_LOG"
EOF

cat > "$TEST_BIN/npx" <<'EOF'
#!/usr/bin/env bash
printf 'npx %s\n' "$*" >> "$FAKE_COMMAND_LOG"
if [[ "$*" == *"impeccable install"* ]]; then
  mkdir -p "$HOME/.claude/skills/impeccable"
fi
EOF

chmod +x "$TEST_BIN/claude" "$TEST_BIN/npx"

run_installer() {
  env \
    HOME="$TEST_HOME" \
    CLAUDE_HOME="$TEST_HOME/.claude" \
    CODEX_HOME="$TEST_HOME/.codex" \
    PATH="$TEST_BIN:$PATH" \
    FAKE_COMMAND_LOG="$COMMAND_LOG" \
    "$@" \
    "$ROOT/install.sh" >/dev/null
}

assert_logged() {
  grep -Fqx "$1" "$COMMAND_LOG" || {
    printf 'missing command: %s\n' "$1" >&2
    return 1
  }
}

run_installer

for skill in frontend backend git mobile testing; do
  test -f "$TEST_HOME/.claude/skills/$skill/SKILL.md"
done
test -f "$TEST_HOME/.claude/CLAUDE.md"
test -f "$TEST_HOME/.claude/settings.json"
assert_logged 'npx skills add https://github.com/Leonxlnx/taste-skill --skill design-taste-frontend --global --agent claude-code --yes'
assert_logged 'npx impeccable install --global --providers=claude --no-hooks --yes'
test ! -e "$TEST_HOME/.claude/settings.local.json"
test ! -e "$TEST_HOME/.agents"
test ! -e "$TEST_HOME/.codex"

: > "$COMMAND_LOG"
run_installer env UPDATE=1

assert_logged 'npx skills update design-taste-frontend --global --yes'
assert_logged 'npx impeccable update --global --no-hooks --yes'
assert_logged 'claude plugin marketplace update'
assert_logged 'claude plugin update -y frontend-design@claude-plugins-official'

: > "$COMMAND_LOG"
TEST_HOME="$TEST_ROOT/codex-home"
mkdir -p "$TEST_HOME/.codex" "$TEST_HOME/.agents/skills/frontend"
printf 'old rules\n' > "$TEST_HOME/.codex/AGENTS.md"
touch "$TEST_HOME/.agents/skills/frontend/stale.md"
run_installer

for skill in frontend backend git mobile testing; do
  diff -r "$ROOT/claude/skills/$skill" "$TEST_HOME/.agents/skills/$skill"
done
test "$(head -n 1 "$TEST_HOME/.codex/AGENTS.md")" = '# Global Codex Instructions'
grep -Fqx '## Using Skills' "$TEST_HOME/.codex/AGENTS.md"
grep -Fqx 'old rules' "$TEST_HOME"/.codex/backups/standardev-*/AGENTS.md
test -f "$(echo "$TEST_HOME"/.codex/backups/standardev-*/frontend/stale.md)"
assert_logged 'npx skills add https://github.com/Leonxlnx/taste-skill --skill design-taste-frontend --global --agent claude-code codex --yes'
assert_logged 'npx impeccable install --global --providers=claude,codex --no-hooks --yes'

: > "$COMMAND_LOG"
rm -rf "$TEST_HOME/.agents"
CUSTOM_CLAUDE_HOME="$TEST_ROOT/custom-claude"
env \
  HOME="$TEST_HOME" \
  CLAUDE_HOME="$CUSTOM_CLAUDE_HOME" \
  CODEX_HOME="$TEST_HOME/.codex" \
  PATH="$TEST_BIN:$PATH" \
  FAKE_COMMAND_LOG="$COMMAND_LOG" \
  UPDATE=1 \
  "$ROOT/install.sh" >/dev/null

test -f "$CUSTOM_CLAUDE_HOME/CLAUDE.md"
test -f "$CUSTOM_CLAUDE_HOME/skills/frontend/SKILL.md"
test ! -s "$COMMAND_LOG"
test ! -e "$TEST_HOME/.agents"

printf 'install smoke test passed\n'
