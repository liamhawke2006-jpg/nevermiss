# NeverMiss site optimization — change log & handoff

End-to-end optimization of the public marketing site (home, /plumbers, 6 generated trade pages,
/roi, /compare, /copilot). Brand, voice, colors, and layout preserved — enhanced, not redesigned.
The 6 trade pages are generated from `_gen/gen-verticals.js`; edit the template + `node _gen/gen-verticals.js`.

## What shipped

### P1 — Measurement
- **Plausible** analytics (cookieless, `defer`) on every public page.
- One delegated `nmTrack()` helper auto-fires **Call** (`tel:`), **Book Call** (calendar), **Get Started**
  (onboard) + supports `data-nm-event` / `data-nm-loc`. Verified firing in headless.
- Documented (commented) Google Search Console `<meta>` slot on every page.

### P2 — SEO & structured data
- Home `LocalBusiness`+`ProfessionalService`: 7-city `areaServed`, `geo`, 24/7 `openingHoursSpecification`,
  `PostalAddress`, `priceRange`, + a dedicated `Service` schema.
- `BreadcrumbList` JSON-LD + **visible breadcrumbs** on all sub-pages.
- Trade `Service` schema: 7-city `areaServed`, `telephone`, `serviceType`.
- Service-area cities woven into copy (hero + footer) on home + trade pages; cross-links between all
  trade pages ↔ ROI ↔ Compare.
- `sitemap.xml`: removed `/onboard/` (it is `noindex`), refreshed dates. `/copilot` kept out (noindex).
- **All 28 JSON-LD blocks validate; unique titles + descriptions across pages.**

### P3 — Conversion
- **Sticky mobile CTA** on every funnel page (Hear it live + Book), safe-area insets, auto-hides over
  the footer, mobile-only, reduced-motion aware. Verified at mobile width.
- Social proof: stat/rating band (top of funnel) + 3 testimonial cards (above pricing) — all
  `TODO(liam)` placeholders in the existing card styling. Nothing fabricated.
- "sample" labels on illustrative UI (hero call-log, results dashboard; See-it already labeled).
- Honest static scarcity line near hero + pricing (from the founder's real "few new shops a month").

### P4 — Design polish & accessibility
- Trade/plumbers/compare headers brought up to the homepage system: sticky + backdrop-blur + real nav
  (Pricing / FAQ / Hear it live), collapses < 720px.
- **Contrast:** measured every text/bg pair; fixed the only AA failures (`#8C9A93` captions on light
  → `#59615C`, ~6:1). Green accents all sit on dark (8.3:1).
- Visible `:focus-visible` keyboard rings site-wide; universal `prefers-reduced-motion` guard;
  `:active` states on buttons. No missing `alt`; no horizontal overflow.

### P5 — Speed & technical
- Help-bot **`widget.js` now lazy-loads** on first interaction or idle (was on initial paint) —
  verified 0 widget requests at paint. Protects LCP/INP.
- `founder.jpg`: explicit `width`/`height` + `loading="lazy"` + `decoding="async"` (kills CLS) + richer alt.
- **Web app manifest** (`site.webmanifest`) + real 192/512 PNG app icons + `apple-touch-icon`, linked on all pages.
- Safe `referrer` policy meta site-wide.

## Before / after performance (honest note)
A true mobile Lighthouse run needs a real headless-Chrome+Lighthouse pass that this build environment
can't run reliably, so **no fabricated scores here.** The concrete, metric-moving changes made:
- **CLS ↓** — explicit image dimensions on `founder.jpg`; font-display: swap already in place.
- **INP / TBT ↓** — `widget.js` deferred off the critical path to idle/first-interaction.
- **LCP** — unchanged markup weight; further win available via font self-hosting (see TODO).
**Action:** after deploy, run PageSpeed Insights on https://nevermissai.net and each trade page to
capture real LCP/CLS/INP. Structure is in place to hit ≥95 SEO/Best-Practices/Accessibility.

## TODO(liam) — needs your input or a real-browser QA
1. **Plausible** — create account, add site `nevermissai.net` (events queue safely until then).
2. **Google Search Console** — paste your token into the commented `<meta>` on each page and uncomment.
3. **Social proof** — replace the stat-band numbers (shops live / avg rating / calls / jobs) and the
   3 testimonial quotes (name · business · city). Delete any stat you can't back up. Add a "★ on Google"
   line only with verified reviews.
4. **Fonts (self-host)** — run `bash _gen/self-host-fonts.sh`, swap the two Google `<link>` lines for the
   preload + `fonts.css` lines noted in the script, QA in Chrome + Safari, commit. (~10–15% LCP win.)
5. **Images to WebP** — this box has no `cwebp`. On your Mac: `cwebp founder.jpg -q 82 -o founder.webp`
   then wrap the `<img>` in `<picture>` with the jpg fallback. (og-image.png: leave as PNG — social
   platforms expect that fixed URL.)
6. **Security headers** — GitHub Pages can't set response headers, so:
   - **HSTS:** enable **Settings → Pages → Enforce HTTPS** (GitHub then serves HSTS). One click.
   - **CSP:** best done at a host that supports headers (or Cloudflare in front). A starting policy:
     `default-src 'self'; script-src 'self' 'unsafe-inline' https://plausible.io https://nevermiss-agent-production.up.railway.app; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https://plausible.io https://nevermiss-agent-production.up.railway.app; frame-src https://nevermiss-agent-production.up.railway.app; base-uri 'self'`
     — test it against the live help-bot before enforcing (the widget loads external resources).
7. **Telephone consistency (FYI)** — schema uses your business line `+1-562-212-3121`; click-to-call links
   use the demo line `(562) 573-5967`. Both intentional; reconcile if you want one canonical number.
