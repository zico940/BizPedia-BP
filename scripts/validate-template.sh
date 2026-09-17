#!/usr/bin/env bash
# Verifies the template is distributable: required entries exist, no OS metadata,
# no secret-like strings. The required list lives in TEMPLATE_MANIFEST.md, not here,
# so the list has exactly one source.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/TEMPLATE_MANIFEST.md"

if [[ ! -f "$MANIFEST" ]]; then
  echo "Missing TEMPLATE_MANIFEST.md" >&2
  exit 1
fi

missing=0
while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  if [[ ! -e "$ROOT/$entry" ]]; then
    echo "Missing required entry: $entry" >&2
    missing=1
  fi
done < <(awk '/^## Required (Files|Directories)/{on=1;next} /^## /{on=0} on' "$MANIFEST" \
           | grep -o '`[^`]*`' | tr -d '`')

[[ $missing -eq 0 ]] || exit 1

if find "$ROOT" -name ".DS_Store" -o -name "Thumbs.db" | grep -q .; then
  echo "Remove OS metadata files before distribution." >&2
  exit 1
fi

secrets="$(mktemp)"
trap 'rm -f "$secrets"' EXIT
if grep -RInE "(sk-|api[_-]?key|password|token|secret)" "$ROOT" \
  --exclude-dir=.obsidian \
  --exclude-dir=.git \
  --exclude="validate-template.sh" \
  --exclude=".gitignore" >"$secrets"; then
  echo "Potential secret-like text found:" >&2
  cat "$secrets" >&2
  exit 1
fi

echo "Template validation passed: $ROOT"
