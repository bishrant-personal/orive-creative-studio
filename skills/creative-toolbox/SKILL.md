---
name: creative-toolbox
description: Recommend the right creative tool for a task, check what is connected, and install or guide the rest with real, verified links. Covers Adobe, Higgsfield, DaVinci Resolve, Blender, Affinity, Figma, Canva, and Pexels. Read by the host and every specialist. Tier-zero knowledge, no web search needed to recommend.
---

# Creative Toolbox

When a user says they want to make something, recommend the right creative tools, check what is already installed, offer to install what is missing, and guide the rest with real links. Never recommend a tool without a real, verified install path. No em dashes, ever.

The structured tool knowledge base is in `tools.json` in this folder. Read it first. It is seeded, tier-zero knowledge, so recommending tools needs no web search. Only search to confirm a repo, installer, or MCP URL has changed, and refresh quarterly.

## The design skill, always on for visual work

For any UI, web page, app screen, microsite, or HTML deliverable, the studio leans on the `frontend-design` skill (an official Claude Code plugin installed at setup, `frontend-design@claude-plugins-official`). It is the studio's bar for distinctive, non-template design: deliberate type, a real aesthetic point of view, and layouts that do not read as generated. Load it before building any on-screen interface. The apps below make the asset; `frontend-design` decides how it should look, and `document-design` handles documents and the HTML-to-PDF render path. If for any reason the plugin is not installed, offer to add it the same way as any other tool.

## How to recommend

When the user describes what they want to make:

1. **Identify the task type:** photo edit, video edit, video generation, image generation, 3d, design ui, layout print, social graphic, brand asset, web, or stock assets.
2. **Map it to tools** using the `task_map` in `tools.json`.
3. **Check what is connected** by reading `connections/status.json`.
4. **For anything already connected,** just say "ready to go."
5. **For anything missing,** recommend it with a one-line reason, then offer to install it.
6. **Recommend only what the task needs.** If Canva handles it, do not suggest Adobe. If Figma is connected and the task is UI, do not suggest Affinity.
7. **Generation first.** When the task is make a video or generate an image and there is no existing footage or photo, recommend Higgsfield first. It is the fastest path from idea to visual because it runs cloud-side with no local app. If the user already has footage to edit, recommend DaVinci or Adobe. If they need 3D, recommend Blender. Higgsfield generates, the others edit.
8. **Chain when needed.** When a task needs both generation and editing, for example generate a product video then color grade it, recommend the chain: Higgsfield for generation, then DaVinci or Adobe for the edit. Name both and explain the handoff.

Before recommending, also check the vault's `patterns/tool-usage.json` and `patterns/mcp-chains.json` (see System 2). If the user has a familiar tool or pipeline for this kind of task, recommend that first, then alternatives.

## How to install, by tool type

Read the tool's `install` block in `tools.json` for the exact path. After any install, update `connections/status.json`, log it to the vault's `connections/install-log.json`, and confirm with a test call or version check. If an install fails, say what went wrong, give the link to the source repo's issues page, and do not retry silently.

- **Connectors (Adobe, Figma, Canva):** give the exact click path, for example "Open Customize, go to Connectors, click +, find Adobe, sign in with your Adobe ID." This cannot be automated, so make the instruction so clear it takes thirty seconds.
- **Hosted MCP (Higgsfield):** in Chat or Cowork, give the click path: "Open Customize, go to Connectors, click +, select Add custom connector, name it Higgsfield, paste https://mcp.higgsfield.ai/mcp as the URL, click Connect, sign in with your Higgsfield account." In Claude Code, run `claude mcp add higgsfield --transport http https://mcp.higgsfield.ai/mcp` automatically instead.
- **MCP with an install script (DaVinci Resolve):** in Claude Code, run the install in the terminal and show what is happening. In Chat or Cowork, give the terminal command and the link.
- **MCP needing a clone and config (Blender, Affinity):** in Claude Code, run git clone, install dependencies, and write the `.mcp.json` entry automatically. In Chat or Cowork, give the step-by-step with copy-paste commands.
- **API keys (Pexels):** open the signup link, ask the user to paste the key, write it to `.env` automatically (gitignored, never committed), and verify it with a test call.

## What can I make

If the user asks "what can I make?" or "what tools do I have?", read `connections/status.json`, list what is connected, and give a short friendly summary of what each unlocks. Then offer to connect anything missing that fits their interests from `connections/profile.json`.

## The rules that always hold

- Every link must be real and verified. The links in `tools.json` are the source of truth. Never invent a URL or an MCP address.
- No hallucinated tool names, install commands, or MCP server addresses. If unsure, search first.
- Read-and-stage for anything that spends money. Higgsfield generations cost credits, so show the model and the estimated cost and wait for a yes. Never auto-generate.
- Secrets live in `.env`, gitignored, never committed. MCP OAuth tokens are managed by the client, not stored anywhere by the studio.
- Recommending tools is tier-zero, no search. Only search to check whether a repo or installer has changed.
