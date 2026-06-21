# Home Studio

A friendly creative studio that runs on Claude Code. You talk to it in plain language and it brings in the right specialist for the job: brand, content, ads, pricing, or research.

You never need to know the technical bits. Describe what you want, answer a couple of simple questions, paste a link or a sign-in when asked, and the right specialist does the rest.

## Getting started

Clone this repo and run the setup script. It installs what is needed and starts the studio.

```
git clone https://github.com/bishrant-personal/home-studio.git home-studio
cd home-studio
./setup.sh
```

On the first start, Home Studio greets you, signs you into GitHub so your work is always saved, and offers a few simple things to do first.

## What is inside

- **The host (Home Studio).** The agent you talk to. It greets you, works out what you need, and brings in a specialist.
- **Specialists.** Brand, Content, Growth, Pricing, and Research, with an optional Ops. Each does one kind of work well. They arrive phase by phase.
- **Skills.** The know-how each specialist reads from, kept separate so the agents stay lean.
- **The /connect wizard.** Connects a tool only when a task needs it, one simple step at a time.

## House rules

The full house rules, voice, guardrails, and shared creative point of view live in `CLAUDE.md`. The one rule that never bends: no em dashes, anywhere, ever.

## Build status

Phase 0 (foundation) is in place: the bootstrap script, GitHub auto-save behavior, the repo scaffold, `CLAUDE.md`, the host agent, and the `/connect` wizard. The specialists and their skills arrive in later phases. See `home-studio-build-brief.md` for the full plan.
