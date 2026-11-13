---
name: wenia-elixir-style-guide
description: |
  Wenia's unified Elixir rules with stable rule IDs (CF, ERR, DATA, ARCH, PB, OBS, TEST, QT,
  SQL, HTTP, SQS, MODEL, NAME, AGENT). Activate when the user writes, refactors or reviews
  Elixir code (`*.ex`, `*.exs`, `mix.exs`, `.credo.exs`, `config/*.exs`) in a Wenia repository,
  asks about Wenia Elixir conventions, or wants review findings that cite rule IDs.
  Do NOT activate for non-Elixir code (Python, Terraform, JavaScript/TypeScript),
  infrastructure-only changes or general documentation edits.
---

# Wenia Elixir Style Guide

> **MCP Tools required:** None.

## Table of Contents

0. [Scope](#scope): what the skill covers
1. [Three-Layer Model](#three-layer-model): where each kind of rule lives
2. [Workflow](#workflow): writing, reviewing and verifying Elixir
3. [Rules and Constraints](#rules-and-constraints): non-negotiables
4. [Best Practices](#best-practices): quick checklist
5. [Error Handling](#error-handling): when context is missing or rules conflict
6. [Progressive Disclosure](#progressive-disclosure): rule files in `references/`

## Scope

- **In scope:** Elixir source, tests and tooling config (`*.ex`, `*.exs`, `mix.exs`, `.credo.exs`, `.formatter.exs`, `config/*.exs`) and the repo's `AGENTS.md` in Wenia repositories.
- **Out of scope:** other languages, Terraform/infrastructure, CI pipeline design and product decisions.
- **Stop:** before a destructive change the task didn't ask for, or when a fix would change a public contract (ERR-11, ERR-12) without the task asking for it.

## Three-Layer Model

The rules come in three layers (see `references/README.md`):

1. **Generic Elixir rules:** control flow, naming, observability, testing and quality tooling. They apply to any Elixir repo.
2. **Wenia stack rules:** architecture, errors, data and config, provider boundary, SQL, HTTP, SQS and models. They assume `Wenia.Commons` and CoreLib (`ModuleInyector`, `MapValidator`, `JsonMapper`, `DomainErrors`, `ErrorMapper`).
3. **Per-repo facts:** the OTP app, namespaces, providers, which rule files apply and any local overrides. These live only in the repo's own `AGENTS.md`, never in the rule files or in this skill.

Rule text uses placeholders: `<App>` for the root namespace, `:<otp_app>` for the OTP app and `lib/<app>/` for its source path. Each rule has a level (**Must**, **Should**, **May**) and an `enforced_by` column naming the tool that checks it, or `review`.

### The repo's AGENTS.md decides

- The repo's `AGENTS.md` is the single entry point (AGENT-1). It decides which rule files apply to that repo and declares any local overrides.
- A local override names the rule ID it overrides, with its evidence and reason.
- **New code follows the rules unless `AGENTS.md` declares an explicit override for that rule.** A general statement in `AGENTS.md` that contradicts a rule, without naming it as an override, is a conflict to flag, not an override.
- When `AGENTS.md` doesn't say which rule files apply, use the "Applies when" column below.

## Workflow

### Step 1: Detect Context

1. Activate for Elixir work in a Wenia repo.
2. Read the repo's `AGENTS.md`: the rule files that apply, the repo facts and the local overrides.
3. Pick the reference files for the code you touch (see [Progressive Disclosure](#progressive-disclosure)). Load only those.

### Step 2: Write

- Deliver the smallest patch that matches existing patterns. No extra features, abstractions or adjacent cleanup.
- Reuse `Wenia.Commons` before writing helpers: `Clients.Http.HttpClient` (PB-1), `Validators.MapValidator` (DATA-1), `Macros.JsonMapper` (DATA-5), `Macros.ModuleInyector` (ARCH-4), `Macros.Context` (OBS-5), `Macros.Retry` where a retry is allowed (ERR-10).
- Amounts are `Decimal` (DATA-6), never floats.

### Step 3: Review

- Cite rule IDs in findings (`CF-9`, `ERR-4`, `ARCH-14`).
- Don't hand-review what the repo's tools already enforce (formatter, compiler, Credo, ExSlop, and Reach where adopted). If a mechanical comment repeats, propose a check instead (QT-2, AGENT-2).
- Money, compliance and security findings outrank style findings.
- Flag a conflict between `AGENTS.md` and a rule unless `AGENTS.md` declares an explicit override for it.

### Step 4: Verify

Run each verification tool the repo uses with its own command (QT-1). Use the commands listed in the repo's `AGENTS.md`; typical ones are:

| Tool | Command |
|------|---------|
| Formatter | `mix format --check-formatted` |
| Compiler, warnings as errors | `mix compile --warnings-as-errors` |
| Compile-time dependencies | `mix xref graph --label compile-connected --fail-above 0` |
| Credo 1.7.17 or later (QT-17), with every ExSlop check except ListLast (QT-3, QT-6) | `mix credo` |
| Tests | `mix test --no-start` |
| Dialyzer, Reach, ExDNA (where adopted) | `mix dialyzer`, `mix reach.check`, `mix ex_dna` |

Then report the behaviour changed, the files changed, the checks actually run and their limits (AGENT-4).

## Rules and Constraints

**Principle:** tools own mechanical style; prose rules own semantics only (QT-2).

### MUST

- Follow every rule that applies to the code you touch, unless `AGENTS.md` declares an explicit override for that rule.
- Apply rules to the code a change touches. Don't rewrite untouched code to follow them (CF-1).
- Never weaken a test to get a pass (TEST-2).

### MUST NOT

- Pipe `{:ok, _}`/`{:error, _}`, or pipe into `case`, `if`, `cond` or `with`; nest `case`/`with` (CF-9).
- Use floats or plain interpolation for amounts (DATA-6).
- Log provider bodies, headers, signatures, credentials, keys, tokens, wallet addresses or end-user identifiers (PB-7, OBS-8).
- Configure Logger through `config :logger, :console` on Elixir 1.15 and later (OBS-15).
- Write hand-written retry loops (ERR-10), or use `try`/`rescue` for expected outcomes (ERR-9).
- Call a concrete adapter from the domain (ARCH-4), or call `Application` from the domain (DATA-9).
- Renumber or reuse rule IDs (QT-14, AGENT-3).

## Best Practices

- Heads match shapes; guards only for type, size, range or membership (CF-2, CF-3).
- `case` for distinct outcomes, `with` for a linear chain with at most one `else` (CF-5, CF-6); `if`/`else` for one boolean choice (CF-7).
- Constants are zero-arity functions; no macros without a DSL need (CF-11, CF-13).
- Failures as `{:error, DomainErrors.name()}`, the `MapValidator` field-error map, or the repository 3-tuple (ERR-4, SQL-3). HTTP mapping only in `ErrorMapper` (ERR-6).
- Validate once in `new/1` with `MapValidator`; `@type t` and `@enforce_keys` (DATA-1, DATA-3).
- Each module reads its own config in a private `config/1`; no `AppConfig` facade (DATA-10).
- Ports through `ModuleInyector`; idempotent message paths; supervised processes (ARCH-4, ARCH-11, ARCH-14).
- Logs: level by outcome, `operation:`, `correlation_id`, no sensitive data, log a failure once, Wenia structured logs standard (OBS-1..OBS-14).
- Tests: Mox only on ports, no sleeps, `describe` per function, router tests per verb and path (TEST-9, TEST-11, TEST-5, TEST-23).

## Error Handling

### No AGENTS.md

```
⚠️ This repo has no AGENTS.md.

Applying the Wenia Elixir rules whose "Applies when" condition holds (rule IDs cited inline).
If the repo declares local overrides elsewhere, point me to them.
```

### Rule conflict without an explicit override

```
❌ AGENTS.md [file:line] conflicts with [RULE-ID], but declares no override for it.

New code follows [RULE-ID]. Flagging the conflict for the repo owners; they can declare an override in AGENTS.md.
```

### Explicit override

```
ℹ️ AGENTS.md declares an override for [RULE-ID] ([reason]).

Following the override for this rule only.
```

## Progressive Disclosure

Read `references/README.md` first for the index. Then load only the files for the code you touch, and only if their "Applies when" condition holds (or the repo's `AGENTS.md` lists them).

| File | Family | Read when you touch | Applies when |
|------|--------|---------------------|--------------|
| `references/control-flow.md` | CF-1..23 | any `lib/**/*.ex`: clauses, `case`/`with`, pipes, constants, macros | always |
| `references/errors.md` | ERR-1..15 | result shapes, `DomainErrors`, `ErrorMapper`, rescue, retries | always |
| `references/data-and-config.md` | DATA-1..20 | structs, validation, amounts, `config/*.exs`, any config read | always |
| `references/architecture.md` | ARCH-1..17 | ports, adapters, use cases, processes, messaging | always |
| `references/provider-boundary.md` | PB-1..13 | HTTP, DynamoDB and Redis adapters, provider responses | the repo has HTTP, DynamoDB or Redis adapters |
| `references/observability.md` | OBS-1..15 | logging, metadata, metrics | always |
| `references/testing.md` | TEST-1..25 | any `test/**` | always |
| `references/quality-tooling.md` | QT-1..17 | the repo's `mix.exs`, `.credo.exs`, `.formatter.exs`, `coveralls.json`, CI workflows | always |
| `references/sql.md` | SQL-1..11 | SQL repository adapters and their tests | the repo has Ecto repositories |
| `references/http.md` | HTTP-1..10 | HTTP routers and router tests | the repo has a Plug router |
| `references/sqs.md` | SQS-1..10 | Broadway SQS consumers | the repo has a Broadway SQS consumer |
| `references/model.md` | MODEL-1..10 | domain models | the repo has domain models |
| `references/naming.md` | NAME-1..12 | naming, alias/defdelegate layout, docs | always |
| `references/agent-instructions.md` | AGENT-1..4 | the repo's `AGENTS.md`, tool-specific instruction files, rule files, the final report of a change | always |

## Evals

Evaluation scenarios live in `evals/` as individual `eval-*.md` files. See `evals/README.md` for execution instructions.
