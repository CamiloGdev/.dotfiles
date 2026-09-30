---
name: elixir-review
description: >
  Review Elixir/Phoenix/Ecto code changes with open-code-review delegation
  plus whatever elixir-* skills are installed. Discovers elixir skills
  dynamically by prefix, so updating, adding or removing elixir skills never
  requires editing this skill. Use when reviewing Elixir code, Phoenix apps,
  LiveView, OTP supervisors/GenServers, or Ecto schemas/migrations/queries.
---

# Elixir Review — OCR Delegation + Elixir Skills

Thin orchestration skill. It combines two official pieces without duplicating
either: the `open-code-review-delegate` skill (deterministic file selection
and rule resolution) and the installed `elixir-*` skills (Elixir/OTP/Ecto
expertise). Both are loaded live from disk, so their updates apply
automatically.

## Workflow

### Step 1: Discover skills dynamically (never hardcode the list)

From `<available_skills>`, collect **every** skill whose name starts with
`elixir-` (examples: `elixir-otp-patterns`,
`elixir-ecto-patterns`, `elixir-antipatterns`, `elixir-pro`,
`elixir-pattern-matching` — but do NOT rely on this list; whatever matches
the prefix today is the correct set, including skills added after this file
was written).

Load via the `skill` tool, in this order:

1. `open-code-review-delegate` (the review engine workflow).
2. All discovered `elixir-*` skills — this automatically includes
   `elixir-review-wenia` when present, which activates its own Wenia fleet
   layer only for Wenia services (it self-detects via
   `domain/adapters/entry_point` layout or `wenia_commons` in `mix.exs`).

If no `elixir-*` skill is installed, proceed with delegation alone and state
that in the report.

### Step 2: Follow the delegate workflow exactly

Execute the loaded `open-code-review-delegate` skill from Step 1 to Step 7
without skipping: `preview` (mode/ref metadata) → `rule` (resolved rules,
which already include the global Elixir `rule.json`) → `git diff` per file →
review each file with full coverage (`total_files`, `reviewed_files`,
`skipped_files`, `coverage_rate`) → report grouped by severity.

### Step 3: Apply Elixir skills as authoritative checklists

While reviewing each Elixir file (`.ex`, `.exs`, `.heex`), enforce the loaded
`elixir-*` skills alongside the OCR-resolved rules. On conflict between a
generic OCR observation and an `elixir-*` skill, the `elixir-*` skill wins
for Elixir-specific concerns (OTP semantics, supervision, Ecto, BEAM
concurrency); OCR wins for positioning and coverage discipline.

### Step 4: Report and optionally fix

Same severity policy as the delegate skill: always report critical/high,
report medium with context, report low only if clearly valuable, silently
discard likely false positives. If the user asked to “review and fix”, apply
critical/high fixes directly after reporting.
