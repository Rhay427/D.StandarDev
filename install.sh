#!/usr/bin/env bash
# D.StandarDev — install the standard Claude Code setup into ~/.claude
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
STAMP="$(date +%Y%m%d-%H%M%S)"

MARKETPLACES=(
  "anthropics/claude-plugins-official"
  "https://github.com/pleaseai/claude-code-plugins.git"
  "dietrichgebert/ponytail"
)

# Plugin tiers. PROFILE=core|web|data|all (default: all)
CORE=(
  superpowers@claude-plugins-official
  ponytail@ponytail
  security-guidance@claude-plugins-official
  code-review@claude-plugins-official
  code-simplifier@claude-plugins-official
  skill-creator@claude-plugins-official
  github@claude-plugins-official
  context7@claude-plugins-official
  please-plugins@pleaseai
)
WEB=(
  frontend-design@claude-plugins-official
  vite@pleaseai
  vitest@pleaseai
  astro@pleaseai
  playwright-cli@pleaseai
  pnpm@pleaseai
  tsdown@pleaseai
  zod@pleaseai
  figma@claude-plugins-official
)
DATA=(
  supabase@claude-plugins-official
  firecrawl@claude-plugins-official
)


say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

case "${PROFILE:-all}" in
  core)   PLUGINS=("${CORE[@]}") ;;
  web)    PLUGINS=("${CORE[@]}" "${WEB[@]}") ;;
  data)   PLUGINS=("${CORE[@]}" "${DATA[@]}") ;;
  all)    PLUGINS=("${CORE[@]}" "${WEB[@]}" "${DATA[@]}") ;;
  *) warn "unknown PROFILE '${PROFILE}' (use core|web|data|all)"; exit 1 ;;
esac


command -v claude >/dev/null || {
  warn "claude CLI not found. Install it first: https://claude.com/claude-code"
  exit 1
}

backup() {
  [ -e "$1" ] || return 0
  local b="$DEST/backups/standardev-$STAMP"
  mkdir -p "$b"
  cp -R "$1" "$b/"
  say "backed up $(basename "$1") -> $b/"
}

say "installing into $DEST  (profile: ${PROFILE:-all}, ${#PLUGINS[@]} plugins)"
mkdir -p "$DEST/skills"

backup "$DEST/CLAUDE.md"
cp "$SRC/claude/CLAUDE.md" "$DEST/CLAUDE.md"
say "CLAUDE.md installed"

for skill in "$SRC"/claude/skills/*/; do
  name="$(basename "$skill")"
  backup "$DEST/skills/$name"
  rm -rf "$DEST/skills/$name"
  cp -R "$skill" "$DEST/skills/$name"
  say "skill installed: $name"
done

if [ -f "$DEST/settings.json" ]; then
  warn "$DEST/settings.json already exists — left untouched."
  warn "Merge claude/settings.json by hand if you want the model/env defaults."
else
  cp "$SRC/claude/settings.json" "$DEST/settings.json"
  say "settings.json installed"
fi

if [ "${SKIP_PLUGINS:-0}" = "1" ]; then
  say "SKIP_PLUGINS=1 — skipping marketplaces and plugins"
  exit 0
fi

for m in "${MARKETPLACES[@]}"; do
  claude plugin marketplace add "$m" >/dev/null 2>&1 && say "marketplace: $m" \
    || warn "marketplace already present or failed: $m"
done

for p in "${PLUGINS[@]}"; do
  claude plugin install "$p" >/dev/null 2>&1 && say "plugin: $p" \
    || warn "plugin already installed or failed: $p"
done

say "done — restart Claude Code to load everything."
