# asdf configuration (Go version) - Universal
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

# asdf locations for tools that resolve versions themselves (notably the
# Mason elixir-ls launcher used by Neovim's ElixirLS: without these it
# picks the wrong Elixir and project deps fail to load).
export ASDF_DIR="/opt/homebrew/opt/asdf"
export ASDF_DATA_DIR="$HOME/.asdf"

# New Relic MCP credentials for processes started from any zsh shell.
[[ -f "$HOME/.config/newrelic/nerdgraph.env" ]] && source "$HOME/.config/newrelic/nerdgraph.env"
