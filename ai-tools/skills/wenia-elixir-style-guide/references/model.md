# MODEL: Domain models

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| MODEL-1 | Should | Layout in order: aliases, `@type t`, `@enforce_keys`, `@field_specs`, `defstruct`, `new/1`, domain operations, private helpers. Add `use JsonMapper` first only when MODEL-5 applies. | review |
| MODEL-2 | Must | `new/1` takes an atom-keyed map, validates with `Wenia.Commons.Validators.MapValidator` (aliased), returns `{:ok, t}` or the validator's `{:error, %{field => msg}}`, and builds in a private `to_model/1` (DATA-1, ERR-4). | review |
| MODEL-3 | Must | Declare `@enforce_keys` for every field each construction must set, aligned with `@type t` (DATA-3). | review |
| MODEL-4 | Must | A multi-value state is an atom from a vocabulary module, validated with `in: Vocabulary.all()` (DATA-14). Convert wire strings at the entry point or adapter. | review |
| MODEL-5 | Must | `use Wenia.Commons.Macros.JsonMapper` (directly, not through an alias) only when the model calls `to_json_map/2` (DATA-5). Add `decimal_decode: true` when it holds `Decimal`. | review |
| MODEL-6 | Must | Convert string-keyed maps and numeric strings before `new/1`; the model doesn't silently coerce. Use dot access for validated required fields and bracket access for optional ones, and apply defaults only after validation. | review |
| MODEL-7 | Must | Validate nested collections as `type: :array`, then build each element through the child's constructor. A list builder accepts child structs and atom-keyed maps, stops at the first error, and preserves input order. | review |
| MODEL-8 | Should | Functions that update model fields, or decide business rules that depend only on the model's values, live in the model and are pure (ARCH-9). | review |
| MODEL-9 | Should | Reuse a CoreLib model where one exists. Don't wrap it in a duplicate local struct. | review |
| MODEL-10 | Must | Models contain no HTTP, Ecto, JSON-decoding or vendor logic (ARCH-1). | review |

## Example (MODEL-1..6)

```elixir
defmodule MyService.Domain.Models.PriceAlert do
  alias MyService.Domain.Models.AlertStatuses
  alias Wenia.Commons.Validators.MapValidator

  @type t :: %__MODULE__{id: String.t(), threshold: Decimal.t(), status: atom()}
  @enforce_keys [:id, :threshold, :status]
  @field_specs %{
    id: [required: true, type: :string],
    threshold: [required: true, type: :decimal, greater_than: Decimal.new(0)],
    status: [required: true, in: AlertStatuses.all()]
  }
  defstruct @enforce_keys

  def new(%{} = attrs) do
    case MapValidator.validate(attrs, @field_specs) do
      :ok -> {:ok, to_model(attrs)}
      {:error, _} = error -> error
    end
  end

  defp to_model(attrs), do: %__MODULE__{id: attrs.id, threshold: attrs.threshold, status: attrs.status}
end
```

`PriceAlert` and `AlertStatuses` are invented to illustrate the rules.
