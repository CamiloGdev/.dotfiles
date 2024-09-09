# Author: Camilo Galeano (camilodev)
# Description: This is the profile for PowerShell 7.0.0 and later versions.

# Initializes oh-my-posh with themes from the theme library that are defined in the POSH_THEMES_PATH environment variable.
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/star.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/emodipt-extend.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/pure.omp.json" | Invoke-Expression

# Import the Terminal-Icons module for enhanced terminal icons
Import-Module Terminal-Icons

# Set the PSReadLine prediction view style to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# Set the PSReadLine prediction view style to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# Set configuration for fzf, activation and shortcuts
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Set aliases for the Neovim executable
Set-Alias vim nvim

# Others aliases
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr

# Utilities
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
