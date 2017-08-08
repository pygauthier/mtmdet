<#
Nom du script : Modification du statut d'un compte

Description : Script de désactivation d'un compte avec les normes visés par le ménage de l'AD.

Date de création : 2017-07-13
Date de mise à jour : 2017-08-01
Information de la MAJ : Ajout du numéro de demande de service dans le champs "Description"

Version : 1.5

Script écrit par : Eric Nadeau (enadeau)
#>

Import-Module ActiveDirectory

Clear-Host

# Question pour savoir le compte est visé dans l'opération

$Utilisateur = Read-Host "Quel est le compte sur lequel vous voulez travailler"

# Question pour savoir quel est le numéro de demande de modification du compte

$DemandeService = Read-Host "Quel est le numéro de la demande de service"

# Est-ce une suspension temporaire ou un départ

Write-Host "Veuillez choisir une des options suivantes"
Write-Host ""
Write-Host "1 - Suspension temporaire d'un compte"
Write-Host "2 - Désactivation complète d'un compte"
Write-Host ""
Write-Host "R - Réactivation d'un compte"
Write-Host "X - Sortir du script"
Write-Host ""
$Menu = Read-Host "Numéro de l'option"

# Préparation des variables d'opération

$AujourdHui = Get-Date -format "yyyyMMdd"
$User = Get-ADUser $Utilisateur -Properties *

# Préparation du champ "description"

$Description = @()
$Description = ($User.Description).Split(";")

if ($Description -like $null ) {
    $CreationDate = Get-Date ([DateTime] $User.Created) -Format "yyyyMMdd"
    $Creation = "C"+$CreationDate+";;"
    Set-ADUser $User -Description $Creation
    $User = Get-ADUser $Utilisateur -Properties *
}

if ($Description.count -eq 1)
{
$DescTemp = "","",$Description[0]
}

# Exécution des manipulations sur le comptes

Switch ($Menu) {
    1 { # Suspension temporaire

    # Ajustement du champ Description de l'utilisateur

    $DescTemp[0] = "S"+$AujourdHui
    $DescTemp[1] = $DemandeService.ToUpper()
    $DescFinal = $DescTemp -join (";")

    $User | Disable-ADAccount
    Set-ADUser $User -Description $DescFinal
    Write-Host "Le compte a été suspendu. Une demande devra être fait pour la réactivation"
    Break
    
    } # Fin de l'option 1 - Suspension temporaire

    2 { # Désactivation définitive

    # Ajustement du champ Description de l'utilisateur

    $DescTemp[0] = "D"+$AujourdHui
    $DescTemp[1] = $DemandeService.ToUpper()
    $DescFinal = $DescTemp -join (";")

    $User | Disable-ADAccount
    Set-ADUser $User -Description $DescFinal
    $User | Move-ADObject -TargetPath "OU=_Comptes Inactifs,OU=_Utilisateurs,OU=GLOBAL,DC=MTQ,DC=MIN,DC=INTRA"
    Write-Host "Le compte a été désactivé et déplacé dans l'OU en conséquence."
    Break
    
    } # Fin de l'option 2 - Désactivation définitive

    R { # Réactivation

   # Ajustement du champ Description de l'utilisateur

    $DescTemp[0] = "R"+$AujourdHui
    $DescTemp[1] = $DemandeService.ToUpper()
    $DescFinal = $DescTemp -join (";")

    $User | Enable-ADAccount
    Set-ADUser $User -Description $DescFinal
    Write-Host "Le compte a été réactivé."
    Break
    
    } # Fin de l'option R - Réactivation

    X { # Sortir

    Break
    
    } # Fin de l'option X - Sortir

} # Fin du switch

Write-Host "Bonne fin de journée!"
# Clear-Host