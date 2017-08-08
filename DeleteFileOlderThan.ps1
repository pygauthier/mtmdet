clear-host
# Calcul de la date Limite
write-host "Calcul de la date Limite"
$limit = (Get-Date).AddDays(-3)
Write-host ""
Write-host "================================"
Write-host ""


# Assignation du dossier cible
write-host "Assignation du dossier cible"
$path = "C:\Users\pygauthier\Desktop\courriel"


Write-host ""
Write-host "================================"
Write-host ""


# Efface les fichiers plus vieux que $limit.
Write-host "Efface les fichiers plus vieux que" $limit
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

Write-host ""
Write-host "================================"
Write-host ""


Write-host "Efface les dossier vide."
# Efface les dossier vide.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

Write-host ""
Write-host "================================"
Write-host ""
Write-Host " Traitement terminé"
Write-host ""
Write-host "================================"
Write-host ""