---
name: document-design
description: How to make documents that look designed, not typed. Structure, hierarchy, and a clean render path for PDFs, presentations, invoices, quotes, proposals, brochures, and decks. Read by any specialist producing a document.
---

# Document Design

A document is a first impression. Anything the studio hands over, a quote, a proposal, an invoice, a brochure, a deck, should look considered, not typed. This skill carries the structure and the craft, plus the render path. No em dashes, ever.

For anything that lives on a screen, an HTML page, a web UI, an app screen, a microsite, or a rich HTML email, also load the `frontend-design` skill. document-design owns print and document structure; frontend-design owns the screen and pushes for distinctive, non-template visual design. When a deliverable is HTML rendered to PDF (the path below), use both: frontend-design for the look, this skill for the page mechanics.

## The principles

- **Structure first.** Decide the spine before the styling: a clear title, a short summary or hook, the body in a logical order, and a single clear next step at the end. Most documents fail on structure, not looks.
- **One clear hierarchy.** A reader should see the shape in three seconds. One title size, one heading size, one body size, used consistently. Never more than three levels.
- **Whitespace is a feature.** Generous margins and space between blocks read as premium. Crowding reads as cheap. When in doubt, remove, do not add.
- **Align to a grid.** Everything lines up to the same left edge and a small set of columns. Ragged alignment is the fastest way to look amateur.
- **Restrained, modern type.** One or two typefaces at most. Size and weight carry the hierarchy, not many fonts. Headings and titles are always a modern sans, never a serif. A clean sans for the body is safe; a serif is allowed for body text only when an editorial feel is wanted.
- **Right length, not maximal.** Say what the document needs and stop. A proposal is not improved by more clauses, longer paragraphs, or a seventh section. Over-generated content reads as padding and buries the decision. Cut to the shortest version that still does the job.
- **Few badges, not many.** Pills, tags, chips, and coloured labels are loud. One every few lines draws the eye; one on every row is noise that makes a document look like a dashboard, not a designed page. Use a badge only when it carries real meaning that plain text cannot (a single status, one "recommended" flag). Never stack two badges on one item, and never label the obvious. When in doubt, set it as plain text and let weight or colour carry it.
- **A restrained palette.** One accent color plus ink and paper. Use the accent for the title, rules, and the total, not for everything. Pull the accent from the brand if there is one.
- **Numbers in tables, money right-aligned.** Quotes and invoices line their figures on the decimal so they are scannable. Totals stand out with weight or a rule above them.
- **A quiet header and footer.** Name or logo, a document title, a date, and a page number. The same on every page.
- **Lead with the answer.** Put the number, the recommendation, or the one image up top. Detail follows for those who want it.

## Structures that work

- **Quote or proposal:** cover line with a "starts from" figure, a one-paragraph understanding of the goal, the tiered options as a clean table (good, better, best), what is included and not, terms and deposit, and one clear next step. See `proposal-quote-templates` for the wording.
- **Invoice:** sender and client blocks at the top, invoice number and dates, a line-item table with amounts right-aligned, a bold total with a rule above it, and payment details below.
- **Deck or pitch:** one idea per slide, a strong title line per slide, few words and one image, a clear arc (problem, idea, proof, ask). For a hotel or event pitch, lead with the one unforgettable thing.
- **Brochure or one-pager:** a hero line, three to five scannable blocks, and a single call to action.

## The render path

Render a designed document by writing a single self-contained, styled HTML file, then printing it to PDF with a real browser engine. Use **headless Chromium**, which the studio already installs (the Playwright browser; any system Chrome or Edge also works). It renders modern CSS correctly: web fonts, flexbox and grid, background colours, full-bleed sections, `clip-path`, and `@page` rules. `wkhtmltopdf` runs an old engine that mangles all of those, so keep it only for plain, text-only documents.

Write the PDF to a **writable, absolute path**. A relative path can resolve against the browser's own working folder and fail with an access-denied error, and a read-only location fails on the temp file. Use `outputs/` or the client folder.

```
# Render HTML to PDF with headless Chromium.
# "chrome" below is the Playwright Chromium, or a system Chrome / Edge binary.
chrome --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="/absolute/path/outputs/proposal.pdf" \
  "file:///absolute/path/outputs/proposal.html"
```

