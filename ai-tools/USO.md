---
trigger: model_decision
description: Use when reviewing code with the OCR-based tooling in Elixir/Wenia projects — how to invoke each mode (ocr CLI, elixir-review, elixir-review-wenia, team-review), which LLM each uses, how to run a participatory review, and how to pick what team-review wraps.
---

# USO — cómo usar cada pieza

## Tabla rápida: ¿qué invoco y con qué LLM?

| Quiero... | Invoco | LLM que revisa | Requiere config LLM en OCR |
|---|---|---|---|
| OCR engine automático, cualquier stack | `ocr review` / `/ocr-review` / `ocr_review` | el configurado en OCR | Sí |
| **OCR engine automático pero con MI modelo, sin skill de lenguaje** | skill `open-code-review-delegate` | el tuyo (agente host) | No |
| Automático Elixir (OCR + skills Elixir) | `elixir-review` | el tuyo (agente host) | No |
| Automático Wenia (lo anterior + capa Wenia) | `elixir-review-wenia` (o `elixir-review`, que la descubre sola) | el tuyo (agente host) | No |
| Revisar JUNTOS, paso a paso, decidiendo comentarios | `team-review` (`$team-review`) | el tuyo (agente host) | No |
| Escribir comentarios de un PR ajeno | `team-review` o `elixir-review-wenia` + `--rule` | el tuyo (agente host) | No |

**En una frase:** todo lo que construimos (`open-code-review-delegate`,
`elixir-review`, `elixir-review-wenia`, `team-review`) usa **tu modelo** — el
del agente que tienes abierto — y **no** necesita configurar ni pagar el LLM
de OCR. Solo `ocr review` "a pelo" usa el LLM propio de OCR.

## Dos formas de revisar: ¿quién pone el LLM?

OCR separa el **motor determinista** (selección de archivos, reglas,
posicionamiento de comentarios) de **quién razona**:

1. **OCR-managed** (`ocr review`): OCR llama a un LLM configurado por él.
   Necesita `ocr config provider` + API key. Ese LLM puede ser el de OCR o
   **tu propio endpoint** (ver abajo).
2. **Delegation** (`ocr delegate`): OCR solo entrega "qué revisar" y "qué
   reglas" (sin LLM); **el agente host revisa con su modelo**. Es el modo de
   todo lo que construimos. Cero claves en OCR.

## Usar TU propio modelo

**Modo delegación (recomendado, el de nuestros skills):** no configuras nada
en OCR. Tu agente (opencode/Codex/Kiro) razona con el modelo que ya usas.

- Sin skill de lenguaje: carga el skill `open-code-review-delegate` y pídele
  la revisión. El skill hace `ocr delegate preview --format json` y
  `ocr delegate rule ...`, y el agente revisa con su LLM.
- Con Elixir/Wenia: usa `elixir-review` / `elixir-review-wenia` (ver abajo).

**Modo OCR-managed con tu endpoint** (si prefieres que OCR orqueste pero con
tu modelo, p. ej. tu gateway OpenAI-compatible):

```bash
ocr config set provider                             mi-gateway
ocr config set custom_providers.mi-gateway.url      https://mi-gateway/v1
ocr config set custom_providers.mi-gateway.protocol openai   # openai | anthropic | openai-responses
ocr config set custom_providers.mi-gateway.model    <mi-modelo>
ocr config set custom_providers.mi-gateway.api_key  "$MI_API_KEY"
ocr llm test
```

(Sirve también para Ollama local apuntando a `http://127.0.0.1:11434/v1`.
Cualquier nombre fuera de la tabla de providers built-in se trata como
custom y exige al menos `url` y `protocol`.)

O puntual por corrida, sin cambiar la config:

```bash
ocr review --provider mi-gateway --model <mi-modelo>
```

## OCR solito


