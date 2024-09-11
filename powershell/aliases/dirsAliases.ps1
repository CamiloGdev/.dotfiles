
# Dir aliases
function Get-JumpBack {
    Set-Location ..
}
Set-Alias .. Get-JumpBack

function Get-JumpDobleBack {
    Set-Location ../..
}
Set-Alias ... Get-JumpDobleBack

function Get-JumpTripleBack {
    Set-Location ../../..
}
Set-Alias .... Get-JumpTripleBack

function Get-JumpCuadrupleBack {
    Set-Location ../../../..
}
Set-Alias ..... Get-JumpCuadrupleBack

function Get-JumpQuintupleBack {
    Set-Location ../../../../..
}
Set-Alias ...... Get-JumpQuintupleBack

# Jumps
function Get-JumpHome {
    Set-Location $env:USERPROFILE
}
Set-Alias ~ Get-JumpHome


function Get-JumpTmpDownloads {
    Set-Location "$env:USERPROFILE\Downloads\tmp"
}
Set-Alias tmp Get-JumpTmpDownloads

$dotfilesIndex = $PSScriptRoot.IndexOf('.dotfiles')
$dotfilesPath = $PSScriptRoot.Substring(0, $dotfilesIndex + 9)  # +9 para incluir la longitud de ".dotfiles"
function Get-JumpDotfiles {
    Set-Location $dotfilesPath
}
Set-Alias dotfiles Get-JumpDotfiles

# function Get-JumpRepositories {
#     Set-Location "$env:USERPROFILE\Documents\CamiloGaleano\others\repositories"
# }
# Set-Alias cdc Get-JumpRepositories

# function Get-JumpWorkRepositories {
#     Set-Location "$env:USERPROFILE\Documents\CamiloGaleano\nova\repositories"
# }
# Set-Alias cdw Get-JumpWorkRepositories
