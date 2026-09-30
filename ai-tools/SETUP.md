# SETUP — replicar el sistema en máquina nueva o con un compañero

Tiempo estimado: 15–20 min. Todo verificado en macOS (Apple Silicon) con
opencode 1.x, Codex CLI y kiro-cli.

## 0. Requisitos

- `git >= 2.41` — `git --version` (OCR lo exige para diffs y file selection).
- Node 18+ — `node --version` (Skills CLI + plugin opencode).
- Homebrew (macOS) — o adapta el paso 1 a tu package manager.
- Este repo de dotfiles clonado (para `ai-tools/`).

## 1. Motor OCR (upstream, no se vendors)

```bash
brew install open-code-review
ocr --version   # >= 1.9.0 (necesario para --format json en delegation)
```

Alternativas oficiales: `npm install -g @alibaba-group/open-code-review` o el
`install.sh` de `alibaba/open-code-review`. En macOS se recomienda brew
(sin sudo, `brew upgrade` para actualizar).

## 2. Plugin opencode (upstream)

El archivo `open-code-review.ts` registra `ocr_review`, `ocr_health`,
`/ocr-review`, `/ocr-health`. Requiere `@opencode-ai/plugin` (opencode 1.x).

```bash
mkdir -p ~/.config/opencode/plugins
curl -fsSL https://raw.githubusercontent.com/alibaba/open-code-review/main/plugins/open-code-review/opencode/open-code-review.ts \
  -o ~/.config/opencode/plugins/open-code-review.ts
cd ~/.config/opencode && npm init -y 2>/dev/null
npm install @opencode-ai/plugin   # omite si ya está en package.json
```

O hazlo correr con `ai-tools/install.sh` (hace los pasos 1, 2, 4 y 5).
Reinicia opencode después.

> Nota: solo las herramientas del plugin (`ocr_review`, `/ocr-review`) usan el
> LLM propio de OCR y exigen `ocr config provider` → `ocr config model` →
> `ocr llm test`. Todos los skills que instalamos (`open-code-review-delegate`,
> `elixir-review`, `elixir-review-wenia`, `team-review`) usan **delegation**:
> revisan con TU modelo y no requieren configurar el LLM de OCR.

## 3. Skills de terceros (Elixir globales + archify, no propios)

Se instalan con el Skills CLI de Vercel (`skills.sh`, ~70 agentes incl.
opencode/codex/kiro-cli). Con `-g` instala en `~/.agents/skills/`
(universal, enlaza a todos los agentes detectados) sin instalar nada global:

```bash
npx skills find elixir                              # descubre
npx skills add -g -a '*' <owner/repo> --skill <nombre> -y   # instala
npx skills list -g                                  # lista globales
npx skills update -g                                # actualiza los que tengan upstream
```

> Usa `npx`, **no** `pnpm dlx`: en esta máquina `pnpm dlx` falla con
> `self-signed certificate in certificate chain`. `npx` es además la vía
> oficial documentada por el Skills CLI.

Los skills de terceros que usa este sistema (todos globales):
`elixir-otp-patterns`, `elixir-ecto-patterns`, `elixir-antipatterns`,
`elixir-pro`, `elixir-pattern-matching`, `archify` (+ los oficiales
`open-code-review` y `open-code-review-delegate`, que llegan con el repo de
Alibaba). No se usa un `elixir-expert` genérico: el detalle OTP/Ecto/anti-
patrones ya lo cubren los `elixir-*` anteriores.

Nota: `archify` y el resto de terceros viven en `~/.agents/skills/`. Para
Claude Code, enlaza `~/.claude/skills -> ../.agents/skills` (ruta relativa a
`~/.claude`, no a `~`; un `.agents/skills` sin `../` queda roto).

## 4. Skills propios (vendored en `ai-tools/skills/`)

`elixir-review/`, `team-review/`, `collaborative-pr-review/`,
`elixir-review-wenia/` (con `references/`). Instalar como symlinks
(una sola fuente de verdad):

```bash
for s in elixir-review team-review collaborative-pr-review elixir-review-wenia; do
  ln -sfn "$HOME/.dotfiles/ai-tools/skills/$s" "$HOME/.agents/skills/$s"
done
```

Excepción: `elixir-review-wenia` además vive canónico en el workspace
Wenia (`WeniaCustomers/.agents/skills/`); ver paso 5.

## 5. Regla Elixir global

```bash
mkdir -p ~/.opencodereview
cp ai-tools/rule.json.d/elixir-global-rule.json ~/.opencodereview/rule.json
```

## 6. Cableado workspace Wenia (solo máquinas con ese checkout)

```bash
WS=/ruta/a/WeniaCustomers   # ajusta (NO es repo git: es contenedor)
mkdir -p "$WS/.agents/skills"
cp -r ai-tools/skills/elixir-review-wenia "$WS/.agents/skills/"
ln -sfn "$WS/.agents/skills/elixir-review-wenia" "$HOME/.agents/skills/elixir-review-wenia"  # respaldo global
for d in "$WS"/SRV_* "$WS"/LIB_* "$WS"/APP_* "$WS"/GITOPS_* "$WS"/IAC_*; do
  [ -d "$d/.git" ] && [ ! -e "$d/.agents" ] && ln -s ../.agents "$d/.agents"
done
ln -sfn ../.agents/skills "$WS/.kiro/skills"   # skills en Kiro (IDE/CLI)
```

Cada repo de servicio es su propio worktree git: sin el symlink `.agents`
el skill del workspace es invisible ahí (opencode solo sube hasta la raíz
del repo). Para Kiro se necesita `.kiro/skills` (los repos ya traen
`.kiro -> ../.kiro`).

## 7. Verificación (5 min)

```bash
ocr delegate preview --format json --repo <un-repo-git> | head -c 400
ocr rules check --repo <un-repo-git> <un-archivo.ex>   # Source: Global, Pattern: **/*.ex*
opencode run --dir <repo> 'Reply with ONLY yes or no: is a skill named team-review available to you right now?'
```

En TUI: `/ocr-review` (opencode), `$` (codex: debe listar los skills),
`kiro-cli chat --no-interactive '...'` o panel *Agent Steering & Skills*.
Detalle completo de qué validar por herramienta: ver notas de
implementación (detección viva opencode/codex/kiro-cli en workspace y repo).

## 8. Compartir con un compañero

Pásale este directorio + `SETUP.md`: pasos 1–4 y 7 son universales; el 5–6
solo si trabaja en el fleet Wenia (y entonces también necesita el checkout
+ las guías fuente de `customersDocs/AI/reviewCode`, que son biblioteca
humana, no parte instalable).
