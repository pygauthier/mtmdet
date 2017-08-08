<#Version 1.0
But : Opération du des postes.
Entrée : Numéro de Poste.
Sortie : -
Createur : Francis Trudel
Date : 2017-02-25#>


# Nettoyage de la fênetre de powershell
Clear-Host

#Initiation des variables Global

# Résponse Menu
$Menu = ""



# Début du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - Récupération Clef Bitlocker"
Write-Host "2 - Migration Poste BSM --> Normal"
Write-Host ""
$Menu = Read-Host "Numero de l'option: "



# Début du case des options

Switch ($Menu){

    1{

        $NomPoste = Read-Host "Nom du Poste: "

        # Get Computer Object
        $computer = Get-ADComputer -Filter {Name -eq $NomPoste}

        # Get all BitLocker Recovery Keys for that Computer. Note the 'SearchBase' parameter
        $BitLockerObjects = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $computer.DistinguishedName -Properties 'msFVE-RecoveryPassword'

        # Output the results!
        $BitLockerObjects

        ; Break}

    2{ 
    
       $wshell = New-Object -ComObject Wscript.Shell
       $wshell.Popup("Vas dans l'AD fait le a la main pis oublie pas le groupe de sécurité TATA !",0,"Done",0x1)

       ; Break}
        }