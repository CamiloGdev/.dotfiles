# Unified Elixir rules: index

Version: 0.1.0 (2026-10-21)

The rules come in three layers:
1. **Generic Elixir rules:** control flow, naming, observability, testing and quality tooling. They apply to any Elixir repo.
2. **Wenia stack rules:** architecture, errors, data and config, provider boundary, SQL, HTTP, SQS and models. They assume `Wenia.Commons` and CoreLib (`ModuleInyector`, `MapValidator`, `JsonMapper`, `DomainErrors`, `ErrorMapper`).
3. **Per-repo facts:** the OTP app, namespaces, providers, legacy exceptions, overrides and which rule files apply. These live only in the repo's `AGENTS.md`, never in the rule files.

Rule text uses placeholders: `<App>` for the root namespace, `:<otp_app>` for the OTP app and `lib/<app>/` for its source path. Examples use a neutral `MyService`.

- Rule IDs are stable and never renumbered (QT-14).
- Every rule has a level:
  - **Must:** baseline.
  - **Should:** default, with justified exceptions.
  - **May:** optional.
- `enforced_by` is `review`; `credo:<Check>` (stock Credo, `Credo.Check.<Category>.<Check>`); `exslop:<Check>` (`ExSlop.Check.<Category>.<Check>`); `reach:<smell>` (a Reach smell, advisory unless `mix reach.check --smells --strict`); `.reach.exs` (a Reach policy); or `compiler`, `mix format` or CI. *(enable)* marks a check that is off in Credo's default config or outside `ExSlop.recommended_checks()` and must be listed in `.credo.exs`.
- Other notes in parentheses after a check give its params (for example `max_nesting: 2` or `exit_status: 0`), the entries of a `.reach.exs` policy, or a limit of what it detects. `exit_status: 0` reports findings without failing the run (QT-5).

| File | Family | Read when you touch | Applies when |
|---|---|---|---|
| [control-flow.md](control-flow.md) | CF-1..23 | any `lib/**/*.ex`: clauses, `case`/`with`, pipes, constants, macros | always |
| [errors.md](errors.md) | ERR-1..15 | result shapes, `DomainErrors`, `ErrorMapper`, rescue, retries | always |
| [data-and-config.md](data-and-config.md) | DATA-1..20 | structs, validation, amounts, `config/*.exs`, any config read | always |
| [architecture.md](architecture.md) | ARCH-1..17 | ports, adapters, use cases, processes, messaging | always |
| [provider-boundary.md](provider-boundary.md) | PB-1..13 | HTTP, DynamoDB and Redis adapters, provider responses | the repo has HTTP, DynamoDB or Redis adapters |
| [observability.md](observability.md) | OBS-1..15 | logging, metadata, metrics | always |
| [testing.md](testing.md) | TEST-1..25 | any `test/**` | always |
| [quality-tooling.md](quality-tooling.md) | QT-1..17 | the repo's `mix.exs`, `.credo.exs`, `.formatter.exs`, `coveralls.json`, CI workflows | always |
| [sql.md](sql.md) | SQL-1..11 | SQL repository adapters and their tests | the repo has Ecto repositories |
| [http.md](http.md) | HTTP-1..10 | HTTP routers and router tests | the repo has a Plug router |
| [sqs.md](sqs.md) | SQS-1..10 | Broadway SQS consumers | the repo has a Broadway SQS consumer |
| [model.md](model.md) | MODEL-1..10 | domain models | the repo has domain models |
| [naming.md](naming.md) | NAME-1..12 | naming, alias/defdelegate layout, docs | always |
| [agent-instructions.md](agent-instructions.md) | AGENT-1..4 | the repo's `AGENTS.md`, tool-specific instruction files, rule files, the final report of a change | always |
