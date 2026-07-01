#!/usr/bin/env bash
# Self-host the three brand fonts (TODO(liam) — run this, then QA in a real browser).
#
# Why this is a script and not already shipped: swapping Google Fonts for self-hosted
# files across 11 pages is a real LCP win, but a wrong path silently falls back to a
# system font site-wide. That needs a real-browser eyeball, which the build sandbox
# can't do — so this does the heavy lifting and leaves you the 2-minute QA + flip.
#
# Usage:
#   bash _gen/self-host-fonts.sh          # downloads woff2 into ./fonts and writes ./fonts.css
# Then, in each page's <head>, replace the two Google Fonts <link> lines with:
#   <link rel="preload" href="/fonts/bricolage-800.woff2" as="font" type="font/woff2" crossorigin>
#   <link rel="stylesheet" href="/fonts.css">
# Reload the site in Chrome + Safari and confirm the headings/body look identical, then commit.

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p fonts
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36"
CSSURL="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400;12..96,600;12..96,700;12..96,800&family=Public+Sans:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap"

echo "→ fetching font CSS…"
raw=$(curl -s -A "$UA" "$CSSURL")

# Keep only the 'latin' subset blocks (US site) to minimise file count.
echo "$raw" | awk 'BEGIN{RS="}"} /\/\* latin \*\//{print $0 "}"}' > fonts.css.tmp

echo "→ downloading woff2 files…"
i=0
while read -r url; do
  [ -z "$url" ] && continue
  fn="fonts/font-$i.woff2"
  curl -s -A "$UA" "$url" -o "$fn"
  # rewrite this exact url -> local path
  sed -i '' "s#$url#/fonts/font-$i.woff2#g" fonts.css.tmp
  i=$((i+1))
done < <(grep -oE 'https://[^)]+\.woff2' fonts.css.tmp | sort -u)

mv fonts.css.tmp fonts.css
echo "✓ wrote fonts.css and $i woff2 file(s) into ./fonts"
echo "  Next: swap the Google <link> lines for the preload + fonts.css lines above, QA, commit."
