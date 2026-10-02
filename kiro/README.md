# Kiro MCP setup

Kiro CLI MCP servers live in `~/.kiro/settings/mcp.json`. The live file is
**not** symlinked from dotfiles because it holds the Linear token; use
`mcp.json.example` as the template.

| Server | Auth | Notes |
|---|---|---|
| `notion` | OAuth | Works out of the box (browser flow). |
| `linear` | Bearer token | Kiro CLI cannot complete Linear's MCP OAuth (bug [#11758](https://github.com/kirodotdev/Kiro/issues/11758)); the token is synced from OpenCode. |
| `newrelic_pdn` | `api-key` header | `NEW_RELIC_API_KEY` (see `~/.config/newrelic/nerdgraph.env`). |
| `newrelic_qa` | `api-key` header | `NEW_RELIC_API_KEY_QA`. |

## Setup on a new machine

1. Copy the template and fill the Linear token placeholder:

   ```zsh
   mkdir -p ~/.kiro/settings
   cp ~/.dotfiles/kiro/.kiro/settings/mcp.json.example ~/.kiro/settings/mcp.json
   chmod 600 ~/.kiro/settings/mcp.json
   ```

2. Ensure New Relic keys are exported (they load from `~/.config/newrelic/nerdgraph.env`
   via `~/.zshenv`). Start Kiro from a shell where those variables exist.

3. Sync the Linear token from OpenCode:

   ```zsh
   kiro-linear-sync
   ```

4. Start `kiro-cli` and check `/mcp` (expect notion, linear, newrelic_pdn,
   newrelic_qa all running).

## Notes

- The Kiro IDE cannot use MCP in this workspace: the organization disables MCP
  usage via enterprise governance. The CLI is unaffected.
- `~/.kiro/settings/mcp.json` must stay private (mode 600).
