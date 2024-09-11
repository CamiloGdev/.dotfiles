# ---------- Aliases for NeoVim ----------
# Set aliases for the Neovim executable
Set-Alias vim nvim

# ---------- Other aliases ----------
# Others aliases
Set-Alias ll ls
Set-Alias grep findstr

# Utilities
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
