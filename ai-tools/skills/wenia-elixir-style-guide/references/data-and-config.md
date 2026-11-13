# DATA: Data and configuration

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| DATA-1 | Must | External attributes are validated once, where they become a model: `new/1` checks them with `MapValidator` against `@field_specs` and builds the struct in a private `to_model/1`. Never build a model from untrusted input with `struct/2` or a literal. | review |
| DATA-2 | Must | Code that receives a validated struct trusts it and doesn't re-check its fields. `@type`, `@enforce_keys` and specs validate nothing. | review |
| DATA-3 | Must | A new or changed struct declares `@type t` and lists in `@enforce_keys` every field each construction must set. | review |
| DATA-4 | Must | Required keys use a pattern, dot access or `Map.fetch!/2`/`Keyword.fetch!/2`. Optional keys use `attrs[:key]` or `get/3` with a deliberate default. | review |
| DATA-5 | Must | Add `use Wenia.Commons.Macros.JsonMapper` only to a model that calls the generated `to_json_map/2`. | review |
| DATA-6 | Must | Amounts stay `Decimal` or the original decimal string. Parse with `Decimal.parse`, render with `Decimal.to_string(d, :normal)`. Never use float math or plain interpolation. | review |
| DATA-7 | Must | An adapter's settings live under its port key (`config :<otp_app>, Port, adapter: …`). A module without a port uses its own module as the key. | review |
| DATA-8 | Must | Read a required setting with `Application.fetch_env!/2` and `Keyword.fetch!/2`. Use `Keyword.get/3` with a default only for an optional setting whose default is intended. | review |
| DATA-9 | Must | A setting that a use case needs comes through its port's adapter or as an argument. The domain never calls `Application`. | review |
| DATA-10 | Must | **No AppConfig facade.** Each module that needs configuration reads it in a private `config/1` (or at its `init`) and builds what it needs. Raw readers stay private. | review |
| DATA-11 | Must | A required or structured setting fails at boot: the module that owns it fetches and validates it when its process or the application starts, so call sites trust it. | review |
| DATA-12 | Must | Values that differ per deployment are `{:system, "VAR"}` tuples resolved by `ConfigTuples` at release start. Secrets come from injected env or the AWS credential chain, never from tracked config. | review |
| DATA-13 | Must | Removing or renaming a port, adapter, process or dependency removes its entries from every `config/*.exs` in the same change. | review |
| DATA-14 | Must | A state with more than two values is one atom field backed by a vocabulary module, never several booleans. Wire strings only at the boundary. | review |
| DATA-15 | Should | A domain value with its own invariants or several parts travels as a model struct built by `new/1`, not as loose strings, tuples or maps. | review |
| DATA-16 | Should | Config keys and scalar config functions carry their unit (`_ms`, `_seconds`, `_bytes`). | review |
| DATA-17 | May | If a hot path caches config in `:persistent_term`, write it once at boot under `{:<otp_app>, key}`, treat it as an immutable snapshot, and never store request state. Tests restore it in `on_exit` (TEST-7). | review |
| DATA-18 | Must | Never create atoms from external input. Map accepted values explicitly. `String.to_existing_atom/1` doesn't validate allowed values. | credo:UnsafeToAtom (enable), review |
| DATA-19 | Should | Group related arguments into a meaningful map or struct. Don't add an options bag only to lower arity (max arity 5). | credo:FunctionArity (max_arity: 5), review |
| DATA-20 | Should | Configure reusable components through arguments or start options. Global application config needs a reason, such as choosing an implementation. | review |

## Examples

DATA-10: the module reads its own config privately. There is no `AppConfig.rates_service_config/0`.

```elixir
defmodule MyService.Adapters.Http.RatesService do
  @behaviour MyService.Domain.Ports.RatesService

  defp config(key) do
    :my_service
    |> Application.fetch_env!(MyService.Domain.Ports.RatesService)
    |> Keyword.fetch!(key)
  end
end
```

DATA-14: a vocabulary module for the state, and `MapValidator` membership against its values.

```elixir
defmodule MyService.Domain.Models.InstrumentStatuses do
  def active, do: :active
  def disabled, do: :disabled
  def all, do: [active(), disabled()]
end

# The adapter or mapper converts the wire string; the model only holds the atom.
defp to_status("ACTIVE"), do: InstrumentStatuses.active()
defp to_status("DISABLED"), do: InstrumentStatuses.disabled()
```

Convert wire strings to atoms in the adapter or mapper, never in the model or the validator.