If the source is markdown, turn it into standalone HTML with pandoc first, then print that HTML with the command above:

```
pandoc input.md -o output.html --standalone --css styles.css
```

For an editable handover instead of a PDF, pandoc goes straight to Word with no engine needed: `pandoc input.md -o output.docx`. For slides, pandoc can target `pptx` or an HTML slide format. Generated files go under `outputs/` or the client folder, and the host saves them. Use ImageMagick to size reference images, and credit photographers per `image-sources`.

## Print layout: clean pages and a full-bleed cover

A designed PDF lives or dies on its page breaks. Control them in the HTML's CSS, never by hand. The trick for a cover that runs edge to edge while the rest keeps even margins is a **named page**:

```css
@page         { size: A4; margin: 15mm 16mm; }  /* every normal page */
@page cover   { margin: 0; }                     /* the cover page only */
.cover        { page: cover; height: 297mm; page-break-after: always; }
.page-break   { page-break-before: always; }     /* sections that should open a page */
.no-break     { page-break-inside: avoid; }      /* a price table or signature block */
```

- **Even margins on every page** come from the default `@page` rule. Do not also pad the body, the two stack and the content looks squeezed.
- **A full-bleed cover as its own page:** give `.cover` the named margin-free page, a fixed `297mm` height, and a page break after it, so a dark or image cover fills page one and nothing spills to a blank second page.
- **Sections start cleanly** with `page-break-before`, and blocks that must not split carry `page-break-inside: avoid`.

After rendering, open the PDF and check it: the cover fills page one with no blank page after, no section is stranded with a single orphan line, and no table or signature block is split across a page edge. Adjust the CSS and re-render until it is clean.

A safe base `styles.css` to adapt per brand (note: headings are sans, never serif):

```css
@page { size: A4; margin: 15mm 16mm; }
body { font-family: "Manrope", "Inter", "Segoe UI", Arial, sans-serif; color: #1a1a1a; line-height: 1.5; }
h1, h2, h3 { font-family: "Manrope", "Inter", "Segoe UI", Arial, sans-serif; } /* modern sans, never serif */
h1 { font-size: 26px; margin: 0 0 4px; }
h2 { font-size: 16px; color: #444; font-weight: 600; margin-top: 28px; }
.accent { color: #c0392b; }            /* swap for the brand accent */
table { width: 100%; border-collapse: collapse; margin: 16px 0; }
th { text-align: left; border-bottom: 2px solid #1a1a1a; padding: 8px 6px; }
td { padding: 8px 6px; border-bottom: 1px solid #eee; }
td.amount, th.amount { text-align: right; }   /* money columns only; prose stays left */
.total { font-weight: 700; border-top: 2px solid #1a1a1a; }
```

## Fonts: use the studio set only

The studio installs a curated font set (see `scripts/install-fonts`). Use only these for any design or document, and pick by role. Use a different font only if the user provides one or asks for a specific one.

- **Headings and titles (modern sans only, never serif):** Inter, Manrope, Urbanist, Montserrat, Archivo Black, Changa One
- **Body and UI sans:** Inter, Manrope, Urbanist, IBM Plex Sans, Lato, Nunito, Montserrat
- **Serif (body or editorial accent only, never headings):** Playfair Display, EB Garamond, Libre Baskerville
- **Display and impact (use sparingly):** Archivo Black, Changa One, Chelsea Market, Bitcount Prop Single
- **Script and accent:** Dancing Script, League Script, Yesteryear
- **Monospace and code:** IBM Plex Mono

Keep it to two type families per piece: a modern sans for headings, and a sans (or, for an editorial feel, a serif) for body. A third face only as a rare accent. Never set a heading in a serif. Note: Google Sans is proprietary and not installable, so use Inter or Manrope in its place unless the user supplies the file.

## The bar

Before handing a document over, check it: is the hierarchy clear in three seconds, are all headings a modern sans (no serif), does it lead with the answer, do the numbers line up while prose stays left-aligned, is there enough whitespace, is the palette restrained, are badges and pills rare and meaningful rather than on every row, is the length right with nothing padded, and is there one clear next step. For a PDF, also confirm the cover is its own full page, the page breaks are clean, and no block is split across a page edge. If not, fix it before showing the user. No em dashes, anywhere.
