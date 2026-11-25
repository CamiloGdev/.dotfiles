# Kiro MCP setup

Kiro CLI MCP servers live in `~/.kiro/settings/mcp.json`. The live file is
**not** symlinked from dotfiles because it is machine-private and may hold
credentials; use `mcp.json.example` as the template. Validated with Kiro CLI
3.6.0: all four servers use native OAuth or the `api-key` header, with no
Linear Bearer token.

| Server | Auth | Notes |
|---|---|---|
| `notion` | OAuth | Works out of the box (browser flow). |
| `linear` | OAuth (2.29.1+) | Fixed in Kiro CLI 2.29.1 ([#11758](https://github.com/kirodotdev/Kiro/issues/11758)). Authenticate with `/mcp`; the OpenCode token sync remains as a fallback. |
| `newrelic_pdn` | `api-key` header | `NEW_RELIC_API_KEY` (see `~/.config/newrelic/nerdgraph.env`). |
| `newrelic_qa` | `api-key` header | `NEW_RELIC_API_KEY_QA`. |

## Setup on a new machine

1. Copy the template (no Linear token needed with current versions):

   ```zsh
   mkdir -p ~/.kiro/settings
   cp ~/.dotfiles/kiro/.kiro/settings/mcp.json.example ~/.kiro/settings/mcp.json
   chmod 600 ~/.kiro/settings/mcp.json
   ```

2. Ensure New Relic keys are exported (they load from `~/.config/newrelic/nerdgraph.env`
   via `~/.zshenv`). Start Kiro from a shell where those variables exist. `${VAR}`
   references are expanded from that environment; if a literal key is used instead,
   keep the file at mode 600.

3. Authenticate the OAuth servers from `kiro-cli chat` with `/mcp` (Notion and
   Linear; this opens the browser). If Linear's OAuth ever fails again, fall
   back to `kiro-linear-sync` and restore the Bearer header.

4. Start `kiro-cli` and check `/mcp` (expect notion, linear, newrelic_pdn,
   newrelic_qa all running). From a shell, `kiro-cli mcp list` shows the default
   agent's four servers.

## Notes

- The Kiro IDE cannot use MCP in this workspace: the organization disables MCP
  usage via enterprise governance. The CLI is unaffected.
- `~/.kiro/settings/mcp.json` must stay private (mode 600).
