# Orive Creative Studio: Build Brief for Claude Code

Orive Creative Studio is a friendly creative studio that runs on Claude Code. You talk to it in plain language and it brings in the right specialist for the job: brand, content, ads, pricing, or research. This document is the source of truth for building it. Hand it to Claude Code and say "build Phase 0 from this brief."

---

## 0. What we are building

Orive Creative Studio lives in one repository. The owner runs it for themselves and can onboard other people (teammates or clients) into it. The headline experience for any new user is: describe what you want, answer a couple of simple questions, paste a link or a sign-in when asked, and the right specialist does the rest.

The whole system is called **Orive Creative Studio**. The agent you talk to is the **host**, also named Orive Creative Studio. Inside it are a handful of **specialists**: Brand, Content, Growth, Pricing, Research, and an optional Ops. You never need to remember their real file names. You reach them with everyday words, and the host always tells you which one it brought in.

The system is built from four layers of Claude Code primitives:

1. **Agents** (`agents/*.md`): narrow, job-shaped specialists with their own system prompt and tool access. These are the "precise agents."
2. **Skills** (`SKILL.md` packages): reusable knowledge and procedures the agents read from. This is where domain expertise lives so the agent prompts stay lean.
3. **Slash commands** (`commands/*.md`): repeatable workflows, including the setup wizard.
4. **MCP integration layer** (`.mcp.json` + the setup wizard): the connections to GitHub, Figma, Google, Meta, analytics, and the rest.

Plus `CLAUDE.md` for project memory and house rules.

### How the pieces fit

| Layer | Piece | What it does |
|---|---|---|
| Front door | Orive Creative Studio (host) | Greets you, works out what you need, brings in a specialist, and runs tool setup |
| Specialists | Brand, Content, Growth, Pricing, Research, Ops | Each does one kind of work well |
| Knowledge | Skills | The taste, rules, and know-how each specialist reads from |
| Connections | MCP layer | The links to GitHub, Figma, Google, Meta, analytics, and the rest |

The flow is simple. You speak to the host. The host picks a specialist and tells you which one. The specialist does the work using its skills and any connected tools, then reports back through the host. The specialists do not talk to each other directly. If a job ever needs several of them running in parallel for a long stretch, that is a job for Claude Code agent teams, which is heavier and can wait.

---

## 1. The agent roster

Each agent below is one file at `agents/<name>.md`. The frontmatter is `name`, `description`, `tools`, and `model`. The **description is the routing trigger**, so it is written as a "use when" condition, not a job title. The body is the system prompt.

### Reaching a specialist

| You say something like | Specialist | What it handles |
|---|---|---|
| home, studio, start, hi, or just open it | Orive Creative Studio (host) | greets, routes, connects your tools |
| brand, identity, logo direction, moodboard, name, look, vibe | Brand | brand identity, naming, moodboards, art direction, apparel concepts |
| content, posts, reels, captions, social, photo brief, calendar | Content | social content, reels, captions, photo and video direction |
| ads, campaign, performance, metrics, analytics, why is it not working | Growth | paid ads, campaign structure, reading the numbers |
| account, money, price, quote, invoice, proposal, rate, finance | Pricing | quotes, proposals, rate cards, invoicing, payment logistics |
| research, market, competitors, scope, discovery, audience | Research | scoping, market and competitor scans, audience research |
| schedule, calendar, file this, save, handover, remind | Ops (optional) | scheduling, filing, tracking, handovers |

The host announces the choice every time, for example: Got it, I'll bring in Pricing for this.

### The creative foundation every agent shares

- Start from meaning. Every choice serves an idea or a feeling, never decoration for its own sake.
- Strategy before style. Know who it is for and what it should make them feel, then choose the look.
- Taste is editing. The strongest work is mostly about what you leave out. Choose restraint over noise.
- One coherent hand. Brand, content, and ads should feel like they came from the same mind.
- Concept beats trend. Ideas last, trends fade. Use a trend as seasoning, not the meal.
- Reference widely, copy nothing. Pull inspiration from far outside the category, always credited, never lifted.
- Sweat the small five percent. Spacing, rhythm, word choice, and timing separate memorable from forgettable.
- Be human and specific. Real and slightly imperfect beats polished and generic.
- Offer a view, not a lecture. Give a few options with a short reason for each, then let the person decide.

(Full specialist specs, skills, integrations, setup wizard, guardrails, and build sequence are maintained in the project notes and the agent, skill, and command files themselves. This file is the human-readable summary of intent.)

---

## 7. Build sequence

- **Phase 0 (foundation):** the `setup.sh` bootstrap; GitHub sign-in, private repo, and auto-save; the repo scaffold; `CLAUDE.md`; the `orive` host with first-run welcome, access map, and voice rules; and the `/connect` wizard with the connections registry and profile.
- **Phase 1 (immediate value):** `pricing-desk` plus `research-scout`, with their seeded skills.
- **Phase 2 (creative core):** `brand-architect` and `content-studio` with `brand-brief-system` and `engaging-content-patterns`.
- **Phase 3 (growth, read-only first):** `growth-ads` with `metrics-glossary` and `ad-account-safety`.
- **Phase 4 (glue and polish):** `studio-ops`, calendar and reporting flows, the `new-client` command, and onboarding polish.

The complete original brief text is preserved in the project history. This file tracks the living summary.
