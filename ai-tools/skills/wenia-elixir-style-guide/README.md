# Wenia Elixir Style Guide

Wenia's unified Elixir rules, packaged as an agent skill. Every rule has a stable ID, a level (Must, Should, May) and an `enforced_by` column, so writing and code review cite the same rules across repos.

## Capabilities

- Writes Elixir that follows the rules for the code it touches, with the smallest patch that matches existing patterns
- Reviews Elixir code with findings that cite rule IDs, leaving mechanical style to the formatter, compiler, Credo, ExSlop (every check except ListLast) and Reach where adopted
- Covers control flow, naming, errors, data and config, hexagonal architecture, provider boundaries, observability, testing, quality tooling, SQL repositories, HTTP routers, Broadway SQS consumers, domain models and agent instructions
- Follows the repo's own `AGENTS.md`: which rule files apply and which local overrides it declares

## Structure

```
wenia-elixir-style-guide/
├── metadata.yaml         # Asset identity and operational config
├── SKILL.md              # Agent instructions: three-layer model, workflow, rule file index
├── README.md             # This file
├── references/           # Rule files, one family each (flat, no subfolders)
│   ├── README.md         # Index: family, when to read, when it applies
│   └── *.md              # CF, ERR, DATA, ARCH, PB, OBS, TEST, QT, SQL, HTTP, SQS, MODEL, NAME, AGENT
└── evals/                # Evaluation scenarios, one eval-*.md per scenario
```

The rules come in three layers:

1. **Generic Elixir rules:** control flow, naming, observability, testing and quality tooling.
2. **Wenia stack rules:** architecture, errors, data and config, provider boundary, SQL, HTTP, SQS and models. They assume `Wenia.Commons` and CoreLib.
3. **Per-repo facts:** OTP app, namespaces, providers, which rule files apply and local overrides. These live only in each repo's `AGENTS.md`.

## How to Use

1. Install the skill from the AI Marketplace.
2. In the target repo, keep an `AGENTS.md` that lists the repo facts, the rule files that apply and any local overrides (each naming its rule ID, evidence and reason).
3. Ask your AI agent to write or review Elixir code. New code follows the rules unless `AGENTS.md` declares an explicit override for that rule.
4. Verify with each tool's own command (formatter, compiler with warnings as errors, Credo, tests and any others the repo uses) and report what actually ran.

## Usage Examples

Ask your AI agent:

- "Review this adapter against the Wenia Elixir rules"
- "Refactor this module so it doesn't pipe tagged tuples into case"
- "Add a new provider call in this adapter following our conventions"
- "Which rule covers logging provider responses?"
- "Write the router tests for GET /assets/:id"

## Prerequisites

- No MCP servers required
- No VPN connection needed
- The target repo has an `AGENTS.md` that lists its verification commands (QT-1); without one, the skill applies every rule file whose "Applies when" condition holds

## Contributing

- Rule text lives only in `references/*.md`. `SKILL.md` and this README only index it.
- Keep `references/` flat, plain Markdown, English and tool-agnostic, with no frontmatter.
- Each rule is one table row: `ID | Level | Rule | enforced_by`.
- Rule IDs are stable: never renumber or reuse one (QT-14, AGENT-3). A removed rule is deleted, and new rules take the next free ID in their family.
- Mechanical rules become checks; the rule file only names the check (QT-2, AGENT-2).
- Per-repo facts and exceptions go in that repo's `AGENTS.md`, never in this skill.
- Update `references/README.md`, the index in `SKILL.md` and the evals when a family changes. Bump `spec.version` in `metadata.yaml` per the catalog's versioning table once the skill is published.
- Record an eval as `pass` only after a real passing run (see `evals/README.md`).
