<#
Version 1.0
But : Liste la sécurité et ajoute l'utilisateur dans le groupe
Entrée : Path du dossier et le code nt de l'utilisateur
Sortie : -
Createur : Pierre-Yves Gauthier
Date : 2017-06-20
#>


# Initionation des varribles.
$fullpath = ""
$SecurityGroup = ""
$User = ""
$g = ""

Try{

#Entrée du Path
$fullpath = Read-Host "Path complet a lister"

#Extraction de la sécurtié du répertoire
(get-acl "$fullpath").access | Select IdentityReference

Write-Host "`n`n`n"
# Récupération du nom du groupe
$SecurityGroup = Read-Host "Nom du groupe à ajouté"

Write-Host "`n`n"
$User = Read-Host "CodeNT de l'utilisateur"

$g =  Get-ADGroupMember -Identity $SecurityGroup| select -ExpandProperty sAMAccountName
#Loop de vérification si l'utilisateurs est dans le groupe demandé.
If ($g -contains $User ) {

        #écrire le code nt du user avec ;
        Write-Host "`n`n"
        Write-Host "L'utilisateur $user est déjà dans le groupe."

    }

#Si l'utilisateur n'est pas dans le groupe.
    Else {


    #Ajout de l'utilisateur dans le groupe.
    Add-ADGroupMember $SecurityGroup -Members $user


    # Validation que l'opération a réussi
    $g =  Get-ADGroupMember -Identity $SecurityGroup| select -ExpandProperty sAMAccountName

    #Loop de vérification si l'utilisateurs à été ajouté groupe demandé.
        If ($g -contains $User ) {

            #écrire le code nt du user avec ;
            Write-Host "`n`n"
            Write-Host "L'utilisateur $user a été ajouté avec succès."

        }

        #Si l'utilisateur n'est pas dans le groupe.
        Else {

           Write-host " Une erreur est survenue pour ajouter $user dans $SecurityGroup”
    
   

          }
     }

 }
 
 # Gestion des erreurs
 Catch { 
          $ErrorMessage = $_.Exception.Message
          Write-Host "Une erreur est survenue validé vos données" -BackgroundColor Red -ForegroundColor Gray
        }

           