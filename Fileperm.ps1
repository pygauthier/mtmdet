$IPath = Read-Host "Chemin de recherche (complet)"
$OPath = Read-Host "Fichier de sortie (chemin complet)"
$OPath = "$OPath.txt"
$arrayItem = @()
$arrayItem = (Get-ChildItem $IPath -Recurse).FullName
Echo "Chemin complet;Propriétaire;Ensemble;Accès">$OPath
foreach ($Items in $arrayItem)
{
    $itemRights = (get-acl $Items).AccessToString
    $itemPath = (get-acl $Items).path
    $itemOwner = (get-acl $Items).Owner
    $itemGroup = (get-acl $Items).group
    $itemRightsOutput = $itemRights -replace "`n", ";"
    "$itemPath;$itemOwner;$itemGroup;$itemRightsOutput" | Out-File $OPath -Append
}