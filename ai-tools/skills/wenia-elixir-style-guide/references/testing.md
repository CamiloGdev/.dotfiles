# TEST: Testing

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| TEST-1 | Must | **Tier 1.** Tests written for a behaviour change cover its happy, error and edge paths, including each branch the change adds. | review |
| TEST-24 | Must | **Tier 2, the repo gate.** Where CI enforces a coverage threshold, that threshold wins: add the tests needed to keep it. Where there is none, write tests only when asked or when a silent failure would corrupt data, money or authz. | CI coverage gate |
| TEST-2 | Must | Never weaken a test to get a pass: no loosened assertion, new skip or exclusion tag, or longer timeout. Fix the code or report the conflict. | review |
| TEST-3 | Must | A test lives in the path that mirrors its module (`lib/<app>/a/b.ex` → `test/<app>/a/b_test.exs`). Create a test file only when the module has none. | review |
| TEST-4 | Should | When an operation moves to another module, move its tests, fixtures and setup with it. | review |
| TEST-5 | Must | A `describe` names the function its tests call (`"handle/1"`), and one block holds all its scenarios. The `test` name states the scenario and the expected result. Router tests: see TEST-23. | review |
| TEST-6 | Should | Put `setup` at the narrowest scope that serves every test using it. Reduce indirection unless it helps readability. | review |
| TEST-7 | Must | A suite sets up only what its module needs, and restores global state it changes (`Application.put_env`, `:persistent_term`, ETS) in `on_exit`. Shared helpers go in `test/support/`. | review |
| TEST-8 | Must | Run tests with `--no-start`. Start only what a suite needs, and start processes under test with `start_supervised!/2`. | review |
| TEST-9 | Must | Mox replaces only domain ports. Mocks are defined in `test/support/mocks.ex`, bound in `config/test.exs`, with `setup :verify_on_exit!`. Adapter tests run the real client against a stub. Never mock `HttpClient`, `ExAws` or internal modules. Reuse existing mocks. **No new `Mock`/`:meck` usage** (legacy is in AGENTS.md overrides). | review |
| TEST-10 | Must | Assert public results: return values, persisted rows, published events, HTTP responses. Port expectations may check arguments that belong to the port contract, never which private functions ran. | review |
| TEST-11 | Must | Wait for async work with `assert_receive` or a bounded poll, never a fixed sleep. | review |
| TEST-12 | Must | Fixtures are synthetic but valid: use real CoreLib structs and values, checked against their definitions. Never commit real credentials, keys or customer data, and never call real providers. | review |
| TEST-13 | Should | Cross-module contract checks go in `test/integration/`, full flows in `test/e2e/` with `@moduletag :e2e`, if added. | review |
| TEST-14 | Should | Define mock behaviour inside the expectation callback, and assert received arguments there. | review |
| TEST-15 | Should | For a path that bypasses a port the module calls, declare no expectation (or `expect(Mock, :fun, 0, …)`); `verify_on_exit!` then fails on an unexpected call. | review |
| TEST-17 | Should | Don't mention or assert on components the module under test doesn't use. | review |
| TEST-16 | Must | Helpers and fixtures go before `describe` blocks and contain no assertions. Assertions live in the test body or in a mock callback. | review |
| TEST-18 | Must | Ecto-backed tests are tagged `:database` and use `Ecto.Adapters.SQL.Sandbox` with their own row cleanup. They run through the repo's database test command (for example a `test.database` alias with `--no-start`); ordinary runs use `mix test --no-start --exclude database`. No new provisioning or shared frameworks without approval. | review |
| TEST-19 | Must | Write explicit tests with literal `test` and `describe` names. Don't generate tests with `for`, interpolation or macros. `for` *inside* one test body is fine (TEST-25). | review |
| TEST-20 | Should | Respect explicitly accepted coverage gaps. Don't add connection mocking only to cover DB exception paths. | review |
| TEST-21 | Must | HTTP adapter tests assert the exact request and circuit-breaker options **captured by the stub**, not through a client mock. | review |
| TEST-22 | Should | Compare returned values and mock arguments with `==` against the complete expected value. Pattern-match only on non-deterministic fields (ids, timestamps). | review |
| TEST-23 | Must | Router tests group `describe` blocks by HTTP verb and resource path (`describe "GET /assets"`, `describe "POST /instruments"`). Scenario names state the case and the expected result. | review |
| TEST-25 | Should | Assert collection elements with `for`, not `assert Enum.all?/2`, so a failure shows the element at fault. | review |

## Examples

TEST-14 and TEST-22 (example).

```elixir
expect(AssetsRepositoryMock, :create, fn received ->
  assert input == received
  expected
end)

assert expected == CreateAsset.handle(input)
```

TEST-23: router tests grouped by HTTP verb and resource path.

```elixir
describe "GET /assets/:id" do
  test "returns 404 when the asset does not exist" do
  end
end
```
