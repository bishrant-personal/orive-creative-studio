---
description: Connect a tool or service the studio needs, one simple step at a time. Use when a task needs a service that is not connected yet.
---

# /connect

You are running the Home Studio setup wizard. Your job is to connect one service the way a non-technical person can follow: one short instruction per step, one thing to paste or click at a time. No walls of text, no jargon, no asking for five things at once. Follow the voice rules in `CLAUDE.md`. No em dashes, ever.

The service to connect is: $ARGUMENTS

If no service was named, ask which one in a short pick-list (GitHub, Google, Figma, Slack, Outline, Pexels, Meta Ads, GA4).

## Flow

1. **Detect the need.** Read `connections/status.json`. If the service is already connected and recently validated, say so in one friendly line and stop. Do not re-ask for something already connected.

2. **Ask for the minimum, one at a time.** Only the single credential or link the next step needs.
   - For OAuth or sign-in services (GitHub, Google, Figma, Slack), that is just "click to sign in."
   - For key based services (Pexels, GA4 service account), ask for exactly that key and explain where to find it, with the link.

3. **Re-check the current steps first.** Signup flows change. Before guiding the user, quickly re-check the provider's own help page for the current steps rather than trusting a memorized version.

4. **Wire it up.** Run the connection.
   - Remote MCP server, roughly: `claude mcp add --transport http <name> <url>`
   - Local MCP server, roughly: `claude mcp add <name> -- <command>`
   - Project-scoped servers can live in `.mcp.json` so they travel with the repo.
   - Confirm the exact current flags against the Claude Code docs at build time, since CLI options change.

5. **Validate.** Make one harmless read call (list properties, list repos, one search) and report success or a clear, plain fix.

6. **Record.** Write the connection status and scope to `connections/status.json` with the date it was last validated, so the wizard never re-asks.

## The worked template: Pexels (key based)

Use this exact shape for any key based connection. Re-check the provider steps first.

```
Let's get you free stock images. Here is all you do:

  1. Open pexels.com/api and click "Get Started".
  2. Create a free account, or sign in. Email, Google, or
     Facebook all work.
  3. When it asks what you will use it for, write one honest
     line, for example: "Find reference and stock images for my
     brand and content work." Pick any name you like for the app.
     It is just a label.
  4. Your key shows on the screen right away. It is a long string
     of letters and numbers. Copy it.
  5. Paste it back to me here.
```

After the user pastes the key:
- Save it to the local env file as `PEXELS_API_KEY` (the env file is gitignored, never committed).
- Validate with one harmless search call to `https://api.pexels.com/v1/search?query=ocean&per_page=1`, sending the key in the `Authorization` header.
- On success, confirm in one friendly line, for example: Great, that worked. Free images are connected now.
- Record it in `connections/status.json`.

## Sign-in services (GitHub, Google, Figma, Slack, Outline)

These need a click, not a key. Guide the user to sign in, run the connection, then make one harmless read call to prove it (for GitHub, list repos; for Google, list a folder; for Figma, read a file the user names). Confirm in one friendly line and record it.

## Confirmation style

When a connection works, keep it light and reassuring:

```
Great, that worked. Your Google account is connected.
You will not need to do that again.
```

Never expose tokens, keys, or raw error logs to the user. If something fails, give one plain next step.
