<#Version 1.0
But : ajouté l'utilisateur dans son groupe D-MTQ000-G-Intranet_MonUnite-****
Entrée : Code NT de L'utilisateur
Sortie : -
Createur : Francis Trudel
Date : 2017-08-01#>



#Entrer le code NT de l'utilisateur
$user1 = read-Host "Code NT de L'utilisateur"

#Cherche extensionAttribute2 de l'utilisateur
$EA2 = (get-aduser $user1 -Properties *).extensionAttribute2

#Trouve le groupe D-MTQ000-G-Intranet_MonUnite-**** de l'utilisateur
$groupe = "D-MTQ000-G-Intranet_MonUnite-"+$EA2

#Ajoute l'utilisateur dans son groupe D-MTQ000-G-Intranet_MonUnite-****
try {Add-ADGroupMember $groupe -members $user1}
catch {Write-Host "Un erreur est survenue avec l'ajout du groupe $groupe"-BackgroundColor Red -ForegroundColor Black}
Write-Host "L'utilisateur a été ajouté dans le groupe " $groupe -BackgroundColor Green -ForegroundColor Black