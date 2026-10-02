# Kiro Linear MCP token sync

Kiro CLI cannot complete Linear's MCP OAuth token exchange (Kiro bug
[#11758](https://github.com/kirodotdev/Kiro/issues/11758)), so `linear` in
`~/.kiro/settings/mcp.json` authenticates with a Bearer token instead of OAuth.

`sync-token.sh` copies the Linear access token that OpenCode already holds
(and keeps refreshed) into Kiro's MCP config, verifying it against the MCP
before writing.

## Usage

```zsh
kiro-linear-sync   # alias, see ~/.dotfiles/.aliases
```

Run it when Linear stops responding in Kiro (token expired). If the token is
already expired in OpenCode, open OpenCode and use Linear once so it refreshes,
then run the sync again.

## Notes

- Notion in Kiro uses normal OAuth and needs no sync.
- The Kiro IDE cannot use MCP at all in this workspace: the organization
  disables MCP usage via enterprise governance.
- `~/.kiro/settings/mcp.json` stores the token and must stay private (mode 600).
