# asdf configuration (Go version) - Universal
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

# New Relic terminal helpers and credentials.
# Loaded here so they are available in both interactive and non-interactive zsh shells.
[[ -f "$HOME/.config/newrelic/nerdgraph.zsh" ]] && source "$HOME/.config/newrelic/nerdgraph.zsh"
