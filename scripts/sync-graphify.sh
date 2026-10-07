#!/usr/bin/env bash
# Refresh the vendored graphify skill from an upstream tag.
# Usage: scripts/sync-graphify.sh v0.9.80
set -euo pipefail

tag="${1:?usage: $0 <graphify tag, e.g. v0.9.80>}"
root="$(cd "$(dirname "$0")/.." && pwd)"
dest="$root/plugins/graphify"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone -q --depth 1 --branch "$tag" https://github.com/Graphify-Labs/graphify.git "$tmp/graphify"
sha="$(git -C "$tmp/graphify" rev-parse HEAD)"

# Same mapping `graphify install --platform claude` uses:
#   graphify/skill.md -> SKILL.md, graphify/skills/claude/references -> references/
cp "$tmp/graphify/graphify/skill.md" "$dest/skills/graphify/SKILL.md"
rm -rf "$dest/skills/graphify/references"
cp -r "$tmp/graphify/graphify/skills/claude/references" "$dest/skills/graphify/references"
cp "$tmp/graphify/LICENSE" "$tmp/graphify/LICENSE-MIT" "$tmp/graphify/NOTICE" "$dest/"

version="${tag#v}"
python3 - "$root" "$tag" "$sha" "$version" <<'PY'
import json, sys, pathlib
root, tag, sha, version = sys.argv[1:]
root = pathlib.Path(root)
up = root / "upstream.json"
data = json.loads(up.read_text())
data["graphify"].update(ref=tag, sha=sha)
up.write_text(json.dumps(data, indent=2) + "\n")
pj = root / "plugins/graphify/.claude-plugin/plugin.json"
plugin = json.loads(pj.read_text())
plugin["version"] = version
pj.write_text(json.dumps(plugin, indent=2) + "\n")
PY

echo "graphify synced to $tag ($sha)"
