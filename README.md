# 🎨 Orive Creative Studio

**A friendly creative studio that runs on Claude Code.** You talk in plain words, and it brings in the right specialist for the job. There is nothing technical to learn.

Think of it like walking into a small studio where a warm host greets you at the door, listens to what you need, and walks you over to the right expert. 🙂

> **Want to jump in?** On Windows, paste this into PowerShell:
> `irm https://raw.githubusercontent.com/bishrant-personal/orive-creative-studio/main/bootstrap.ps1 | iex`
> On macOS or Linux, see [Get started](#-get-started) below.

---

## Contents

1. [What it can do](#-what-it-can-do)
2. [How it works](#-how-it-works)
3. [Try saying](#-try-saying)
4. [Make it yours](#-make-it-yours)
5. [Good to know](#-good-to-know)
6. [Use it anywhere](#-use-it-anywhere)
7. [Get started](#-get-started)
8. [The technical bits](#-the-technical-bits)

---

## ✨ What it can do

Five kinds of creative work, each with a specialist who is good at it.

| You need help with | Just say | And you get |
|---|---|---|
| 🪄 Brand and identity | brand, logo, moodboard, name, vibe | A brand brief, naming options, a moodboard, and a palette and type direction |
| 📱 Social content | content, posts, reels, captions, calendar | Reel scripts, carousels, captions, a posting calendar, and shot lists |
| 📈 Ads and performance | ads, campaign, metrics, why is it not working | Campaign ideas, ad copy, a plain read of your numbers, changes staged for approval |
| 💰 Pricing and proposals | price, quote, invoice, proposal, rate | A tiered quote, a scope of work, an invoice, and a reason you can defend |
| 🔍 Research and discovery | research, market, competitors, audience | A scoping brief, a competitor scan, interview guides, and a clear recommendation |

Behind these sit a full crew you can also reach: a **videographer**, **cinematographer**, **concept artist**, **set designer**, **copywriter**, and **UX writer**, plus a **hospitality** specialist for hotels and tourism. The host brings in whoever fits, and runs a small crew when a job needs more than one.

You never need to remember names. Just say what you want in your own words.

---

## 💬 How it works

1. You tell the host what you want, in plain words.
2. It names the specialist it is bringing in, for example "Got it, I will bring in Pricing for this."
3. If a tool is needed and not connected, it asks for one simple thing, a sign-in or a key.
4. The specialist does the work.
5. The result is saved and backed up to your private GitHub on its own.

<details>
<summary>See a sample conversation</summary>

<br>

```
👋 Hello! Welcome, Bishrant.

I can help with branding, content, ads, pricing, and research.
You do not need to know any of the technical bits.

What would you like to do first?

  1. Set up a new brand or moodboard
  2. Plan social posts or reels
  3. Build a price quote for a client
  4. Research a market or competitors
  5. Just connect my tools first

Type a number, or tell me in your own words.
```

Pick 3, and it stays just as friendly while it gathers the few things it needs, then builds your quote.

</details>

---

## 💡 Try saying

- "Build a moodboard and naming shortlist for a Kathmandu streetwear label."
- "Give me a week of reels for a coffee roaster, made for saves."
- "Read the last 30 days and tell me where my ad spend is wasted."
- "Quote a 5-screen landing page for a US SaaS startup."
- "Scope a competitor scan for premium dog food in Nepal."

Not sure who you need? Just say the goal, like "I want to launch a clothing brand on Instagram," and the host picks the right specialist for you.

---

## 🎭 Make it yours

Choose how the studio talks to you. The tone changes, the quality of the work never does.

- **The Director**, a fearless creative lead who tells you the answer.
- **The Sage**, calm and wise, makes you think.
- **The Bestie**, warm and funny, has your back.
- **Straight Shooter**, no nonsense, but it teaches.

Keep it plain if you like, or nudge it any time with something like "less sass today."

---

## 🙋 Good to know

- **It asks for little.** Only what a task needs, one thing at a time, never a wall of questions.
- **Your work is always saved.** It signs you into GitHub once, then backs up every finished piece on its own. Your keys are never saved, only your work.
- **Connecting a tool is a sign-in or a paste.** It walks you through it in plain steps and never asks twice.
- **It tells the truth.** It never invents a number, a source, or a link, and it says how sure it is.

---

## 🌐 Use it anywhere

One studio, the same host and specialists, wherever you talk to Claude.

| Where | What you get |
|---|---|
| Terminal (Claude Code CLI) | Full power: saves to GitHub, connects tools, runs real workflows |
| Claude Code desktop | The same, in a desktop window, via the Plugins tab |
| Chat | The host and the specialist craft. It points you to the terminal for anything that needs to run |
| Cowork | The host and specialists driving the work in a visual space |

Install it the same way everywhere: add the marketplace, then install.

```
/plugin marketplace add bishrant-personal/orive-creative-studio
/plugin install orive-creative-studio@orive
```

---

## 🚀 Get started

**The easiest way, one line.** It fetches the studio and starts it.

On Windows, in PowerShell:

```
irm https://raw.githubusercontent.com/bishrant-personal/orive-creative-studio/main/bootstrap.ps1 | iex
```

On macOS or Linux, in a terminal:

```
curl -fsSL https://raw.githubusercontent.com/bishrant-personal/orive-creative-studio/main/bootstrap.sh | bash
```

**Prefer to click?** On Windows, download this repo and double-click `setup.cmd`.

On the first start, the studio greets you, signs you into GitHub so your work is saved, and offers a few simple things to do first.

---

## 🛠️ The technical bits

If you just wanted to know what Orive Creative Studio does, you are all set. The rest is for setting it up and taking it apart.

<details>
<summary>Install by hand</summary>

<br>

```
git clone https://github.com/bishrant-personal/orive-creative-studio.git orive-creative-studio
cd orive-creative-studio
```

Then on Windows run `.\setup.cmd` (or `powershell -ExecutionPolicy Bypass -File .\setup.ps1`), and on macOS or Linux run `./setup.sh`.

To check what is installed without changing anything, add `-CheckOnly` on Windows or `--check` on macOS and Linux. The scripts always run from their own folder, so they work no matter where you start them.

</details>

<details>
<summary>What it installs on your machine</summary>

<br>

It sets up the few tools the studio runs on, and skips any you already have:

- Node.js, git, the GitHub tool, and Claude Code itself
- A small browser tool for opening live pages and screenshots
- Creative tools so the studio can make real files: ffmpeg for video, ImageMagick for images, and pandoc with a PDF maker for polished documents

It uses the right installer for your machine (winget, Homebrew, or apt). Docker and Python are optional and only added if you ask. The full list is in `REQUIREMENTS.md`.

</details>

<details>
<summary>How to uninstall</summary>

<br>

**Remove just the studio:** delete the project folder. Your work is still safe in your private GitHub repo.

```
rm -rf orive-creative-studio
```

**Remove the browser tool's downloads:**

```
# Windows
Remove-Item -Recurse -Force "$env:USERPROFILE\AppData\Local\ms-playwright"
# macOS and Linux
rm -rf ~/.cache/ms-playwright
```

**Remove Claude Code:** `npm uninstall -g @anthropic-ai/claude-code`, or run its native uninstaller.

The shared tools (Node, git, the GitHub tool, Docker, Python) are used by other apps, so remove them only if you are sure.

</details>

<details>
<summary>What is inside the project</summary>

<br>

- A host you talk to, and a roster of specialists who each do one kind of work well.
- A set of skills, the studio's know-how kept tidy and separate.
- A connection wizard that sets up a tool only when a task needs it.
- House rules, voice, and the creative point of view, all in `CLAUDE.md`.

The full plan and build sequence lives in `orive-build-brief.md`.

</details>

---

Made with care by Bishrant Tandukar. ✨
