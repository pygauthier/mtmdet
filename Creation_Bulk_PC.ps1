$nbPoste = Read-Host "Nombre de postes à créer"
Do {
    $typePoste = Read-Host "Type de postes à créer (L)Portable, (P)Poste de table, (T)Tablette ou (W)Workstation"
}
Until ($typePoste -eq "L" -or $typePoste -eq "P" -or $typePoste -eq "T" -or $typePoste -eq "W")
$debutPoste = Read-Host "Numéro du poste de départ (exemple 4022 pour MMTQ000-004022)"
$i = 0
switch ($typePoste)
{
    L {$nomPoste = "PMTQ000-00"}
    P {$nomPoste = "MMTQ000-00"}
    T {$nomPoste = "TMTQ000-000"}
    W {$nomPoste = "WMTQ000-000"}
    

}

While ($i -lt $nbPoste)
{
    $nbFin = [int]$debutPoste + [int]$i
    $nomPosteFin = "$nomPoste" + $nbFin
    New-ADComputer -name $nomPosteFin -Description "1545301;STMU, DTI;STMUDTI;Interne;Hors Réseau;Réceptionné-Disponible;N/A;700 R-L QC" -path "OU=_Hors réseau,OU=_Postes,OU=DGTI,OU=SMSG,DC=MTQ,DC=MIN,DC=INTRA" -confirm:$false
    $i++
}