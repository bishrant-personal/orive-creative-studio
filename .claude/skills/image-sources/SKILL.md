---
name: image-sources
description: How to search and use free stock images, with Pexels as the default. Holds the search call shape, license and attribution notes, and the rule to credit photographers. Used by brand-architect for moodboards and content-studio for visuals.
---

# Image Sources

How to find and use free stock images and video for references, moodboards, and content. Pexels is the default. References are curated and credited, never passed off as original or protected work. No em dashes, ever.

## Default source: Pexels

The Pexels API key lives in the local env as `PEXELS_API_KEY` (gitignored, never committed). If it is not set yet, the host runs `/connect pexels` to set it up. Do not ask the user for the key directly, route through the wizard.

### Search call shape

Send the key in the `Authorization` header.

```
GET https://api.pexels.com/v1/search?query=[terms]&per_page=[n]&orientation=[landscape|portrait|square]
Header: Authorization: [PEXELS_API_KEY]
```

A harmless validation call is `query=ocean&per_page=1`.

### Facts to keep in mind

- The key is free. The photos and videos are royalty-free for personal and commercial use.
- Default limits are 200 requests an hour and 20,000 a month, which is plenty for studio work.
- Credit the photographer when you can, for example "Photo by [name] on Pexels" with a link back. Full attribution is what unlocks the free unlimited tier if it is ever needed.
- One API key per account.

## Alternatives

Unsplash (`UNSPLASH_ACCESS_KEY`) and Pixabay (`PIXABAY_API_KEY`) are also free and set up the same way: free account, get a key, paste it back through `/connect`. Re-check each provider's current steps at setup time.

## Verified links (pinned)

Use these exact URLs, do not guess or reconstruct them. Re-check before sharing if it has been a while.

- Pexels API and key signup: https://www.pexels.com/api/ (verified reachable 2026-06-22)

## House rules for using images

- Moodboards and creative cite and curate. They never reproduce protected artwork, characters, or brand IP.
- Always state where a reference came from.
- Prefer a credited free source over an uncertain one.
