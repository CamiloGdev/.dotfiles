# CF: Control flow

**enforced_by:**
- `credo:X` is a stock Credo check, `exslop:X` an ExSlop check and `reach:X` a Reach smell (see README).
- Mechanical items only name their check (QT-2).

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| CF-1 | Must | Apply the [Elixir anti-patterns](https://hexdocs.pm/elixir/what-anti-patterns.html) (code, design, process and macro) and [Good and Bad Elixir](https://keathley.io/blog/good-and-bad-elixir.html) to the code a change touches. Do not rewrite untouched code to follow them. | review |
| CF-2 | Should | Match known shapes, literals and field equality in function heads. Repeat a variable to require two values to be equal. | review |
| CF-3 | Should | Use guards only for what a pattern can't express: type, size, range or membership. Match required fields instead of checking that a map is non-empty. | review |
| CF-4 | Should | When one module repeats a guard condition, define it once with `defguardp` and name it after the rule it expresses. | review |
| CF-5 | Must | Use `case` when the outcomes of one result need different handling. Use `with` for a linear chain whose failures propagate unchanged. No single-clause `with`. | credo:WithSingleClause, review |
| CF-6 | Must | Normalize each step's error inside the function that performs the step. A `with` has **at most one `else` clause**. Each service decides how it normalizes errors before that clause. | review |
| CF-7 | Must | Use `if`/`else` for one boolean choice, including a `case` that only matches `true` and `false`. Use `cond` only for several distinct conditions. | exslop:CaseTrueFalse (enable), credo:CondStatements, reach:boolean_case |
| CF-8 | Should | Give a condition that mixes separate decisions a named predicate. Extract a function instead of nesting an `if` in a branch. | credo:Nesting (max_nesting: 2, exit_status: 0; catches deep nesting only, review for single nesting), review |
| CF-9 | Must | Pipe data transformations only. Never pipe `{:ok, _}`/`{:error, _}` into the next function, and never pipe into `case`, `if`, `cond` or `with`. Bind first, then branch. No nested `case`/`with`. | credo:BlockPipe (enable), review |
| CF-10 | Should | Traverse with `Enum`, `Stream` or `for` at the call site. No helper whose whole body is one traversal. Measure before using `Stream`. | review |
| CF-11 | Must | A constant is a zero-arity **function** in the module that owns its vocabulary (`DomainErrors`, `HttpErrors`, status modules). Capture it in a module attribute only where a pattern or guard needs it. | review |
| CF-12 | Must | Module attributes are compile-time snapshots. Never put runtime config, env reads, I/O results or large data in them. | credo:ApplicationConfigInModuleAttribute, review |
| CF-13 | Must | Write a macro or a `use` only for code generation or a DSL a function can't express (`Plug.Router`, `Broadway`). Repetition alone doesn't justify one. | review |
| CF-14 | Must | Name a function for its operation or decision, not its mechanics. Avoid `process/1`, `helper/2`, `do_run/1` and `run/N` (see NAME-7). | review |
| CF-15 | Should | All clauses of one function serve one purpose on one kind of input. Split unrelated clauses into named functions. | review |
| CF-16 | Should | Use `true` as the final `cond` fallback. Prefer positive `if` over `unless … else`. | credo:UnlessWithElse, review |
| CF-17 | Should | When the expected number of parts is known, pass `parts:` to `String.split/3`, then match the result. A limit alone doesn't validate the count. | review |
| CF-18 | Should | Detect duplicates with `Enum.reduce_while/3` and a `MapSet`, halting on the first repeat. Keep the public return contract. | review |
| CF-19 | Should | A `Stream` pipeline (justified per CF-10) may keep one transformation per stage. With `Enum`, compose named functions inside a single `map`. | credo:MapMap (enable) |
| CF-20 | Must | Don't build module names dynamically (`Module.concat/2`, `:"Elixir.…"`, `String.to_atom/1`). Name modules as aliases. | credo:UnsafeToAtom (enable), review |
| CF-21 | Should | Use `and`/`or`/`not` when operands are booleans. Keep `&&`/`\|\|`/`!` for truthy values. | review |
| CF-22 | Should | Normalize inputs at the start of the flow, but never ahead of a required verification. | review |
| CF-23 | Should | Prefer a pipeline over nested calls when there is more than one transformation. Use a direct call for a single one. | credo:NestedFunctionCalls (enable, exit_status: 0), review |

## Examples

CF-6 and CF-9: errors are normalized per step, with one common `else`.

```elixir
with {:ok, asset} <- fetch_asset(id),
     {:ok, instrument} <- build_instrument(asset, attrs) do
  {:ok, instrument}
else
  {:error, _reason} = error -> error
end
```

CF-11: a function constant, captured in an attribute only for a pattern.

```elixir
alias MyService.Domain.Errors.DomainErrors

@asset_not_found DomainErrors.asset_not_found()

def map_result({:error, @asset_not_found} = error), do: error
```

CF-19: one map stage per transformation with `Stream`, merged with `Enum`.

```elixir
rows |> Stream.map(&decode/1) |> Stream.map(&to_domain/1) |> Enum.to_list()
rows |> Enum.map(&(&1 |> decode() |> to_domain()))
```
