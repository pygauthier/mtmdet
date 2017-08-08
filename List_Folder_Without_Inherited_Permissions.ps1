<#Version 1.0
But : Liste les dossiers dont leur héritage est desactivé.
Entrée : Path initial
Sortie : Path des répertoires avec l'héritage coupé
Createur : Gabriel Pelletier
Date : 2016-10-24#>

#Entrée du Path
$fullpath = Read-Host "Path complet a lister"

#Liste des dossiers
$list = ls "$fullpath" -Recurse -Directory

foreach ($folder in $list)
{
    #Extraction de la sécurtié de chacun de répertoires
    $pathACL = Get-ACL $folder.fullname | Select -ExpandProperty Access

    #Sortie du path si l'héritage est coupé
    if ($pathACL.IsInherited -eq $false)
    {
        Write-Host $folder.fullname
    }
}