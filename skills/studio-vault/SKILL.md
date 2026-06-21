---
name: studio-vault
description: The studio's local memory. A git repo at ~/orive-vault/ that logs sessions, every MCP tool call, learned patterns, and replayable recipes. Read it at startup, write to it at the end of each session. Read by the host and every specialist.
---

# Studio Vault

Orive Creative Studio keeps a local memory so it knows what happened before. Every session, every recommendation, every pattern it notices, and every MCP tool call gets logged here. Read this repo at startup. Write to it at the end of each session. Never fabricate a memory you did not log. No em dashes, ever.

## Where it lives and how it is created

The vault is a local git repo at a configurable path, default `~/orive-vault/`. The first time the studio runs, create it with the structure below and run `git init`. If it already exists, open it. Never overwrite. The scaffold scripts `scripts/init-vault.sh` and `scripts/init-vault.ps1` create the structure for you.

```
orive-vault/
  sessions/
    YYYY-MM-DD-HH-MM-topic-slug.md      # one file per session
    mcp-log/
      YYYY-MM-DD.jsonl                    # one line per MCP tool call per day
    recipes/
      YYYY-MM-DD-short-name.json          # replayable how-we-made-this presets
  patterns/
    tool-usage.json                       # which tools used, how often, for what
    content-patterns.json                 # recurring content types, formats, topics
    feedback-log.json                     # feedback, corrections, preferences
    mcp-chains.json                       # common tool-to-tool handoff sequences
    client-briefs/                        # saved briefs per client or project
  prompts/
    saved/                                # prompts the user liked and saved
    templates/                            # reusable prompt templates
  connections/
    status.json                           # mirrored from the main repo
    install-log.json                      # what was installed, when, outcome
  index.json                              # a searchable index of past work, for recall
```

## Startup read

When the studio initializes, read, in order:

1. `connections/status.json`, what is connected.
2. `patterns/`, what it has learned, including `mcp-chains.json`.
3. The last 3 session files, recent context.
4. Today's MCP log if it exists, current session awareness.

This gives memory without an external database.

## Session logging

At the end of each session, or when the user says "save this", write a session file to `sessions/`:

- Date, duration, which specialists were called
- What the user asked for
- What was produced
- Which tools were used
- Any decisions, preferences, or corrections the user made

Keep it concise. A useful summary, not a transcript. Then append an index entry (see Recall) so this session and anything notable in it can be found again months later.

## MCP interchange log

Every tool call that crosses an MCP boundary gets one line in `sessions/mcp-log/YYYY-MM-DD.jsonl`. The log is append-only within a day, old logs are never modified. Each entry records:

- Timestamp
- Which specialist triggered it
- Which MCP server was called (higgsfield, davinci-resolve, blender, adobe, figma, canva, pexels, notion, and so on)
- The tool name and a short summary of the input, not the full payload
- The outcome: success, failure, or pending
- If a generation: the model used and the credit cost
- If a handoff between tools: what was passed and where, with a shared `chain_id` so the full pipeline can be reconstructed
- If a failure: the error message, so it can be traced later

This log powers three things: pattern recognition (which tools and chains the user reaches for), cost tracking (real credit totals, no guessing), and debugging (timestamp, server, and error without reproducing the session).

## Action recipes, the how-we-made-this log

Do not save large output files to the vault, they belong in the project folder. Save the recipe instead: the exact sequence of actions, functions, scripts, and tool calls that produced the result. Think replayable presets, like Photoshop Actions or DaVinci macros, but across the whole studio. Save to `sessions/recipes/YYYY-MM-DD-short-name.json`.

A recipe contains:

- `name`, a short human name ("hotel-reel-from-stills", "product-shot-white-bg", "instagram-carousel-1080")
- `created`, timestamp
- `specialist`, which agents ran it
- `trigger`, what the user asked for, in their words
- `steps`, an ordered array, each step recording: the tool or MCP server, the function or tool name (for example higgsfield.generate_video, adobe.remove_background, blender.export_stl), the parameters used (model, resolution, aspect ratio, style, prompt text, filter, export format), any generated script saved inline (Blender Python, DaVinci Lua, Photoshop ExtendScript), any manual step described ("user approved the draft", "user selected take 2 of 4"), the duration, the outcome, and an output reference (what it produced and where it was saved, never the file itself)
- `total_cost`, combined credits or API costs across all steps
- `tags`, user-added or inferred (hotel, social, product, reel, print)

