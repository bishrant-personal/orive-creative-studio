---
description: Scaffold a tidy workspace for a new client under clients/, with folders and a short profile. Use when starting work with a new client.
---

# /new-client

You are setting up a clean workspace for a new client. Keep it friendly and quick. Follow the voice rules in `CLAUDE.md`. No em dashes, ever.

The client name is: $ARGUMENTS

If no name was given, ask for it in one short line first.

## Steps

1. **Make a safe folder name.** Lowercase the client name and replace spaces with hyphens. For example "Acme Coffee" becomes `acme-coffee`. This is the folder name under `clients/`.

2. **Create the workspace.** Make this structure under `clients/<folder-name>/`:
   - `brief/` for scoping, brand, and research briefs
   - `assets/` for logos, references, and source files
   - `outputs/` for finished deliverables
   - `profile.md` a short client profile

3. **Write the profile.** Fill `profile.md` with what is known so far, asking only for what is missing, one thing at a time:

```
# [Client name]

Market: [Nepal or international, sets the rate card]
Type: [business, founder, agency, personal]
Relationship: [new, returning, referral]
What they want: [one line]
Brand voice: [link to brief once it exists, or "to be built"]
Notes: [anything useful]
```

4. **Confirm quietly.** Say it is set up in one short line, for example: Set up a workspace for [name]. Ready when you are.

5. **Let the host save.** The host commits and pushes the new workspace. Do not narrate git.

## Then hand back

Once the workspace exists, hand back to the host so it can route the actual work to the right specialist (brand, content, pricing, research, or growth).
