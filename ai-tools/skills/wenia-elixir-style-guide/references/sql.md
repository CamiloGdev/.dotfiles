# SQL: SQL repository adapters

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| SQL-1 | Must | Make read/write routing explicit: reads go through `CoreDBReadConnection`, writes through `CoreDBWriteConnection`. Never hide a write in a read-oriented module. | review |
| SQL-2 | Must | Keep input contracts explicit. Creation takes the matching domain or CoreLib struct; updates take the matching domain model or an atom-keyed attribute map. Don't add string-key normalization. Unsupported shapes return `{:error, DomainErrors.invalid_repository_input()}`. | review |
| SQL-3 | Must | **ERR-4 extension.** A field-level validation failure returns `{:error, DomainErrors.name(), %{field => message}}`. Keys are field atoms, values are messages, and the first message per field wins. Named constraint errors stay two-element tuples. | review |
| SQL-4 | Should | A required boolean accepts `true` and `false`. For `nil`, the message is `"must be true or false"`, not `"can't be blank"`. | review |
| SQL-5 | Must | Interpolate Decimal values in messages with `Decimal.to_string(value, :normal)` (DATA-6). | review |
| SQL-6 | Should | Keep pagination validation minimal: `limit` and `page` are positive integers. No ID-range bounds on pagination params. | review |
| SQL-7 | Must | Validate supplied IDs independently of dirty tracking. IDs are positive and within their supported bound. An explicitly supplied foreign ID is validated even when it equals the stored value. Omitted fields and permitted `nil`s stay unchanged. | review |
| SQL-8 | Must | **The explicit exception to ERR-9.** Rescue only connection errors (`DBConnection.ConnectionError`, `Postgrex.Error`), with a function-level `rescue` in the action. No nested `try` and no generic wrapper. Log `exception.__struct__`, never `inspect(exception)`. Return `{:error, DomainErrors.unexpected_repository_error()}`. | credo:PreferImplicitTry (only a `try` that is the whole body), review |
| SQL-9 | Must | Use Ecto's tuple-returning functions (`insert/2`, `update/2`, `delete/2`), never the bang variants, so everything except connection errors is a result to match. | review |
| SQL-10 | Should | The adapter facade delegates to role-named modules whose functions are the actions. New code uses e.g. `AssetWriter.create/1` and `AssetReader.get/1`, not `Actions.Create.run/1`. | review |
| SQL-11 | Must | Ecto schemas and changesets never leave the adapter. `map_result/1` converts them into the domain or CoreLib type the port promises. | review |

## Examples

SQL-8 and SQL-9:

```elixir
def create(%Asset{} = asset) do
  with {:ok, changeset} <- AssetSchema.create_changeset(asset) do
    changeset |> CoreDBWriteConnection.insert() |> AssetSchema.map_result()
  end
rescue
  exception in [DBConnection.ConnectionError, Postgrex.Error] ->
    Logger.error("Asset repository unavailable", exception: exception.__struct__,
      error_code: DomainErrors.unexpected_repository_error())
    {:error, DomainErrors.unexpected_repository_error()}
end
```

SQL-10: the facade, with role-named modules instead of `Actions.*.run`.

```elixir
@impl AssetsRepository
defdelegate create(asset), to: AssetWriter

@impl AssetsRepository
defdelegate get(id), to: AssetReader
```

SQL-10 applies to new code.
