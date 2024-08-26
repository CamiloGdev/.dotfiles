oh-my-posh init pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/camilodev.omp.json" | Invoke-Expression
Import-Module Catppuccin
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionViewStyle ListView
