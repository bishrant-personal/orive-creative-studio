# Home Studio

A friendly creative studio that runs on Claude Code. You talk to it in plain words, and it quietly brings in the right specialist for the job. There is nothing technical to learn. You describe what you want, you answer a question or two, and the work gets done.

Think of it like walking into a small studio where a warm host greets you at the door. You tell them what you need, and they walk you over to the right expert. The host always tells you who they are bringing in, so you are never left guessing.

---

## What it can do for you

Home Studio handles five kinds of creative work, and each one has a specialist who is good at it.

| If you need help with | Just say something like | And you will get |
|---|---|---|
| Brand and identity | brand, logo direction, moodboard, name, look, vibe | A clear brand brief, naming options, a moodboard with reasons, and a palette and type direction |
| Social content | content, posts, reels, captions, calendar | Hook-first reel scripts, carousel outlines, captions, a posting calendar, and photo shot lists |
| Ads and performance | ads, campaign, metrics, why is it not working | Campaign ideas, ad copy, a plain-language read of your numbers, and changes staged safely for your approval |
| Pricing and proposals | price, quote, invoice, proposal, rate | A tiered quote, a scope of work, an invoice, and a reason behind every number you can defend |
| Research and discovery | research, market, competitors, audience | A scoping brief, a competitor scan, interview or survey guides, and a clear recommendation |

You do not need to remember any names or commands. You can also just type what you want in your own words, and the host will work out who to bring in.

---

## How it works when you type a prompt

The flow is simple and the same every time.

1. You tell the host what you want, in plain language.
2. The host works out which specialist fits, and says so in one friendly line, for example "Got it, I will bring in Pricing for this."
3. If that task needs a tool that is not connected yet, the host asks you for one simple thing, like a sign-in or a single key, and sets it up for you.
4. The specialist does the work using its know-how and any connected tools.
5. The result is saved and backed up to your private GitHub on its own, so nothing is ever lost.

You stay in plain conversation the whole time. The technical parts happen quietly in the background.

---

## What it asks you for

Home Studio only asks for what a task actually needs, one thing at a time, and never a wall of questions at once. Depending on what you want, it might ask:

- Your name, once, so it can greet you properly.
- A plain description of your goal.
- A few simple details, like who the work is for, or whether a client is in Nepal or abroad.
- A sign-in or a single key, but only when a task reaches a tool that needs it, and it shows you exactly where to find it.

That is all. If something is unclear, it offers you a short list to pick from rather than guessing.

---

## What it installs for you

The setup script gets your machine ready and skips anything you already have, so you never install things by hand. It sets up the few tools the studio runs on:

- Node.js, which Claude Code runs on
- git and the GitHub tool, which save and back up your work
- Claude Code itself, the studio's home
- A small browser tool, so the Research and Content specialists can open a live page and grab a screenshot

It does this with the right installer for your machine, so it just works whether you are on Windows, mac, or Linux. The full list of what it needs lives in `REQUIREMENTS.md`.

### Getting started

Clone this repo and run the setup script for your machine.

```
git clone https://github.com/bishrant-personal/home-studio.git home-studio
cd home-studio
```

On Windows:

```
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

On macOS or Linux:

```
./setup.sh
```

To see what is installed without changing anything, add `-CheckOnly` on Windows or `--check` on macOS and Linux.

On the first start, Home Studio greets you, signs you into GitHub so your work is always saved, and offers a few simple things to do first.

---

## Your work is always saved

GitHub is where the studio keeps everything, so you never lose a brief, a quote, or a calendar. You do not have to know anything about git. The host signs you in once, creates a private space for your work, and from then on saves and backs up after every finished task, all on its own. Your keys and secrets are never saved to GitHub, only your work is.

---

## Connecting your tools is just a sign-in or a paste

When a task needs a service like Figma, Google, or free stock images, the host walks you through it in plain steps and asks for only one thing at the end. For most services that is a single click to sign in. For a few it is one key, and the host tells you exactly where to find it and pastes it in for you. Once something is connected, you are never asked for it again.

---

## The studio has taste

Every specialist shares one creative point of view, so the brand, the content, and the ads all feel like they came from the same mind. A few of the ideas it works by:

- Start from meaning, so every choice serves an idea or a feeling.
- Strategy before style, so the look follows the thinking.
- Taste is editing, so the strongest work leaves the noise out.
- Offer a view, not a lecture, so you get a few clear options with a reason for each, and you decide.

And one rule it never breaks anywhere: it never uses an em dash. It writes in warm, simple, naturally flowing sentences instead.

---

## What is inside

- A host you talk to, and five specialists who each do one kind of work well, with a sixth that schedules and files your work.
- A set of skills, which is the studio's know-how kept tidy and separate.
- A connection wizard that sets up a tool only when a task needs it.
- House rules, voice, and the creative point of view, all in `CLAUDE.md`.

The full plan and build sequence is in `home-studio-build-brief.md`. Made with care by Bishrant Tandukar.
