# New Relic MCP

New Relic access from OpenCode uses the official hosted MCP server with separate
User API keys for production (PDN) and QA. The persistent MCP entries live in
`opencode/.config/opencode/opencode.jsonc`; `zsh/.zshenv` loads the private
credential file directly.

## Environments

| Environment | MCP name | Account ID | Key variable | Region |
|---|---|---|---|---|
| PDN | `newrelic_pdn` | `3760362` | `NEW_RELIC_API_KEY` | US |
| QA | `newrelic_qa` | `7346792` | `NEW_RELIC_API_KEY_QA` | US |

Always pair the selected connection with its explicit `account_id`. Connection
names do not restrict the accounts accessible to the key's owner.

## Private credentials

Create or edit `~/.config/newrelic/nerdgraph.env` locally. Keep existing keys when
migrating an installation. This file must remain outside version control.

```zsh
export NEW_RELIC_API_KEY="REPLACE_WITH_PDN_USER_KEY"
export NEW_RELIC_ACCOUNT_ID="3760362"
export NEW_RELIC_REGION="US"

export NEW_RELIC_API_KEY_QA="REPLACE_WITH_QA_USER_KEY"
export NEW_RELIC_ACCOUNT_ID_QA="7346792"
export NEW_RELIC_REGION_QA="US"
```

```zsh
chmod 600 ~/.config/newrelic/nerdgraph.env
```

Use **User keys**, not ingest/license keys. The MCP configuration references the
environment variables via `{env:...}`; do not put literal secrets in JSON.

## Connection

- Endpoint: `https://mcp.newrelic.com/mcp/` (US, including the trailing slash).
- Authentication: `oauth: false` and the `api-key` request header.
- Tool filter: `discovery,data-access,performance-analytics`.

The user's organization must permit MCP access and API-key authentication in
New Relic Feature Control Manager. Add `alerting,incident-response` to the tool
filter when specialized alert or change-event tools are needed.

Start OpenCode from a fresh zsh terminal after configuring credentials. Restart
existing OpenCode sessions to load new MCP configuration. Applications launched
outside the configured shell may need their environment supplied separately.

## Verification

```zsh
opencode mcp list
```

Both New Relic entries should be connected. Then use the selected server's
`execute_nrql_query` tool with the Account ID above and:

```sql
SELECT count(*) FROM Log SINCE 5 minutes ago
```

Check for a valid result without MCP or GraphQL errors. A connected catalog alone
does not prove data access. OAuth status commands do not validate API-key servers.

## Migration from shell helpers

The old `nerdgraph.zsh` and `newrelic_healthcheck.zsh` are no longer part of this
setup. Their operational purpose is replaced by MCP tools and a connection/data
query check. Keep the credential file and the direct source in `.zshenv`.

All 26 documented Customers on-call queries plus a live-log control were exercised
in PDN through MCP and compared with NerdGraph; QA was also validated. Use fixed
time bounds for comparisons. Log-row ordering may differ without changing the
records. Full NerdGraph response metadata is not needed for these diagnostics.

API keys cover the core NRQL/log workflows. New Relic's AI reports and some preview
tools require OAuth and additional product capabilities. Agent-authored NRQL can
still be executed with the API key.

## References

- [New Relic MCP setup](https://docs.newrelic.com/docs/agentic-ai/mcp/setup/)
- [MCP tool reference](https://docs.newrelic.com/docs/agentic-ai/mcp/tool-reference/)
- [OpenCode MCP configuration](https://opencode.ai/docs/mcp-servers/)
- [Optional official skills](https://github.com/newrelic/nr-skills-hub)
