#!/bin/sh
# Roda sozinho quando o container liga. Usa as variaveis do Easypanel (aba Ambiente):
#   SITE_URL     endereco final do site, ex.: https://triolux.com.br  (sem barra no fim)
#   CRM_URL      endereco do CRM, ex.: https://cmr-triolux-crm.nrzz4w.easypanel.host  (sem barra no fim)
#   VITRINE_URL  (opcional) endereco do catalogo; se vazio usa CRM_URL/vitrine
#   CHAT_URL     (opcional) endereco do chat; se vazio usa CRM_URL/chat
ROOT="${SITE_ROOT:-/usr/share/nginx/html}"
URL="${SITE_URL%/}"
CRM="${CRM_URL%/}"
[ -n "$CRM" ] || CRM="https://cmr-triolux-crm.nrzz4w.easypanel.host"
VIT="${VITRINE_URL:-$CRM/vitrine}"
CHAT="${CHAT_URL:-$CRM/chat}"

esc() { printf '%s' "$1" | sed 's/[&|\\]/\\&/g'; }
sed -i -e "s|__VITRINE_URL__|$(esc "$VIT")|g" -e "s|__CHAT_URL__|$(esc "$CHAT")|g" -e "s|__CRM_URL__|$(esc "$CRM")|g" "$ROOT/index.html"

if [ -n "$URL" ]; then
  URL_ESC=$(esc "$URL")
  sed -i "s|__SITE_URL__|$URL_ESC|g" "$ROOT/index.html"
  printf 'User-agent: *\nAllow: /\n\nSitemap: %s/sitemap.xml\n' "$URL" > "$ROOT/robots.txt"
  printf '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n  <url><loc>%s/</loc></url>\n</urlset>\n' "$URL" > "$ROOT/sitemap.xml"
else
  # sem endereco definido: tira o que precisa de endereco completo e deixa os caminhos relativos
  sed -i -e '/<!--abs-->/d' -e '/^ *"[a-z]*": "__SITE_URL__/d' -e 's|__SITE_URL__||g' "$ROOT/index.html"
fi
