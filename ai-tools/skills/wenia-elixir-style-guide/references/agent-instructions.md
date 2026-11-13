# AGENT: Agent instructions

Rule IDs are stable and never renumbered (QT-14).

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| AGENT-1 | Must | The repo's `AGENTS.md` is the single entry point for agent instructions. Tool-specific instruction files only point to it. | review |
| AGENT-2 | Should | A mechanical rule becomes a check (Credo, ExSlop, Reach, compiler or CI). The rule file only names the check in `enforced_by`. | review |
| AGENT-3 | Must | Rule IDs are never renumbered or reused. A removed rule is deleted, and new rules take the next free ID. | review |
| AGENT-4 | Must | The final report of a change states the behaviour changed, the files changed, the checks actually run and their limits. | review |
