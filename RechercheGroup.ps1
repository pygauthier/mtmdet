$arrayGroup = @()
$arrayInput = @()
$arrayItem = @()
$i = 0
$j = 0
$k = 0

do
{
    $Group = Read-Host "Entrer le nom de groupe a chercher (tapez arret pour arreter la saisie)"
    if ($Group -ne "arret")
    {
        $arrayGroup += $Group
    }
}while ($Group -ne "arret")

do
{
    $IPath = Read-Host "Entrer la racine du dossier a chercher (tapez arret pour arreter la saisie)"
    if ($IPath -ne "arret")
    {
        $arrayInput += $IPath
    }
}while ($IPath -ne "arret")

$OPath = Read-Host "Chemin de sortie (complet)"
$OPath = "$OPath\$arrayGroup.txt"
get-date > $OPath
foreach ($inpPath in $arrayInput)
{
    $pathCount = $arrayInput.Count
    $inpPath>>$OPath
    Write-Progress -Id 1 -Activity "Scan des dossiers et sous-dossiers" -CurrentOperation "$inpPath" -Status "Vérification du dossier $k sur $pathCount" -PercentComplete ($k/$pathCount*100)
    $k++
    $arrayItem = (Get-ChildItem $inpPath -Recurse -Directory).FullName
    foreach ($groups in $arrayGroup)
    {
        $groupsCount = $arrayGroup.Count
        Write-Progress -Id 2 -ParentId 1 -Activity "Recherche du groupe" -CurrentOperation "$groups" -Status "Vérification du groupe $j sur $groupsCount" -PercentComplete ($j/$groupsCount*100)
        $j++
        $groups>>$OPath
        foreach ($Items in $arrayItem)
        {
            $itemsCount = $arrayItem.Count
            Write-Progress -Id 3 -ParentId 2 -Activity "Recherche dans le dossier" -CurrentOperation "$FItem.Path" -Status "Verification du dossier $i sur $itemsCount" -PercentComplete ($i/$itemsCount*100)
            $i++
            $FItem = get-acl $Items
            if ($FItem.AccessToString -match "$groups")
            {
                $FItem.Path>>$OPath
            }
        $i = 0
        }
    $j = 0
    }
}