```bash
ocr review                                   # workspace: staged + unstaged + untracked
ocr review --from main --to mi-rama         # rango (merge-base)
ocr review --commit abc123                   # un commit
ocr review --preview                         # qué se revisaría, sin gastar LLM
ocr review --format json --output out.json   # para agentes
ocr scan --path lib/mi_modulo                # archivos completos, sin diff
ocr session list                             # sesiones; resume con --resume <id>
ocr delegate preview --format json           # delegation: qué revisar (sin LLM)
ocr delegate rule --format json <paths...>   # delegation: reglas agrupadas
```

## elixir-review (wrapper de lenguaje)

Orquesta `open-code-review-delegate` + todos los `elixir-*` instalados
(descubrimiento dinámico por prefijo: agregar/quitar skills fluye solo).
Pídelo en lenguaje natural: *"revisa mis cambios con elixir-review"*.
**Revisa con TU modelo** (delegation): OCR no llama a ningún LLM, no requiere
claves. Cubre OTP/Ecto/antipatrones; las convenciones Wenia entran
automáticamente si `elixir-review-wenia` está instalada (su nombre empieza
por `elixir-`).

## elixir-review-wenia (capa organización)

**También con TU modelo** (delegation). Solo se activa ante señales Wenia
(layout `domain/adapters/entry_point`, `wenia_commons` en `mix.exs`, mención
de `SRV_*`). Añade checklist Wenia con criterio: consenso `[C]` → medium,
recomendado `[R]` → low/medium, preferencias individuales `[P]` → low u
omitir; convenciones nunca critical. PR ajeno sin acceso commit: el skill
pasa `--rule <skill>/references/wenia-rule.json` a los comandos `ocr`.

## team-review (modo equipo): el skill te pregunta lo necesario

Invocación explícita: `$team-review`, *"revisemos este PR juntos"*, *"paso a
paso"*. Con eso basta: al activarse, el skill detecta el contexto y te hace un
**intake de una sola línea** — alcance (PR/ref), **de quién es el PR**, qué
wrapear y modo. Tú confirmas en una frase, p. ej.:
> "de un compañero, PR #592, con wenia, guiado"

Del ownership sale el entregable:
- **Tu PR → fix path:** aplica los fixes que apruebas en tu rama (commit solo
  si lo pides).
- **PR de un compañero → comment path:** solo lectura; publica **un** review
  con los comentarios inline que apruebas; nunca toca su rama.

Targets (motor delegation en todos: revisa **tu modelo**, no el de OCR):
- *ocr solo* → engine OCR (`open-code-review-delegate`), cualquier stack, sin
  skill de lenguaje. (Ej. proyecto Node: jamás arrastra `elixir-review`.)
- *con elixir-review* → Elixir general, sin contexto Wenia.
- *con wenia* → Elixir + todo Wenia (se ofrece solo si se detecta Wenia).

Luego corre el protocolo: overview arquitectónico que validas → plan de
bloques en orden lógico (fundación → borde; en PRs grandes, unidades
atómicas por funcionalidad) → revisión bloque por bloque donde aportas
contexto de negocio (invalida o re-enfoca hallazgos vía `--background`) →
verificación → borradores en tu idioma → aprobación → publish en inglés con
la receta de `comment-templates.md` → knowledge record final. Di *"hazlo
rápido"* en cualquier momento para saltar los gates.

## Severidades (contrato común a todas las capas)

Critical/High: bugs, seguridad, data-loss con escenario concreto. Medium:
contratos, guards, convenciones con contexto. Low: estilo/nits (u omitir).
Ante la duda, degradar. Falsos positivos probables se descartan en silencio.

## Troubleshooting

- `ocr: command not found` → `brew install open-code-review`.
- `unknown flag: --format` → CLI < v1.9.0: `brew upgrade open-code-review`.
- `ocr review` falla con error LLM → configura (`ocr config provider`) o
  usa delegation (sin LLM en OCR).
- `Not inside a trusted directory` (solo `codex exec` fuera de git) →
  agrega `--skip-git-repo-check` o corre desde un repo. El TUI interactivo
  no lo pide (trust onboarding).
- Skill no aparece → reinicia la herramienta; verifica
  `SKILL.md` en mayúsculas, frontmatter `name`/`description`, nombre == directorio.
