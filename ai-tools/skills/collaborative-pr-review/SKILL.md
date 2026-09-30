---
name: collaborative-pr-review
description: >
  Conduct a collaborative, human-in-the-loop pull/merge request review where the
  reviewer stays an active participant and decision-maker instead of receiving a
  finished verdict. The agent does the recon, architecture mapping, layered
  file-by-file analysis, verification and comment drafting; the human supplies
  business context and approves every published comment. Use this skill whenever
  the user asks to review a PR, MR, or diff, to "go through this PR file by
  file", to "review PR #123", to analyze a change step by step, to prepare or
  publish review comments, or wants to validate findings before posting.
  Also trigger on phrasing like "vamos a revisar este PR", "repasemos este PR
  juntos", "guíame por los archivos del PR", "revísame este cambio", "ayúdame a
  revisar este código", "qué le comentamos a este PR", or any request to review
  code where the user expects to give feedback and decide what gets published.
  Language- and platform-agnostic; composes with language/domain skills and
  automated review engines.
---

# Collaborative PR Review

A method for reviewing a pull/merge request **with** the human reviewer, not just
**for** them. The agent does the heavy lifting (recon, architecture mapping,
file-by-file analysis, verification, comment drafting); the human supplies
business context and makes every publish decision. The outcome is a set of
review comments the reviewer fully understands and owns — because they helped
build them.

This skill is deliberately language- and platform-agnostic. It composes with:

- **Language / domain skills** (e.g. `elixir-review`, `elixir-review-wenia`,
  `elixir-antipatterns`, or their equivalents in other stacks) as authoritative
  checklists for the specific technology.
- **Automated review engines** (e.g. `open-code-review`) as an optional first
  pass. Those engines produce candidate findings; this skill turns candidates
  into validated, reviewer-approved comments.

Read the relevant language/domain skills before you start analyzing, and let
their rules override generic advice when they conflict.

## Principles

- **Understand before judging.** Never comment on a diff before you can explain,
  in plain terms, what the change does, why it exists, and where it sits in the
  architecture.
- **The reviewer is a variable in the equation.** Business context they provide
  can invalidate a finding or change its severity. Treat every finding as
  provisional until the relevant context lands, and re-derive when it does.
- **Verify, don't offload.** If a finding can be checked in code, dependencies,
  docs, or by running something, check it yourself and drop it if it does not
  hold. Ask the reviewer only what only they can answer — business intent,
  contracts, priorities, deployment constraints.
- **Layered order beats file order.** Review along the data/control flow, not
  the alphabetical list the PR page shows.
- **Severity is a contract.** Reserve critical/high for real bugs, security and
  data-loss risks. Conventions and style are medium/low and must carry context.
- **Never publish without explicit approval.** Draft in the reviewer's working
  language, get sign-off, then publish in the target language.

## Phase 0 — Recon and isolate

Goal: see the whole change without disturbing the reviewer's working tree.

- Pull the PR metadata: title, body, base/head refs, file list with
  additions/deletions, and commits. On GitHub:
  `gh pr view <n> --json title,body,files,additions,deletions,commits,baseRefName,headRefName`
  and `gh pr diff <n>`.
- Fetch the head into an **isolated worktree** so you can read full files with
  context and never touch the user's checkout:
  `git fetch origin pull/<n>/head:pr-<n>` then
  `git worktree add <tmp-dir> pr-<n>`. Clean up when the review is done.
- Read the repository's architecture: README, top-level layout, layer
  directories, `AGENTS.md`/`CLAUDE.md`, existing tests and conventions.
- Load the relevant language/domain skills (see Composition above).

## Phase 1 — Reconstruct intent

Goal: a one-paragraph statement of what the change wants to achieve and the
rules it encodes.

- Extract intent from the PR description, the linked ticket/issue, and the
  changelog.
