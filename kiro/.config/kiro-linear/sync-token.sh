#!/usr/bin/env zsh
#
# Sync the Linear MCP access token from OpenCode into Kiro CLI's MCP config.
#
# Why: Kiro CLI 2.27.0 fails the Linear MCP OAuth token exchange with a false
# "Authorization server response missing required issuer" error (see
# https://github.com/kirodotdev/Kiro/issues/11758). OpenCode completes the same
# OAuth flow and refreshes the token, so we reuse its token as a Bearer header.
#
# Run it whenever Kiro's Linear MCP stops working (token expired). Kiro
# hot-reloads ~/.kiro/settings/mcp.json on save.
#
set -eu

OPENCODE_AUTH="$HOME/.local/share/opencode/mcp-auth.json"
KIRO_MCP="$HOME/.kiro/settings/mcp.json"
LINEAR_URL="https://mcp.linear.app/mcp"

[[ -f "$OPENCODE_AUTH" ]] || { print -u2 "OpenCode auth store not found: $OPENCODE_AUTH"; exit 1; }
[[ -f "$KIRO_MCP" ]] || { print -u2 "Kiro MCP config not found: $KIRO_MCP"; exit 1; }

TOKEN=$(python3 - "$OPENCODE_AUTH" <<'PY'
import json, sys
data = json.load(open(sys.argv[1]))
entry = data.get("linear") or {}
token = (entry.get("tokens") or {}).get("accessToken")
if not token:
    raise SystemExit("No Linear access token in OpenCode store; authenticate Linear in OpenCode first.")
print(token)
PY
)

# Probe the token before writing it.
code=$(curl -sS -o /dev/null -w "%{http_code}" -X POST "$LINEAR_URL" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "MCP-Protocol-Version: 2025-06-18" \
  --data-binary '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"token-sync","version":"1.0"}}}')

if [[ "$code" != "200" ]]; then
  print -u2 "Linear token probe failed (HTTP $code)."
  print -u2 "Open OpenCode, use Linear once so it refreshes the token, then run this again."
  exit 1
fi

python3 - "$KIRO_MCP" "$TOKEN" "$LINEAR_URL" <<'PY'
import json, os, sys
path, token, url = sys.argv[1], sys.argv[2], sys.argv[3]
cfg = json.load(open(path))
servers = cfg.setdefault("mcpServers", {})
linear = servers.setdefault("linear", {})
linear["url"] = url
linear.pop("oauth", None)
linear.pop("oauthScopes", None)
linear.pop("disabled", None)
linear["headers"] = {"Authorization": "Bearer " + token}
json.dump(cfg, open(path, "w"), indent=2)
os.chmod(path, 0o600)
print("OK: Linear token synced to", path)
PY

print "Done. Kiro reloads the config automatically; restart the session if it does not."
