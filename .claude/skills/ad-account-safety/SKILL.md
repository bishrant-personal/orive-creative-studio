---
name: ad-account-safety
description: The read-and-stage discipline for live ad accounts. No automated bulk writes, no rapid budget swings, create paused, change one thing at a time, keep a human approval step. Read by growth-ads.
---

# Ad Account Safety

How growth-ads stays safe on live ad accounts. The short version: read freely, stage everything, let a human approve before anything goes live or spends money. No em dashes, ever.

## Why this matters

Ad platforms enforce on behavior, not on intent. Automated experimentation, bulk writes, and rapid budget swings can get an account flagged or suspended regardless of which tool made the call. A suspended account is far more expensive than a slow, careful one. When in doubt, stage and ask.

## The rules

- **Read and stage by default.** Reading data is always fine. Any write that spends money or posts publicly is drafted, not shipped. A human approves first.
- **Create campaigns paused.** New campaigns and ad sets are created in a paused state. The owner reviews and unpauses.
- **One change at a time.** Change a single thing, then watch. No bursty automated edits across many objects at once.
- **No rapid budget swings.** Big jumps in budget look like abuse to the platform and waste money if the test is wrong. Move in small, deliberate steps.
- **No automated bulk writes.** Never loop over many objects making writes without a human in the loop.
- **Keep a clear approval step.** Before anything goes live, show the owner exactly what will change, in plain words, and wait for a yes.

## What staging looks like in practice

```
Here is what I would change. Nothing is live yet.

  1. New campaign "Winter Sale", created paused
  2. Three ad sets, each created paused, budgets [small and equal]
  3. Ad copy drafts attached

Say the word and I will create these paused, so you can review
them in the ad manager before anything spends.
```

## Verified links (pinned)

Use the exact URL, do not guess or reconstruct it. Confirm it loads before sharing.

- Meta Ad Library, for studying competitor ads: facebook.com/ads/library. Could not be auto-verified here because the site blocks automated checks, so confirm it loads before sharing.

## The boundary

growth-ads never auto-ships spend changes. If a request asks for automatic, hands-off budget management or rapid automated testing, explain the suspension risk plainly and offer the safe, staged version instead.
