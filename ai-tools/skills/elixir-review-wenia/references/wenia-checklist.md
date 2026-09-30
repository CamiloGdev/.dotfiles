# Wenia Elixir Review Checklist (condensed)

Distilled from: `customersDocs/AI/reviewCode/AGENTS.md` (service contract),
`customersDocs/AI/reviewCode/rules/elixir-style-guide.md` (§ references
below), `customersDocs/AI/reviewCode/rules/agents-standard.md` (code
examples), and `WeniaCustomers/.agents/rules/pr-feedback.md` (freshest
reviewer lessons). The full sources are the human evidence library — consult
them only when a finding needs its source or example.

Tiers: **[C]** consensus (cross-reviewer + fleet) → report **medium**
(high only with a concrete bug/security/data-loss scenario). **[R]**
recommended → **low** (medium only with measured impact), always with
context. **[P]** individual preference → **suggest once as low or omit**.
Conventions are **never critical**. Runtime scoping: OTP/process items apply
to long-lived supervised services only — skip for Mix tasks, lambdas, and
migration-only repos.

## Error model [C]

- Domain errors as macros in `DomainErrors`; mapped in `ErrorMapper` with
  `B00-*`/`T00-*` codes (B = 4xx business, T = 5xx technical) + catch-all
  fallback to `T00-000`/500. Flag inline atoms/ad-hoc tuples. (style §3.2)
- Handlers preserve 4xx/5xx semantics; prefer `service_error_code/2` helper
  over literals. (style §5.2)

## Layers & ports [C]

- Use cases orchestrate only via `adapter_for` (explicit
  `[mode:, ports:]` from shared `Wenia.Commons` macro; never a service-local
  injector copy; never mixed injectors in one module). No infra calls inline.
  (pr-feedback §3–4, style §2.2)
- Adapters: `@behaviour` + `@impl true`; normalize transport failures to
  domain errors; shared `HttpClient` (no manual `Content-Length`); bodies via
  `Jason.encode_to_iodata!/1`; SQL repos as thin `defdelegate` facades.
  (agents-standard Adapters, style §6.3)
- Models: `MapValidator`/`JsonMapper` `@field_specs` in `new/1`;
  `@enforce_keys` + `@type t`; dot access required, bracket optional.
  (style §6.1)
- Routers declarative with canonical plug order (`:match`, Parsers
  json/Jason, `:dispatch`); logic in use cases; mapping centralized. Large
  router acceptable if declarative. (style §5.1, §10.2)

## with/case idioms [C]

- `case` for single branches; `with` only for 2+ chained success matches
  (+ `else` when error shape matters). (style §3.4)
- Never `with`-inside-`else`: extract a private helper using `case`.
  (pr-feedback §1)
- Inline single-use expressions in `with`. (pr-feedback §2)
- No `try/rescue/catch` for normal domain outcomes. (style §3.5)

## Config & boot [C]

- Port-keyed config + `fetch_env!/2`; `AppConfig` facade with typed
  accessors; endpoints named `api_url`; AWS prod via credential-chain
  tuples, never fixed secrets. (style §8.1–8.3)
- `application.ex`: explicit children incl. `HttpClient`/Finch; supervised
  long-lived state only; no stateless GenServer. (style §7.1)
- `prom_ex` module per service; telemetry as documented contract; single
  instrumentation strategy. (AGENTS.md, style §9.2)

## Boundaries & contracts [C/R]

- AMQP: transport in `entry_point/amqp`, publishing in `adapters/amqp`;
  iodata → binary once at `publish`. (style §3.8)
- Don't over-expose internals in external contracts. [C] (anti-pattern A7)
- API decimals via `Decimal.to_string(:normal)`; prefer
  `String.to_existing_atom` over `String.to_atom` on runtime input. [R]
  (style §9.1, §9.3)
- `opts` (private) vs `options` (public); namespaced stable cache keys,
  in-memory `{__MODULE__, :descriptor}`. Softened forms only — never mandate
  exact identifiers or strict triples (demoted by fleet audit). [R]
  (style §8.4)

## Tests [C]

- Deterministic (no sleeps); edge/error paths, not happy-path only; ONE
  mock strategy per surface; mock adapters, not ports; `async: false`;
  runnable with `--no-start`; `Plug.Test` for entry points; processes in
  `setup`/`on_exit`; `?`-predicates return booleans. (style §4, AGENTS.md)

## Suggest-only [P] — low or omit

- Correlation/context propagation in async trees; UUIDv7; infra alternatives
  (Ranch/SQS); `WDYT` design nudges; log-language styling; moduledoc
  enrichment pushes. (style "Consensus vs Individual Preferences")
