# Author: Camilo Galeano (camilodev)
# Description: This is the profile for PowerShell 7.0.0 and later versions.

# Initialize oh-my-posh with the camilodev theme from the POSH_THEMES_PATH environment variable
oh-my-posh init pwsh --config "~\AppData\Local\nvim\otherConfigs\Oh_My_Posh\camilodev.omp.json" | Invoke-Expression

# Import the Terminal-Icons module for enhanced terminal icons
Import-Module Terminal-Icons

# Set the PSReadLine prediction view style to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# Set aliases for the Neovim executable
Set-Alias vim nvim
