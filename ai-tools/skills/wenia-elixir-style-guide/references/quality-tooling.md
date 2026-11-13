# QT: Quality tools

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| QT-1 | Should | Each verification tool has a command that agents, developers and CI run the same way (for example `mix compile --warnings-as-errors`, `mix xref graph --label compile-connected --fail-above 0`, `mix format --check-formatted`, `mix credo`, `mix reach.check`, `mix ex_dna`, `mix test`). List them in the repo's `AGENTS.md`. Grouping them in an alias is optional. | review |
| QT-2 | Must | Mechanical style belongs in tools. When reviewers repeat a mechanical comment, add or tune a check instead of a prose rule. Rule files only name checks. | review |
| QT-3 | Must | The repo's `.credo.exs` keeps an explicit `enabled:` list. List every Credo and ExSlop check there; with an explicit list, `plugins: [{ExSlop, []}]` adds no checks. Enable every ExSlop check except ListLast (QT-6), including the ones outside `ExSlop.recommended_checks()` that rules rely on: CaseTrueFalse (CF-7), ObviousComment and StepComment (NAME-11). | review |
| QT-5 | Must | A new check that would need a sweep starts at `exit_status: 0`, and fails once its findings are fixed. | review |
| QT-6 | Should | Keep Credo CondInsteadOfIfElse, AliasAs, DuplicatedCode, ModuleDependencies, Specs, SinglePipe, PipeChainStart, OnePipePerLine, ABCSize and VariableRebinding, and ExSlop ListLast, disabled. Every other ExSlop check runs (QT-3). | review |
| QT-7 | Must | A suppression states its reason inline and has the narrowest scope: one line, one check. Never suppress a domain-to-adapter call, and never weaken a test to pass the gate. | review |
| QT-8 | Must | Don't apply ExSlop or Reach suggestions mechanically when they change a contract (boolean → truthy, removed assertive match). | review |
| QT-9 | Should | Raising the clone budget needs a stated reason. Never add a macro just to lower the clone count. | review |
| QT-10 | Must | If Reach is adopted, the repo's `.reach.exs` describes the real layers. Never widen a pattern to silence a forbidden dependency. | review |
| QT-11 | Must | Static analysis and tooling deps are dev/test only with `runtime: false`. `mix.lock` is committed. | review |
| QT-13 | Should | When Dialyzer runs in CI, the PLT cache key names OS, OTP and Elixir versions and hashes `mix.lock`. | review |
| QT-14 | Must | Rule IDs are stable: never renumber or reuse one. A retired rule is deleted and its ID stays unused. | review |
| QT-15 | Must | Use the project's `.formatter.exs` and `mix format`. Code compiles without warnings. | `mix format --check-formatted`, compiler |
| QT-16 | Should | A published library defines a versioning policy and license, and ships usable docs. | review |
| QT-17 | Must | The project depends on Credo 1.7.17 or later (for example `{:credo, "~> 1.7 and >= 1.7.17", only: [:dev, :test], runtime: false}`). ExSlop requires Credo `~> 1.7`, and so does ExDNA's optional Credo integration. Credo 1.6 has no Dbg, MissedMetadataKeyInLoggerConfig, CondInsteadOfIfElse or OnePipePerLine check, and Credo before 1.7.17 has no CondInsteadOfIfElse or WrongTestFilename; an older Credo skips an enabled check it doesn't have with only a warning. | review (`mix.exs`, `mix.lock`) |
