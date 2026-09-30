# AI Tools — revisión de código con OCR + skills

Sistema de code review en 3 capas, sin duplicación entre ellas:

| Capa | Qué es | Dónde vive (origen) |
|---|---|---|
| Motor | `ocr` CLI (alibaba/open-code-review) + skills oficiales `open-code-review` / `open-code-review-delegate` + plugin opencode `open-code-review.ts` | Upstream (se instala, no se vendors) |
| Lenguaje | `elixir-review` (wrapper) + `~/.opencodereview/rule.json` global Elixir/OTP + skills Elixir de terceros | `skills/` (propios) + Skills CLI (terceros) |
| Organización | `elixir-review-wenia` (workspace Wenia) | `skills/` (propio; canonical en workspace) |
| Participativo | `team-review` (agnóstico; tú eliges qué wrapea) + `collaborative-pr-review` (protocolo) | `skills/` (propios) |

## Contenido de este directorio

- `SETUP.md` — replicación paso a paso en máquina nueva o para un compañero.
- `USO.md` — guía de uso: ocr solo, elixir-review, elixir-review-wenia,
  team-review (y cómo decirle qué wrapear). Incluye tabla fast vs team.
- `install.sh` — instalador mecánico idempotente (ocr, plugin opencode,
  symlinks de skills propios, rule global). Los skills de terceros y el
  cableado del workspace Wenia van manual según `SETUP.md`.
- `skills/` — fuente versionada de los skills propios:
  `elixir-review/`, `team-review/`, `collaborative-pr-review/`,
  `elixir-review-wenia/` (con `references/wenia-rule.json` y
  `references/wenia-checklist.md`).
- `rule.json.d/elixir-global-rule.json` — checklist Elixir/OTP global
  (se instala como `~/.opencodereview/rule.json`).

## Regla de mantenimiento

`ai-tools/skills/` es la fuente versionada de lo propio. Lo instalado en
`~/.agents/skills/` son symlinks a (o copias de) esto; el skill Wenia además
vive canónico en el workspace (`WeniaCustomers/.agents/skills/`, con symlink
global de respaldo). Nunca edites solo la copia instalada: edita aquí y
reinstala.
