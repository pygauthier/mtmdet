<#Version 1.0
But : Modifier l'attribut carLicence des comptes de service, test et générique
Entrée : code NT des comptes
Sortie : carLicense
Createur : Francis Trudel
Date : 2017-07-31

Liste des versions:
1.0 création
#>


# Nettoyage de la fênetre de powershell
Clear-Host

#Code NT du compte a modifier
$User = ""

# Début du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - Compte de Service et de test"
Write-Host "2 - Compte Générique"
Write-Host "3 - Valider l'attribut carLicense d'un compte"
Write-Host ""

$Menu = read-Host "Numéros de l'option"

Switch ($Menu){
    1 {
		#Entrée Code NT du compte a modifier
		$user = read-Host "Nom d'utilisateur"
		SET-ADUSER $User -add @{carLicense="CS"}
        Write-Host "L’attribut CarLicense a été modifié pour" (get-aduser $user -Properties *).carLicense

      ; Break}


    2 { 
		#Entrée Code NT du compte a modifier
		$user = read-Host "Nom d'utilisateur"
		SET-ADUSER $User -add @{carLicense="CG"}
        Write-Host "L’attribut CarLicense a été modifié pour" (get-aduser $user -Properties *).carLicense
	
	 ; Break}


    3 { 
		#Entrée Code NT du compte a valider
		$user = read-Host "Nom d'utilisateur"
		Write-Host "L’attribut CarLicense est" (get-aduser $user -Properties *).carLicense
	
	 ; Break}

			}