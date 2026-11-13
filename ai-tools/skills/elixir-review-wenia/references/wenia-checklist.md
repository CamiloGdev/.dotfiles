# Wenia Elixir Review Checklist (by path, rule IDs)

Source of every rule: `wenia-elixir-style-guide` (rules version 0.1.0,
2026-10-21). This file only maps paths to rule IDs and lists the findings
Wenia reviewers raise most often. Check the exact text in the style guide
`references/` file before citing a rule. Levels: Must / Should / May.

Before anything: read the repo's `AGENTS.md` (AGENT-1). A rule with a named
override there is skipped for that repo; without it, new code follows the
rule (legacy code is not rewritten, CF-1).

## Any `lib/**/*.ex` (control-flow.md, naming.md)

- `case` for distinct outcomes; `with` only for a linear chain, at most one
  `else`, no single-clause `with` (CF-5, CF-6). No nested `case`/`with`,
  never `with` inside `else`: extract a private function (CF-9).
- Never pipe `{:ok, _}`/`{:error, _}` or into `case`/`if`/`cond`/`with` (CF-9).
- Constants are zero-arity functions; no runtime config or env reads in
  module attributes (CF-11, CF-12). No macro without a DSL need (CF-13).
- No dynamic module names or atoms from input (CF-20, DATA-18).
- Function names state the operation, not the mechanics (CF-14, NAME-7).
- Comments explain why (NAME-11); `@moduledoc`/`@doc` on public API (NAME-9).

## Errors (errors.md): `domain/error/`, `error_mapper.ex`, any result shape

- Failures are `{:error, DomainErrors.name()}` (ERR-4); new errors are
  functions in `DomainErrors`/`HttpErrors` (ERR-5); HTTP mapping only in
  `ErrorMapper`, one `error_info/1` clause per error with a unique code
  (ERR-6). Catch-all clauses only where external data enters (ERR-7).
- No `try`/`rescue` for expected outcomes (ERR-9).
- **No hand-written retry loops**; use `Wenia.Commons.Macros.Retry`
  `autoretry/2` where a retry is allowed (ERR-10).
- Refactors keep error atoms, statuses, codes and fields (ERR-11, ERR-12).

## Config and boot (data-and-config.md): `config/*.exs`, `application.ex`, any config read

- **No `AppConfig` facade**: each module reads its own config in a private
  `config/1` or at its `init` (DATA-10). Legacy repos with a facade declare
  an override in `AGENTS.md`; new modules still read their own config.
- Settings under the port key (DATA-7); required settings with
  `fetch_env!`/`Keyword.fetch!` (DATA-8); the domain never calls
  `Application` (DATA-9).
- **Required or structured settings fail at boot** with a clear error in
  the module that owns them (DATA-11).
- Per-deployment values as `{:system, "VAR"}` tuples (DATA-12); config keys
  carry units (`_ms`, `_seconds`) (DATA-16).

## Layers (architecture.md): `domain/use_cases/`, `domain/ports/`, `adapters/`, processes

- Business decisions in use cases or models; adapters only translate IO
  (ARCH-1). External systems behind `Domain.Ports.*` behaviours with domain
  types (ARCH-2); `@behaviour` + `@impl Port` (ARCH-3).
- Domain reaches adapters only through `ModuleInyector.adapter_for`, with
  explicit `mode:`/`ports:` from the shared macro (ARCH-4).
- Every process is supervised (ARCH-11); GenServer only for owned state,
  serialized access or scheduled work (ARCH-12); no stateless GenServer
  (ARCH-10).
- Message and webhook paths are idempotent (ARCH-14). New services use
  SNS/SQS/EventBridge (ARCH-5, scoped).

## Provider adapters (provider-boundary.md): HTTP, DynamoDB, Redis adapters

- Only `Wenia.Commons.Clients.Http.HttpClient` with the port's breaker
  options (PB-1). Classify status, decode body, project result as separate
  steps (PB-2, PB-3); validate provider fields (PB-4); fallback clause to a
  domain error, never return `%Finch.Response{}` (PB-6).
- Never put a provider body or secret in an error, log or metadata; log the
  HTTP status (PB-7). Retries and timeouts stay in the adapter (PB-12).

## Observability (observability.md): any `Logger` call or metric

- Level by outcome (OBS-1); stable `operation:` (OBS-3); `correlation_id` on
  request/message paths (OBS-4, OBS-5).
- **Never `inspect(error)` a transport or decode result**; no bodies,
  headers, tokens or end-user ids (OBS-8).
- **Log a failure once, where it's handled** (OBS-12); alertable failures at
  `error` with `error_code:` and a metric (OBS-7).
- New metadata keys added to the formatter list (OBS-2); `:default_formatter`
  on Elixir >= 1.15 (OBS-15); no `IO.inspect`/`dbg` (OBS-13).

## HTTP (http.md): routers, controllers, router tests

- Build input, call one use case, map result (HTTP-1); `Plug.Parsers` for
  bodies (HTTP-2); one `else` to `ErrorMapper` (HTTP-4); catch-all route
  (HTTP-6); `Plug.ErrorHandler` without bodies (HTTP-7).
- Router tests: one `describe` per verb and path, `Plug.Test`, use cases
  replaced through their ports (HTTP-10, TEST-23).

## Models (model.md): `domain/models/`

- `new/1` with `MapValidator` and `@field_specs`, `@type t`,
  `@enforce_keys` (MODEL-1..3, DATA-1, DATA-3). Multi-value states as atoms
  from a vocabulary module (MODEL-4, DATA-14). `JsonMapper` only when
  `to_json_map/2` is used (MODEL-5, DATA-5). No HTTP/JSON/vendor logic
  (MODEL-10). Amounts are `Decimal` (DATA-6).

## Tests (testing.md): `test/**`

- **Mox only on domain ports**, mocks in `test/support/mocks.ex`, bound in
  `config/test.exs`, `verify_on_exit!`; adapter tests run the real client
  against a stub; never mock `HttpClient`, `ExAws` or internal modules; **no
  new `Mock`/`:meck`** unless `AGENTS.md` overrides TEST-9 (TEST-9).
- HTTP adapter tests assert the request and breaker options captured by the
  stub (TEST-21).
- `describe` names the function (`"handle/1"`), router tests by verb and
  path (TEST-5, TEST-23). **No tests generated with `for`**; `for` inside one
  test body is fine (TEST-19, TEST-25).
- `--no-start`, `start_supervised!/2` (TEST-8); restore global state in
  `on_exit` (TEST-7); no sleeps, use `assert_receive` (TEST-11).
- Happy, error and edge paths for each changed branch (TEST-1); CI coverage
  gate wins (TEST-24); never weaken a test (TEST-2).

## Tooling (quality-tooling.md): `mix.exs`, `.credo.exs`, CI

- Credo >= 1.7.17 with an explicit `enabled:` list including ExSlop (QT-3,
  QT-17); tooling deps dev/test with `runtime: false`, `mix.lock` committed
  (QT-11); formatter and no warnings (QT-15).

## SQL and SQS (sql.md, sqs.md)

- Load only when the repo has Ecto repositories or Broadway SQS consumers.
