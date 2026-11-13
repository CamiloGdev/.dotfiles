---
name: elixir-review-wenia
description: >
  Review Wenia Elixir microservices against the official Wenia Elixir style
  guide (skill `wenia-elixir-style-guide`, rule IDs CF, ERR, DATA, ARCH, PB,
  OBS, TEST, QT, SQL, HTTP, SQS, MODEL, NAME, AGENT) using open-code-review
  delegation. The style guide owns every rule; this skill adds the review
  workflow, the repo AGENTS.md override handling and severity calibration.
  Use when reviewing a Wenia Elixir PR, writing review comments on someone
  else's PR, or preparing a PR to pass Wenia reviewers. Combine with
  elixir-review for language-general OTP/Ecto checks.
---

# Elixir Review — Wenia Fleet Layer

Review layer for Wenia services. The rules live in the official style guide
(`wenia-elixir-style-guide`, vendored from
`wenia-ltd/AI_0006_wenia_ai_resources_catalog`; see its `SOURCE.md`). This
skill never restates or contradicts a rule: it says how to apply the guide in
a review, how to rank findings and how to handle repo overrides.

If this skill and the style guide disagree, the style guide wins. Fix this
skill instead of following it.

## When to use me

Activate when the review target is a Wenia service. Detect dynamically (never
assume): the repo has a `lib/<app>/{domain,adapters,entry_point}` layout, or
`mix.exs` depends on `wenia_commons`, or the user mentions Wenia, a `SRV_*` /
`LIB_*` repo, or "strict reviewers". For non-Wenia Elixir code, stay inactive
and let `elixir-review` handle it.

## Workflow

### Step 1: Load the rules and the engine

Load via the `skill` tool, in order:

1. `wenia-elixir-style-guide`: read its `SKILL.md` and `references/README.md`.
   Load only the reference files for the code under review, as its
   Progressive Disclosure table says.
2. `open-code-review-delegate` (file selection + rule resolution workflow).
3. Every other `elixir-*` skill from `<available_skills>` (OTP/Ecto
   expertise). They are language-general; the style guide wins on conflict.

### Step 2: Read the repo's AGENTS.md (AGENT-1)

- The repo's `AGENTS.md` decides which rule files apply and declares local
  overrides. An override names the rule ID, its evidence and its reason.
- New code follows every applicable rule unless `AGENTS.md` names an override
  for that rule ID. A general statement that contradicts a rule without
  naming it is a conflict to flag, not an override.
- No `AGENTS.md`: say so (style guide "No AGENTS.md" message) and apply the
  rules whose "Applies when" condition holds.
- Legacy code that follows an older convention (AppConfig facade, `Mock`
  tests, RabbitMQ) is not rewritten by a PR that doesn't touch it (CF-1). New
  code in that repo still follows the rule unless `AGENTS.md` overrides it;
  when the author keeps the legacy pattern for consistency, the finding is
  "declare the override in AGENTS.md", not "rewrite the repo".

### Step 3: Resolve OCR rules

Prefer, in order:

1. `<repo>/.opencodereview/rule.json` when the team committed one. OCR
   applies it automatically.
2. Otherwise this skill's `references/wenia-rule.json`. Pass it explicitly:
   `ocr delegate preview --rule <skill-dir>/references/wenia-rule.json`, same
   flag for `delegate rule`, `review` and `scan`. It is a path-scoped pointer
   to the style guide rule IDs, so OCR cites them.
3. The global Elixir `rule.json` covers what this file doesn't match.

### Step 4: Review with the checklist

Load `references/wenia-checklist.md`. It maps each path to the rule IDs to
check and lists the findings Wenia reviewers raise most often. Open the
style guide reference file when a finding needs the exact rule text.

- Cite the rule ID and its level in every finding (`DATA-10 (Must)`).
- Don't hand-review what the repo's tools enforce: formatter, compiler,
  Credo, ExSlop, Reach (QT-2). Repeated mechanical comments become a check
  proposal (AGENT-2).
- Money, compliance and security findings outrank style findings.

### Step 5: Calibrate severity

- **Bug, security hole, data loss, money or compliance risk** in the diff →
  critical/high, whatever rule it maps to.
- **Must** rule broken by new code with no `AGENTS.md` override → blocking
  (`issue (blocking)`), reported as medium unless it also matches the line
  above.
- **Should** rule → non-blocking suggestion (low), with the context that
  justifies an exception when there is one.
- **May** rule → mention only if it clearly helps.
- Runtime scoping: OTP/process rules apply to long-lived supervised services
  only. Skip them for Mix tasks, short-lived invocations and migration-only
  repos.
- When the diff's context justifies a deviation, say so explicitly and point
  to the override the repo should declare.

### Step 6: Report and optionally fix

Follow the delegate skill's report contract (`total_files`,
`reviewed_files`, `skipped_files`, `coverage_rate`, grouped by severity,
false positives discarded silently). For your own PRs, phrase findings as
pre-merge fixes; for foreign PRs, as review comments with file, line, rule
ID and suggested change. If the user asked to "review and fix", apply
critical/high and blocking Must findings, propose Should findings, and skip
May findings unless trivial. Close with AGENT-4: behaviour changed, files
changed, checks run and their limits.
