#!/usr/bin/env bash
# Install the studio's font set from the open google/fonts library, per user.
# Safe to run repeatedly, it skips fonts already present. No em dashes, ever.
# Google Sans is proprietary and not in the open library, so it is skipped.

names=("Inter" "IBM Plex Sans" "IBM Plex Mono" "Montserrat" "Lato" "Nunito" \
       "Playfair Display" "Archivo Black" "Manrope" "Bitcount Prop Single" \
       "Chelsea Market" "Libre Baskerville" "Changa One" "EB Garamond" \
       "Urbanist" "League Script" "Dancing Script" "Yesteryear")

case "$(uname -s 2>/dev/null)" in
  Darwin*) FD="$HOME/Library/Fonts" ;;
  *)       FD="$HOME/.local/share/fonts" ;;
esac
mkdir -p "$FD"

fetch_urls() { # $1 = repos/google/fonts/contents/<dir>/<slug>
  if command -v gh >/dev/null 2>&1; then
    gh api "$1" --jq '.[]|select(.name|endswith(".ttf")).download_url' 2>/dev/null
  else
    curl -fsSL -H "User-Agent: orive-creative-studio" "https://api.github.com/$1" 2>/dev/null \
      | node -e "let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{try{JSON.parse(d).filter(x=>x.name&&x.name.endsWith('.ttf')).forEach(x=>console.log(x.download_url))}catch(e){}})"
  fi
}

echo "Installing the studio fonts, this is a quick download."
for n in "${names[@]}"; do
  slug=$(echo "$n" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
  urls=""
  for d in ofl apache ufl; do
    urls=$(fetch_urls "repos/google/fonts/contents/$d/$slug")
    [ -n "$urls" ] && break
  done
  if [ -z "$urls" ]; then echo "  skip $n (not in the open font library)"; continue; fi
  echo "$urls" | while read -r u; do
    [ -z "$u" ] && continue
    fn=$(basename "$u" | sed 's/%5B/[/g;s/%5D/]/g;s/%2C/,/g')
    [ -f "$FD/$fn" ] || curl -fsSL "$u" -o "$FD/$fn"
  done
  echo "  installed $n"
done

command -v fc-cache >/dev/null 2>&1 && fc-cache -f >/dev/null 2>&1
echo "Fonts done. The studio uses these for design and document work."
