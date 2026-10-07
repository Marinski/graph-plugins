# Graph Plugins

Claude Code plugin wrappers for two code knowledge-graph tools that don't ship their own plugin marketplace:

| Plugin | Upstream | What it adds |
|--------|----------|--------------|
| `graphify` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | The `/graphify` skill and its `references/` sidecar, copied from the pinned tag in [`upstream.json`](./upstream.json) |
| `codegraph` | [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) | The `codegraph` MCP server (`codegraph serve --mcp`) and a short usage skill based on the upstream agent instructions |

These plugins are also published through [Marinski/agent-plugins](https://github.com/Marinski/agent-plugins).

## Why wrappers without hooks

Upstream installers (`graphify install`, `codegraph install`) also register hooks: a `PreToolUse` guard for graphify and a `UserPromptSubmit` hook for CodeGraph. Claude Desktop does not copy plugins with hooks to SSH hosts, so these wrappers leave the hooks out. Everything else works the same; you only lose the automatic nudge toward the graph.

## Requirements on every machine

A plugin can't install a CLI. Install the upstream tool on each machine (local and every SSH host) where you use the plugin:

```bash
# graphify (Python 3.10+)
uv tool install graphifyy

# CodeGraph
npm i -g @colbymchenry/codegraph
```

Then, per project:

- graphify: run `/graphify .` in Claude Code.
- CodeGraph: run `codegraph init` in the repo root.

The `codegraph` plugin starts the MCP server with `CODEGRAPH_TELEMETRY=0`. Run `codegraph telemetry off` to also disable telemetry for CLI use.

## Install

```bash
/plugin marketplace add Marinski/graph-plugins
/plugin install graphify@graph-plugins
/plugin install codegraph@graph-plugins
```

## Updating

- graphify: `scripts/sync-graphify.sh <tag>` copies the skill files from an upstream tag and updates `upstream.json` and the plugin version. Keep the tag in step with the `graphifyy` version you have installed.
- CodeGraph: the plugin only holds the MCP config and a short skill. Check upstream `src/installer/` for changes to the server command or the instructions block, then update `upstream.json`.

## Licenses

Each plugin keeps its upstream license: graphify is Apache-2.0 or MIT (see `plugins/graphify/LICENSE`, `LICENSE-MIT` and `NOTICE`), CodeGraph is MIT (see `plugins/codegraph/LICENSE`).
