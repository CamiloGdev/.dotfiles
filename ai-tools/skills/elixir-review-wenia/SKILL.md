---
name: elixir-review-wenia
description: >
  Review Wenia Elixir microservices (Clean Architecture + DDD with
  domain/adapters/entry_point layers, DomainErrors macros and ErrorMapper
  B00/T00 codes, ModuleInyector ports, MapValidator models, canonical Plug
  routers, AppConfig facades, prom_ex observability) using open-code-review
  delegation plus reviewer preferences distilled from 306 Wenia PR comments.
  Conventions apply with judgment at medium/low severity; high/critical is
  reserved for bugs, security, or data-loss risks. Use when reviewing a Wenia
  Elixir PR, writing review comments on someone else's PR, or preparing a PR to pass
  strict Wenia reviewers. Combine with elixir-review for language-general
  OTP/Ecto checks.
---

# Elixir Review — Wenia Fleet Layer

Extension skill for Wenia services. It adds the **organization layer** on top
of the language layer (`elixir-review` + global Elixir `rule.json`) and the
engine layer (`open-code-review-delegate` + OCR system rules). It never
repeats generic checks — only Wenia-specific conventions live here.

## When to use me

Activate when the review target is a Wenia service. Detect dynamically (never
assume): the repo has a `lib/<app>/{domain,adapters,entry_point}` layout, or
`mix.exs` depends on `wenia_commons`, or the user mentions Wenia, a `SRV_*` /
`LIB_*` repo, or "strict reviewers". For non-Wenia Elixir code, stay inactive
and let `elixir-review` handle it.

## Workflow

### Step 1: Load the engine + language layers

Load via the `skill` tool, in order:

1. `open-code-review-delegate` (file selection + rule resolution workflow).
2. Every `elixir-*` skill from `<available_skills>` (OTP/Ecto expertise —
   this skill's own name starts with `elixir-`, so `elixir-review` discovers
   it the same dynamic way; do not special-case it).

### Step 2: Resolve which Wenia rules apply

Prefer, in order (mirrors OCR's own priority chain):

1. `<repo>/.opencodereview/rule.json` when the service team committed one —
   OCR applies it automatically; do not re-read it, just note its presence.
2. Otherwise this skill's `references/wenia-rule.json` — pass it explicitly:
   `ocr delegate preview --rule <skill-dir>/references/wenia-rule.json`,
   same flag for `delegate rule`, `review`, and `scan`. This is also how you
   review a **foreign PR** without commit access: point `--rule` at this
   file. Resolve `<skill-dir>` from where this SKILL.md was loaded.
3. The global Elixir `rule.json` covers everything this file does not match
   (generic `lib/**/*.ex` files fall through to it — by design, no overlap).

### Step 3: Read references scoped by file path (never everything)

Load `references/wenia-checklist.md` first — it is the condensed,
path-scoped checklist and is usually sufficient. Additionally:

- File under `domain/error/` or named `error_mapper.ex` → checklist
  "Error model" + repo `AGENTS.md` error section when present.
- File under `domain/use_cases/`, `domain/ports/`, `adapters/` →
  checklist "Layers & ports" + "with/case idioms".
- File under `entry_point/` → checklist "HTTP/AMQP boundaries".
- File under `config/` or named `application.ex` / `prom_ex.ex` →
  checklist "Config & boot".
- `*_test.exs` → checklist "Tests".
- The full guides (`customersDocs/AI/reviewCode/rules/*.md`) are the
  human evidence library — open them only when a finding needs its source,
  never preemptively (the style guide alone is 1500 lines).
- When the repo has its own `AGENTS.md`, read it: service-specific
  instructions win over this skill on that repo's idiosyncrasies.

### Step 4: Review with judgment (conventions are not laws)

Every item in `references/wenia-rule.json` and the checklist carries its
tier. Enforce accordingly:

- **[C] consensus** (cross-reviewer + fleet evidence) → report as
  **medium**. Escalate to high only with a concrete bug, security hole, or
  data-loss scenario in the diff.
- **[R] recommended** → report as **low** (medium only with measured impact),
  always with context.
- **[P] individual preference** (correlation propagation, UUIDv7, infra
  alternatives, design nudges) → **suggest once as low or omit**.
- **Demoted mandates** (exact `http_options` identifiers, strict cache-key
  triples — downgraded by the fleet compliance audit itself) → enforce only
  the softened form in the checklist, never the strict form.
- **Runtime scoping**: OTP/process guidance applies to long-lived supervised
  services only. Skip it for Mix tasks, lambdas/short-lived invocations, and
  migration-only repos.
- Reviewers can be wrong, including the ones distilled here: when the diff's
  context justifies deviating, say so explicitly instead of flagging.
  Conventions are **never critical**.

### Step 5: Report and optionally fix

Follow the delegate skill's report contract (`total_files`,
`reviewed_files`, `skipped_files`, `coverage_rate`, grouped by severity,
false positives discarded silently). Mark each Wenia-convention finding with
its tier (`[C]`/`[R]`/`[P]`) so the author knows how binding it is. For your
own PRs, phrase findings as pre-merge fixes; for foreign PRs, phrase them as
review comments with file + line + suggested change. If the user asked to
"review and fix", apply critical/high directly, propose medium, skip low
unless trivial.
