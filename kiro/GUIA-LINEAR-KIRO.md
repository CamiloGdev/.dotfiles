# Linear MCP en Kiro: workaround por token (paso a paso)

## El problema

Kiro CLI **no puede completar el OAuth del MCP de Linear**. El flujo falla en el
intercambio de token con un error falso:

```
Authorization server response missing required issuer: expected https://mcp.linear.app
```

Es un bug de Kiro CLI (reportado en
[kirodotdev/Kiro#11758](https://github.com/kirodotdev/Kiro/issues/11758)), no de
Linear ni de la red. La autorización sí se completa en el navegador, pero Kiro no
guarda el token.

**La solución:** OpenCode sí completa ese OAuth. Usamos OpenCode para obtener el
token de Linear y se lo pasamos a Kiro como header `Authorization: Bearer`.
Un script (`kiro-linear-sync`) copia el token vigente de OpenCode a la config de
Kiro y lo renueva cuando caduca.

## Qué MCP usamos

| Servidor | URL | Auth en OpenCode | Auth en Kiro |
|---|---|---|---|
| Linear | `https://mcp.linear.app/mcp` | OAuth (funciona) | Bearer token (workaround) |
| Notion | `https://mcp.notion.com/mcp` | OAuth | OAuth (funciona) |
| New Relic PDN | `https://mcp.newrelic.com/mcp/` | API key | API key |
| New Relic QA | `https://mcp.newrelic.com/mcp/` | API key | API key |

Esta guía cubre **Linear** (el problema). Notion y New Relic son opcionales (al final).

---

## Parte 1 — OpenCode: instalar y autenticar Linear (aquí el OAuth SÍ funciona)

### 1.1 Requisitos
- OpenCode instalado.
- `python3` y `curl` disponibles (vienen en macOS).

### 1.2 Añadir el MCP de Linear
Edita tu config de OpenCode (global): `~/.config/opencode/opencode.jsonc`
y **fusiona** esta entrada dentro del objeto `mcp` existente:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "linear": {
      "type": "remote",
      "url": "https://mcp.linear.app/mcp",
      "enabled": true
    }
  }
}
```

> Nota: la sintaxis corresponde a OpenCode 1.18.30. Si usas la v2, el bloque va
> bajo `mcp.servers`.

### 1.3 Autenticar
```bash
opencode mcp auth linear
```
Se abre el navegador: elige el workspace de Linear y autoriza.

### 1.4 Verificar
```bash
opencode mcp list
opencode mcp auth list
```
Debe aparecer `linear connected` y `linear authenticated`.

Esto guarda el token en `~/.local/share/opencode/mcp-auth.json`. El script lo leerá
desde ahí.

---

## Parte 2 — Kiro: usar el token de OpenCode

### 2.1 Crear el script de sincronización
Crea la carpeta y el archivo `~/.config/kiro-linear/sync-token.sh` con este contenido:

```zsh
#!/usr/bin/env zsh
#
# Sync the Linear MCP access token from OpenCode into Kiro CLI's MCP config.
# Kiro CLI cannot complete Linear's MCP OAuth (Kiro bug #11758), so we reuse
# the token OpenCode already holds (and keeps refreshed).
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
```

```bash
chmod +x ~/.config/kiro-linear/sync-token.sh
```

### 2.2 Preparar la config de Kiro
Kiro lee `~/.kiro/settings/mcp.json`. Créalo (o fusiónalo) así:

```bash
mkdir -p ~/.kiro/settings
cat > ~/.kiro/settings/mcp.json <<'JSON'
{
  "mcpServers": {
    "linear": { "url": "https://mcp.linear.app/mcp" }
  }
}
JSON
chmod 600 ~/.kiro/settings/mcp.json
```

### 2.3 Ejecutar el sync
```bash
~/.config/kiro-linear/sync-token.sh
```
Debe imprimir `OK: Linear token synced to ...`. Eso escribe el header
`Authorization: Bearer <token>` en `~/.kiro/settings/mcp.json`.

### 2.4 Verificar en Kiro
```bash
kiro-cli chat
```
Dentro, ejecuta:
```
/mcp
```
Debe aparecer `linear ● running` con sus herramientas.

### 2.5 Alias (opcional, recomendado)
En tu `~/.aliases` (o `.zshrc`):
```bash
alias kiro-linear-sync="~/.config/kiro-linear/sync-token.sh"
```

---

## Parte 3 — Cuando el token caduca

El token de Linear tiene vida corta. Cuando Linear deje de responder en Kiro
(error de auth o `linear ✗ failed` en `/mcp`), corre de nuevo:

```bash
kiro-linear-sync
```

El script:
1. Toma el token actual de OpenCode.
2. Lo **verifica** contra el MCP (debe dar HTTP 200).
3. Si es válido, lo escribe en Kiro (Kiro recarga el archivo solo).

**Si el script dice `Linear token probe failed`**: significa que el token de
OpenCode también caducó. Abre OpenCode, usa Linear una vez (por ejemplo pídele un
ticket) para que lo refresque, y vuelve a correr `kiro-linear-sync`.

No se ejecuta solo: hay que correrlo cuando haga falta. (Se puede automatizar con
un cron/launchd si se quiere.)

---

## Parte 4 (opcional) — Notion y New Relic en Kiro

Notion usa OAuth normal y **sí funciona** en Kiro (no necesita token):

```json
"notion": { "url": "https://mcp.notion.com/mcp" }
```

New Relic usa API keys por header (variables de entorno):

```json
"newrelic_pdn": {
  "url": "https://mcp.newrelic.com/mcp/",
  "headers": {
    "api-key": "${NEW_RELIC_API_KEY}",
    "include-tags": "discovery,data-access,performance-analytics"
  }
},
"newrelic_qa": {
  "url": "https://mcp.newrelic.com/mcp/",
  "headers": {
    "api-key": "${NEW_RELIC_API_KEY_QA}",
    "include-tags": "discovery,data-access,performance-analytics"
  }
}
```

Las variables deben estar exportadas antes de lanzar kiro-cli (por ejemplo desde
`~/.config/newrelic/nerdgraph.env` vía `~/.zshenv`).

---

## Notas importantes

- **El IDE de Kiro no sirve** en este workspace: la organización deshabilita el uso
  de MCP por gobernanza (`MCP usage has been disabled by your organization`).
  Solo funciona el **CLI**.
- `~/.kiro/settings/mcp.json` contiene el token → **no lo compartas ni lo subas** a
  git. Debe quedar en modo `600`.
- No se puede "forzar" el OAuth de Kiro: su `code_verifier` es interno. Por eso el
  workaround es el token.
- Referencia del bug: https://github.com/kirodotdev/Kiro/issues/11758

## Archivos creados (resumen)

| Archivo | Para qué |
|---|---|
| `~/.config/opencode/opencode.jsonc` (entrada `linear`) | OpenCode autentica Linear por OAuth |
| `~/.config/kiro-linear/sync-token.sh` | Copia/renueva el token de OpenCode → Kiro |
| `~/.kiro/settings/mcp.json` | Config MCP de Kiro (contiene el token, privado) |
| `~/.aliases` (alias `kiro-linear-sync`) | Atajo para correr el script |
