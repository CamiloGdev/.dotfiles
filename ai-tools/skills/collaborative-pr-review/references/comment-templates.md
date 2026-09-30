# Comment Templates & Publishing Recipe

Reference for Phase 4 and Phase 5 of `collaborative-pr-review`.

## Comment anatomy

Every published comment should let the author act without asking questions.
Use this shape:

1. **Headline** — a short bold phrase naming the issue.
2. **Why it matters** — the impact, grounded in the actual code (a bug, a data
   risk, a contract break, a maintenance trap). Not "this is bad practice".
3. **Suggestion** — a concrete, minimal change. Prefer showing the shape of the
   fix over prescribing an exact implementation.
4. **Severity** — critical/high/medium/low, implied by the tone or stated.
5. **Related references** — `file:line` of the code the comment depends on.
6. **Already tracked** — if the issue is filed elsewhere (e.g. a ticket), say so
   in one line and link it; do not re-explain the whole issue.

Keep the reviewer's *why*. A comment that only says "don't do X" teaches
nothing; a comment that says "X breaks Y under condition Z, so do W instead"
does.

## Worked examples

**Bug / missing idempotency (high)**
> **Re-publishing a SUCCESSFUL event on every attempt.** The freeze keeps
> `status` at `SUCCESSFUL`, and publishing is decided by that status, so every
> retry re-emits a success event and re-notifies downstream, even when nothing
> changed. This is the same idempotency gap tracked in `<TICKET>`. Suggest
> suppressing the publish while the status is "frozen", or keying it on the
> computed status instead of the stored one.

**Contract / consistency (medium)**
> **`"COMBINED"` is not a valid provider.** It is not in `Providers.list()`
> while the field validates `in: Providers.list()`, so the code works around it
> by storing another value. Document it as a flow phase (never a persisted
> provider) and centralize the constant, currently duplicated in three modules.

**Persistence / representation (high)**
> **Inconsistent key representation.** This writer persists string keys while
> the use case persists atom keys, so reads tolerate both and the defensive
> normalization is duplicated in three modules. Pick one representation at the
> persistence boundary and convert once.

**Doc vs code (medium)**
> **Doc disagrees with the code.** The example says `"provider_name" => ""` but
> the builder writes `"provider_name" => "COMBINED"`. Fix the doc (or the
> value).

**Dead code (medium/low)**
> `freeze_reinitialization_fields?/2` is not used anywhere (verified with
> grep). It was added in this PR; remove it.

**Missing test (low, only if valuable)**
> The event-publishing path this PR relies on has no test. A small test that a
> retry does not re-emit a success event would lock in the intended behavior.

## Draft-in-reviewer-language workflow

Many reviewers read the code fluently but want to *approve* comments in their
own language first. Default to:

1. Draft all comments in the reviewer's working language.
2. Present the full set as a table or list for validation; let them accept,
   edit, or drop each.
3. Publish only the approved ones, translated to the target language
   (usually English), preserving the reviewer's intent — not a literal
   translation of your draft.

Never publish before the approval step. If the user says "publish", that is the
approval; if they are still discussing, it is not.

## GitHub multi-comment publishing recipe

Create **one review** containing all inline comments rather than N separate
comments — it reads as a coherent review and is a single API call.

1. Get the PR head commit SHA:
   ```bash
   gh pr view <n> --json headRefOid -q .headRefOid
   ```
2. Build a JSON payload:
   ```json
   {
     "commit_id": "<head-sha>",
     "event": "COMMENT",
     "body": "Short summary of the review.",
     "comments": [
       {
         "path": "lib/path/to/file.ex",
         "line": 123,
         "side": "RIGHT",
         "body": "**Headline.** Why it matters... Suggestion..."
       }
     ]
   }
   ```
   - `line` is the line number **in the new file**.
   - `side: "RIGHT"` for added/current lines; `"LEFT"` for removed lines.
   - The line must exist **within the diff** (an added line, or a context line
     inside a hunk). Lines outside every hunk are rejected.
3. Post it:
   ```bash
   gh api repos/<owner>/<repo>/pulls/<n>/reviews --input payload.json
   ```
4. Verify:
   ```bash
   gh api repos/<owner>/<repo>/pulls/<n>/comments \
     --jq '.[] | "\(.path):\(.line)"'
   ```

### Gotchas

- **"Line could not be resolved" (HTTP 422)** means at least one `line` is not
  in the diff. Move that comment to a nearby changed line (e.g. the function
  definition if it is a context line inside a hunk, or an added line in the same
  block). Fix and repost the whole review.
- **Anchoring choices:** prefer the most specific changed line that supports the
  finding. If two findings would land on the same line, move one to an adjacent
  relevant line so the review reads cleanly.
- **Escaping:** when building the payload by hand, escape newlines as `\n` and
  quotes as `\"` inside `body`.
- **Other platforms:** the same model applies — one review object with an array
  of `{file, line, side, body}` comments. Adapt the endpoint; keep the
  line-anchor rule.

## Severity wording guide

| Severity | Use for | Tone |
|----------|---------|------|
| Critical / High | Bugs, security, data loss/corruption, broken invariants with real impact | Direct: state the failure scenario |
| Medium | Contract/consistency, missing guards, maintainability risks needing context | "Suggestion:" with the trade-off |
| Low | Style, naming, docs, optional refactors | "Nit:" or omit entirely |

When in doubt, downgrade. A convention is never critical unless you can point
to a concrete bug, security hole, or data-loss path in the diff.
