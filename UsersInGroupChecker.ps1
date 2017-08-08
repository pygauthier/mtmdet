#Sélection du fichier + importation
foreach ( $user in (Get-Content .\users.csv ))

{

$u = (Get-ADUser -Identity $user).distinguishedName

$group = "U-GLOBAL-G-EC-QC-SSC-CMI-Archives_Petit_Renard-M"

#Vérification du groupe
$g = Get-ADGroupMember -Identity $group| select -ExpandProperty distinguishedname

#Loop de vérification si les utilisateurs sont dans le groupe demandé.
If ($g -contains $u ) {

    #écrire le code nt du user avec ;
    Write-Host "$user;"

}

#Si l'utilisateur n'est pas dans le groupe.
Else {

   Add-ADGroupMember $group -Members $user

   Write-host " $user added to group successfully”
    
   

  } }