- Enumerate the explicit business rules and invariants the code implements
  (for example: "while flag X is active, fields Y stay frozen unless Z").
- Note discrepancies between the description and the code — those are often
  findings themselves (misleading docs, dead branches, claimed behavior not
  present).
- Present this back to the reviewer and ask them to confirm or correct it. This
  is the first point where business context enters and can reshape the review.

## Phase 2 — Architecture map and layered review plan

Goal: a review order the reviewer agrees with before you dive in.

- Sketch how the change flows through the system (data in, data out, side
  effects, boundaries crossed).
- Propose an order from the foundational layer to the boundary. A common shape
  for layered/hexagonal services:

  1. Domain model + ports/interfaces (the new field, type, or contract)
  2. Persistence / serialization adapters
  3. Configuration
  4. Core use-cases / business logic
  5. Orchestration / coordination
  6. Entry points (HTTP handlers, CLI, consumers)
  7. Scripts, jobs, migrations
  8. Tests and cross-cutting concerns

  Adapt to the project's real architecture and group tightly-coupled files into
  one block. The point is comprehension, not tidiness.
- Present the plan as a short table and wait for the go-ahead. The reviewer may
  reorder blocks or pre-load business context that changes the emphasis.

## Phase 3 — Block-by-block review loop

For each block (one file, or a few tightly coupled files):

1. **State what it does** in one to three sentences, in the reader's terms.
2. **List findings** as severity-tagged bullets, each with a `file:line`
   reference, what is wrong, why it matters, and a concrete suggestion.
3. **Ask targeted questions** where business context is required, and wait.
4. Resolve the block, then move on. Keep a running todo list so the reviewer
   always sees progress and what remains.

Interaction rules that make this work:

- When the reviewer supplies context that changes a finding, **explicitly
  restate the finding in light of it** and update or withdraw it. Never leave
  stale findings silently in place.
- Separate **verified fact** from **open question** in your wording. The
  reviewer needs to know which is which.
- If you cannot reproduce a finding, say so and drop it. Reporting fewer,
  solid findings beats a long list of maybes.

## Phase 4 — Verify each finding before it becomes a comment

For every finding you intend to publish:

- Re-read the actual code at the head ref, not just the diff hunk.
- If it depends on library/framework behavior, read that source or its docs and
  confirm. Recurring examples that need verification: serializer behavior for
  nested keys, ORM/struct merge semantics, default upsert behavior, macro
  expansion, type coercion.
- If it is a contract question, confirm with the reviewer rather than asserting
  it as fact.
- Drop anything that does not survive verification, and tell the reviewer which
  candidates were dropped so they know the item was considered.

## Phase 5 — Draft, approve, publish

1. **Draft** each comment in the reviewer's working language so they fully
   understand it.
2. **Present** the full set for validation; the reviewer decides which go.
3. **Publish only after explicit approval**, in the target language (usually
   English). See `references/comment-templates.md` for the comment anatomy and
   a GitHub publishing recipe.
4. **Verify** publication (list the created comments) and report the result.

## Severity taxonomy

- **Critical / High** — bugs, security vulnerabilities, data loss/corruption,
  broken invariants with real impact. Always report.
- **Medium** — correctness or maintainability risks that need context,
  contract/consistency issues, missing guards. Report with context.
- **Low** — style, naming, docs, optional refactors. Report only when clearly
  valuable; it is fine to omit.

## Failure modes to avoid

- Dumping every finding at once instead of pacing block by block.
- Asserting a finding you did not verify, or asking the reviewer to verify what
  you could have checked yourself.
- Publishing before approval, or in a language the reviewer cannot check.
- Letting new business context arrive but leaving earlier findings unchanged.
- Treating conventions as critical.
- Reviewing only the diff and missing the surrounding context — read the full
  files in the isolated worktree.

## References

- `references/comment-templates.md` — comment anatomy, severity wording,
  worked examples, and a GitHub multi-comment publishing recipe.
