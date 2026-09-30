#!/bin/sh
# ai-tools/install.sh — instalador mecánico idempotente del sistema OCR+skills.
# Cubre: CLI ocr, plugin opencode, skills propios (symlinks), regla global.
# Los skills de terceros y el cableado del workspace Wenia van manual (SETUP.md).
set -eu

AI_TOOLS_DIR="$(cd "$(dirname "$0")" && pwd)"

need() { command -v "$1" >/dev/null 2>&1 || { echo "falta: $1" >&2; exit 1; }; }
need git
git --version | awk '{split($3,v,"."); if (v[1] < 2 || (v[1]==2 && v[2]<41)) {print "git >= 2.41 requerido" > "/dev/stderr"; exit 1}}'

# 1. OCR CLI
if command -v ocr >/dev/null 2>&1; then
  echo "ocr ya instalado: $(ocr --version | head -n1)"
elif command -v brew >/dev/null 2>&1; then
  brew install open-code-review
else
  echo "instala ocr manual: npm install -g @alibaba-group/open-code-review" >&2
fi

# 2. Plugin opencode
mkdir -p "$HOME/.config/opencode/plugins"
if [ ! -f "$HOME/.config/opencode/plugins/open-code-review.ts" ]; then
  curl -fsSL https://raw.githubusercontent.com/alibaba/open-code-review/main/plugins/open-code-review/opencode/open-code-review.ts \
    -o "$HOME/.config/opencode/plugins/open-code-review.ts"
  echo "plugin open-code-review instalado (reinicia opencode)"
else
  echo "plugin open-code-review ya presente"
fi

# 3. Skills propios -> symlinks (una sola fuente de verdad)
mkdir -p "$HOME/.agents/skills"
for s in elixir-review team-review collaborative-pr-review elixir-review-wenia; do
  if [ -d "$AI_TOOLS_DIR/skills/$s" ]; then
    if [ -e "$HOME/.agents/skills/$s" ] && [ ! -L "$HOME/.agents/skills/$s" ]; then
      rm -rf "$HOME/.agents/skills/$s"   # copia real previa: fuente pasa a ser ai-tools
    fi
    ln -sfn "$AI_TOOLS_DIR/skills/$s" "$HOME/.agents/skills/$s"
    echo "skill enlazado: $s"
  fi
done

# 4. Regla Elixir global
mkdir -p "$HOME/.opencodereview"
if [ ! -f "$HOME/.opencodereview/rule.json" ]; then
  cp "$AI_TOOLS_DIR/rule.json.d/elixir-global-rule.json" "$HOME/.opencodereview/rule.json"
  echo "rule.json global instalado"
else
  echo "~/.opencodereview/rule.json ya existe (no tocado)"
fi

echo "listo. Siguiente: SETUP.md pasos 3 (skills terceros), 6 (workspace Wenia) y 7 (verificación)."
