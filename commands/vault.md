---
description: Look into the studio's memory: recent sessions, learned patterns, MCP tool calls and costs, saved recipes, and connected tools. Use to review, replay, or forget what the studio remembers.
---

# /vault

You are working with the studio's local memory at `~/orive-vault/`. Read the `studio-vault` skill first for the structure and the rules. Keep replies short and friendly. No em dashes, ever. Never invent a memory that is not logged, if there is nothing, say so plainly.

The subcommand is: $ARGUMENTS

Handle these:

| Command | What it does |
|---|---|
| `/vault show` | List recent sessions, newest first, with date and topic |
| `/vault recall [topic]` | Bring back past work that matches: quotes, proposals, invoices, concepts, ideas, plans, queries, or sessions. Search index.json, show the best few with date, type, and a one-line summary, then offer to reopen, reuse, replay, or continue |
| `/vault find [topic]` | The same as recall, an alias |
| `/vault timeline` | Show everything in date order, grouped by month: date, type, title, and client. A history of the work |
| `/vault timeline [client or tag]` | The same history, filtered to one client or one tag |
| `/vault forget [topic]` | Remove entries matching the topic, then confirm quietly. Respect it silently |
| `/vault patterns` | Show what the studio has learned: tool usage, content patterns, preferences, and chains |
| `/vault mcp` | Show recent MCP tool calls from the interchange log |
| `/vault mcp cost` | Total credits and API costs from the log, for example "this week you used X credits" |
| `/vault mcp chain` | Show common tool-to-tool handoff pipelines, reconstructed by chain id |
| `/vault tools` | Read connections/status.json and list what is connected and what is available |
| `/vault save` | Force-save the current session now |
| `/vault recipes` | List saved recipes by name and date |
| `/vault recipes [tag]` | List recipes filtered by tag, for example hotel or social |
| `/vault replay [name]` | Load a recipe, show its steps, and confirm before running it |
| `/vault recipe save` | Force-save the current workflow as a reusable recipe |

If no subcommand is given, show a short menu of the options above.

## Rules

- Read real files from the vault. If a file or folder does not exist yet, say the vault is empty for that, do not invent entries.
- For `forget`, delete the matching files and confirm in one line. Do not keep a hidden copy.
- For `replay`, always show the steps and wait for a yes before running anything, especially steps that cost credits or post publicly.
- For cost questions, read the MCP log and add up real numbers, never estimate.
- The vault is local. Never push it to a remote unless the user asks.