Save recipes automatically at the end of any multi-step production task. For single-step tasks, only save if the user says "save this as a preset", or if the same pattern has been done three or more times, at which point ask: "you have done this three times now, want me to save it as a reusable recipe?"

Reuse: when the user says "do the same as last time" or "use the hotel reel recipe", load the matching recipe, confirm the steps, and replay with the new input. When recommending a workflow for a new task, check existing recipes first and offer a close match. Recipes can be edited, for example "use the product shot recipe but change the resolution to 4K", then ask whether to save as a new version or overwrite.

Recipes never store output files, raw image or video data, transcripts, or credentials.

## Pattern recognition

Over time, read past sessions and the MCP log and update the pattern files. Patterns are suggestions, never overrides, and the host mentions them:

- If the user always uses DaVinci for reels, route future reel tasks to DaVinci first.
- If the user prefers PAS over AIDA for hotel copy, note it.
- If a client always wants Instagram carousels at 1080x1080, note it.
- If the user runs Higgsfield then Adobe then Figma for ad creative, note that chain in `mcp-chains.json`.

For example: "Last time you preferred PAS for hotel captions, want that again?" or "Your usual pipeline for ad video is Higgsfield then DaVinci, want me to set that up?"

## Recall, bringing back past work

The vault is not just a log, it is a memory the user can reach into months later. When the user refers to something from the past, recall it, do not make them go find it.

**The index.** Keep a searchable index at `index.json`, an array of entries, one per noteworthy thing the studio produced or decided. Append to it whenever you write a session, save a recipe, or produce a quote, proposal, invoice, concept, idea, plan, query, or brief. Each entry:

- `date`, when it happened
- `type`, one of session, quote, proposal, invoice, concept, idea, plan, query, recipe, brief
- `title`, a short human name
- `client`, the client or project, if any
- `tags` and `keywords`, for matching
- `summary`, one or two lines so recall can answer without opening the file
- `path`, where the full thing lives, in the vault or in the work repo under clients or outputs

**When to recall.** Watch for past-reference cues: "remember", "last time", "a few months ago", "that quote for", "the concept we", "what did we decide", "reopen", "continue", "reuse". When you see one, recall before you answer.

**How to recall.**

1. Work out what they want: the topic keywords, the type (quote, proposal, concept, plan), the client, and any rough time ("a few months ago" becomes a date window).
2. Search `index.json` by keyword, tag, title, client, and type, filter by the date window if there is one, and rank by relevance then recency.
3. If the index is thin or missing, fall back to scanning the `sessions/`, `recipes/`, and `patterns/client-briefs/` files by keyword.
4. Surface the best one to three matches, each with its date, type, title, and one-line summary, then offer a useful next step: reopen it, reuse it, replay it for a recipe, or continue from it. Open the full file from `path` only for the one the user picks.
5. If nothing matches, say so plainly and offer to search wider or start fresh. Never invent a memory that was not logged.

For example: "I found two things from around then. A US SaaS landing page quote from April, three tiers starting at 3200 USD, and a streetwear concept built on Dhaka diamonds. Want me to reopen the quote, reuse it for a new client, or pull up the concept?"

Recall reads summaries first and opens a full file only when needed, so it stays fast even with months of history. It is grounded in the index and the logged files, so it never guesses at a memory.

**Timeline.** For a chronological view rather than a search, read `index.json` and list everything by date, newest first, grouped by month, each line showing the date, type, title, and client. Filter to one client or one tag when asked. This is the `/vault timeline` command, a history of the work the user can scroll back through.

## Privacy and control

- The vault is local only, never pushed to a remote unless the user asks.
- The user can delete any session, log, recipe, or pattern file, and the system respects that silently. When something is deleted or forgotten, remove its entry from `index.json` too, so recall never points at a file that is gone.
- No raw conversation transcripts, only structured summaries.
- MCP logs record tool names and short summaries, never full payloads, file contents, or credentials.
- MCP OAuth tokens are managed by the client, never stored in the vault.

## Wiring with the creative-toolbox

- When a tool is installed via the creative-toolbox, log it to `connections/install-log.json` with the date, the tool, the method, and the outcome.
- When recommending tools, read `patterns/tool-usage.json` and `patterns/mcp-chains.json` to offer the familiar path first, then alternatives.
- When a generation costs credits (Higgsfield or any paid MCP), log the cost to the MCP log so cost totals stay accurate.
- When a tool-to-tool handoff happens, log both the source call and the destination call with a shared `chain_id` so the full pipeline can be reconstructed.
