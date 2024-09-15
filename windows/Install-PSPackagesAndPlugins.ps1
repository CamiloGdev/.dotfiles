Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion de los programas: curl, sudo y jp" -ForegroundColor Cyan
scoop install curl
scoop install sudo
scoop install jp
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del programa: fzf" -ForegroundColor Cyan
scoop install fzf
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del plugin: PSFzf" -ForegroundColor Cyan
Install-Module -Name PSFzf -Scope CurrentUser -Force
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del plugin: z" -ForegroundColor Cyan
Install-Module -Name z -Force
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del plugin: Terminal-Icons" -ForegroundColor Cyan
Install-Module -Name Terminal-Icons -Repository PSGallery
Write-Host "==================================================" -ForegroundColor Cyan
