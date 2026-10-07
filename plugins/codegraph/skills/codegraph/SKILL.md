---
name: codegraph
description: "Use in repositories indexed by CodeGraph (a .codegraph/ directory exists at the repo root) to understand or locate code before grep/find or reading files. Covers the codegraph_explore MCP tool and the codegraph explore CLI."
---

# CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.

## Setup (once per machine, once per project)

- Install the CLI: `npm i -g @colbymchenry/codegraph`
- Index a project: run `codegraph init` in the repo root. Only do this when the user asks.
- This plugin starts the MCP server with `CODEGRAPH_TELEMETRY=0`. Run `codegraph telemetry off` to disable telemetry for shell use too.
