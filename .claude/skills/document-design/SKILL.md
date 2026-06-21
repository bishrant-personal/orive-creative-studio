---
name: document-design
description: How to make documents that look designed, not typed. Structure, hierarchy, and a clean render path for PDFs, presentations, invoices, quotes, proposals, brochures, and decks. Read by any specialist producing a document.
---

# Document Design

A document is a first impression. Anything the studio hands over, a quote, a proposal, an invoice, a brochure, a deck, should look considered, not typed. This skill carries the structure and the craft, plus the render path. No em dashes, ever.

## The principles

- **Structure first.** Decide the spine before the styling: a clear title, a short summary or hook, the body in a logical order, and a single clear next step at the end. Most documents fail on structure, not looks.
- **One clear hierarchy.** A reader should see the shape in three seconds. One title size, one heading size, one body size, used consistently. Never more than three levels.
- **Whitespace is a feature.** Generous margins and space between blocks read as premium. Crowding reads as cheap. When in doubt, remove, do not add.
- **Align to a grid.** Everything lines up to the same left edge and a small set of columns. Ragged alignment is the fastest way to look amateur.
- **Restrained type.** One or two typefaces at most. A clean sans for the body is safe. Size and weight carry the hierarchy, not many fonts.
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

The studio installs `pandoc` and `wkhtmltopdf` (see `REQUIREMENTS.md`). The reliable way to a designed PDF is to write clean HTML or markdown, style it with a small CSS, and render with pandoc.

```
pandoc input.md -o output.pdf --pdf-engine=wkhtmltopdf --css=styles.css -V margin-top=20 -V margin-bottom=20
```

A safe base `styles.css` to adapt per brand:

```css
body { font-family: -apple-system, "Segoe UI", Helvetica, Arial, sans-serif; color: #1a1a1a; line-height: 1.5; }
h1 { font-size: 26px; margin: 0 0 4px; }
h2 { font-size: 16px; color: #444; font-weight: 600; margin-top: 28px; }
.accent { color: #c0392b; }            /* swap for the brand accent */
table { width: 100%; border-collapse: collapse; margin: 16px 0; }
th { text-align: left; border-bottom: 2px solid #1a1a1a; padding: 8px 6px; }
td { padding: 8px 6px; border-bottom: 1px solid #eee; }
td.amount, th.amount { text-align: right; }
.total { font-weight: 700; border-top: 2px solid #1a1a1a; }
```

For a slide deck, pandoc can target `pptx` or an HTML slide format. For a Word handover, target `docx`. Generated files go under `outputs/` or the client folder, and the host saves them. Use ImageMagick to size and place any reference images, and credit photographers per `image-sources`.

## The bar

Before handing a document over, check it: is the hierarchy clear in three seconds, does it lead with the answer, do the numbers line up, is there enough whitespace, is the palette restrained, and is there one clear next step. If not, fix it before showing the user. No em dashes, anywhere.
