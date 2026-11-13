# NAME: Naming, layout and documentation

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| NAME-1 | Should | `snake_case` for functions, variables, attributes and files; `CamelCase` for modules; verb-first function names. | credo:FunctionNames, credo:ModuleNames, credo:VariableNames, credo:ModuleAttributeNames, review |
| NAME-2 | Must | `?` marks a boolean predicate (ERR-2), `is_` a guard-compatible check (never both), and `!` an API whose semantic failure raises (ERR-3). | credo:PredicateFunctionNames, review |
| NAME-3 | Should | Keep the `get`/`fetch`/`fetch!` conventions: a default value, a tagged presence result, and raising access. | review |
| NAME-4 | Should | Omit a redundant `as:`: in `alias`/`require` when it repeats the last segment, and in `defdelegate` when the target has the same name. | review |
| NAME-5 | Should | Separate the `use`, `alias`, `import` and `require` groups, the callbacks and the module-attribute groups with a blank line. | review |
| NAME-6 | Should | Write regexes as sigils, with delimiters that minimize escaping. | review |
| NAME-7 | Must | An adapter that exposes a facade is named for its role, and its functions are the actions (`TransactionFinder.find_by_id/1`, `AssetWriter.create/1`). Avoid repeating the name (`FindById.find_by_id/1`) and avoid `run/N` (CF-14). | review |
| NAME-8 | Should | Library modules stay under their own namespace and respect existing extension mechanisms. | review |
| NAME-9 | Should | Document module purpose with `@moduledoc`, public operations with `@doc` (inputs, results, important failures), and public types with `@typedoc`. Use doctests for deterministic examples. | credo:ModuleDoc (`@moduledoc` only), review |
| NAME-10 | Must | `@doc false` hides docs; it isn't access control. Use `defp` for private functions. | review |
| NAME-11 | Should | Comments explain why, constraints, or non-obvious consequences, never what the code says. | exslop:ObviousComment (enable), exslop:StepComment (enable; flags any comment starting "Step N"), exslop:NarratorComment, review |
| NAME-12 | Should | Use `alias` or a scoped `import` when injection isn't needed. Keep `use` for real extension points (CF-13). | review |

## Example (NAME-4, NAME-5, NAME-7)

```elixir
defmodule MyService.Adapters.Repositories.SQL.Assets.Adapter do
  @behaviour MyService.Domain.Ports.AssetsRepository

  alias MyService.Adapters.Repositories.SQL.Assets.{AssetReader, AssetWriter}
  alias MyService.Domain.Ports.AssetsRepository

  @impl AssetsRepository
  defdelegate get(id), to: AssetReader
end
```
