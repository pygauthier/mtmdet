#Sélection du fichier + importation
foreach ( $user in (Get-Content .\users.csv ))

{

$u = (Get-ADUser -Identity $user).SamAccountName

$group = "U-GLOBAL-G-GUI-GPO-PORTE_UNIQUE_UNIFIEE"

#Vérification du groupe
$g = Get-ADGroupMember -Identity $group| select -ExpandProperty SamAccountName

#Loop de vérification si les utilisateurs sont dans le groupe demandé.
If ($g -contains $u ) {

    #écrire le code nt du user avec ;
    Remove-ADGroupMember $group -Members $user -Confirm:$false

   Write-host " $user remove to group successfully”

}

#Si l'utilisateur n'est pas dans le groupe.
Else {

   Add-ADGroupMember $group -Members $user

   Write-host " $user Noting to do”
    
   

  } }