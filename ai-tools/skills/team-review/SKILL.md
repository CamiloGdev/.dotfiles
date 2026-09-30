---
name: team-review
description: >
  Review code TOGETHER with the human as a team: the agent drives the
  open-code-review engine while the human participates step by step
  (architecture overview first, then layered blocks, findings validated one by
  one with business context, comments approved before publishing). On
  activation it runs an intake that asks what it needs — scope, whether the PR
  is the reviewer's own (fix path) or a teammate's (comment path), what the
  review wraps (ocr alone, plus a language skill, or plus a domain skill such
  as elixir-review-wenia), and how guided to be — no language skill is ever
  loaded without confirmation. Activate ONLY on explicit request: $team-review,
  or phrasing like "revisemos este PR juntos", "revísame paso a paso", "quiero
  participar en la review", "let's review this together", "walk me through
  this PR". Do NOT activate for plain review requests ("review this",
  "revísame esto") — those stay on the fast automatic path.
---

# Team Review — Participatory Reviews on the OCR Engine

Stack-agnostic wrapper. OCR has no native team/participatory mode (its CLI
offers `--effort`, `--rule`, `--background`, `--tools`, `--resume`, but no
human gates), so this skill implements the gates host-side while OCR provides
the deterministic engine: file selection, rule resolution, bundling, and
positioning.

## Step 0 — Intake: establish the contract (ask once, don't make the user write it)

Never assume the answers, but also never make the user type them blind. On
activation, detect context (repo, dominant extensions, Wenia signals,
`.opencodereview/rule.json`, `AGENTS.md`) and ask a single compact intake,
pre-filled with what you detected so the user only confirms or corrects. State
your detection and ask the 4 items in one message:

1. **Scope** — which PR / commit / branch / workspace (number + repo, or refs).
   If you can infer it from the conversation, propose it.
2. **Ownership — whose PR is it?** This decides the deliverable:
   - **Yours → fix path:** the review can end by applying approved fixes to
     your working branch (still one approval per finding; commit only when you
     say so).
   - **Someone else's → comment path:** read-only. The deliverable is a review:
     approved inline comments published in one review via `gh`; never commit or
     push to their branch.
   Default the suggestion from context; ask explicitly if unclear.
3. **What to wrap** — propose 2–3 options from detection and let the user pick:
   - **(a) ocr alone** — any stack, no language skill.
   - **(b) ocr + a language skill** — e.g. `elixir-review` when `.ex/.exs`
     dominate.
   - **(c) ocr + a domain skill** — e.g. `elixir-review-wenia` only when
     Wenia signals are present.
   Load `open-code-review-delegate` first, then ONLY the chosen skills. A Node
   project must never end up with `elixir-review`: ask rather than assume.
4. **Mode** — default is guided (gates at each phase). Offer *"hazlo rápido"*
   to skip gates and run the chosen target's automatic flow.

Present it so the user can answer in one line, e.g.:
> Detecté: repo SRV_0007 (Elixir + Wenia), target sugerido **con wenia**.
> ¿Confirmas? Dime también: **¿es tu PR o de un compañero?** y el número/ref.
> Respuesta esperada: "de un compañero, PR #592, con wenia, guiado".

Record the agreed contract for the session and reuse it on follow-up requests
without re-asking. If the user opens with a full instruction already (scope +
ownership + target), skip the parts they answered.

Fast path, same session: if the user says "hazlo rápido / just do it
automatically", skip every gate below and run the chosen target's automatic
flow (equivalent to invoking that skill directly).

## Step 1 — Adopt the collaborative protocol (reference, don't duplicate)

Load `collaborative-pr-review` and follow its Phases 0–5 as the interaction
contract: recon in an isolated worktree, intent reconstruction with reviewer
confirmation, architecture map with an agreed layered plan, block-by-block
loop with targeted questions, verification of every finding, draft → approve
→ publish via its `references/comment-templates.md` (GitHub recipe included).
That skill owns the protocol; this skill owns target selection and OCR
wiring. On any conflict about process, `collaborative-pr-review` wins; on
coverage and positioning, OCR wins.

## Step 2 — Wire OCR into each phase (concrete commands)

- **Recon (Phase 0):** `ocr delegate preview --format json` for the
  authoritative file list (mode/ref metadata) instead of hand-rolled `git`
  archaeology; `ocr delegate rule --format json <paths>` per block for the
  resolved checklists. When the repo has no `.opencodereview/rule.json` and
  the target brings a canonical one (e.g. the Wenia skill's
  `references/wenia-rule.json`), pass `--rule <path>` to every delegate and
  review command — including foreign PRs with no commit access.
- **Business context (Phases 1–3):** everything the reviewer confirms
  (intent, invariants, domain variables) flows into `--background "..."` (or
  `--background-file` past ~8k chars) on subsequent OCR calls, so the engine
  re-derives with the new context instead of defending stale findings.
- **Block order (Phase 2–3):** comprehension order (foundational → boundary)
  takes precedence over OCR's concurrent bundles; coverage order still comes
  from the delegate checklist (`total_files` / `reviewed_files` /
  `coverage_rate` must close at 100% or explicitly skipped).
- **Scale:** PR too large for one pass → group blocks into atomic
  feature-sized units and review unit by unit; resume interrupted runs with
  `ocr review --resume <session-id>` (`ocr session list` to find it), and use
  `--output <file>` for large runs instead of piping stdout.
- **Verification (Phase 4):** collab skill's own rules (re-read head-ref
  code, confirm framework behavior in source, drop what doesn't hold and say
  what was dropped).

## Step 3 — Severity and publishing discipline

Shared contract across all three layers (delegate skill, domain skills,
collaborative protocol): critical/high reserved for bugs, security, or
data-loss with a concrete scenario; conventions at medium/low with context;
individual preferences suggested once as low or omitted. Conventions are
never critical. Publish only approved comments, drafted first in the
reviewer's working language.

Deliverable follows the ownership decided in Step 0:

- **Own PR (fix path):** after approval, apply the fixes on your working
  branch; commit/push only on explicit request.
- **Teammate's PR (comment path):** read-only. Publish the approved findings
  as one review with inline comments (`gh api .../pulls/<n>/reviews`, `line`
  in the new file, `side: RIGHT`; recipe in
  `references/comment-templates.md`). Never commit or push to their branch.

## Step 4 — Close with the knowledge record

End every review with a short ledger the reviewer keeps: what the change
did (one paragraph), blocks reviewed in which order, findings accepted /
edited / dropped (and why, including business context that reshaped them),
comments published (with links), and open questions. The reviewer should
walk away understanding the code, not just the verdict.
