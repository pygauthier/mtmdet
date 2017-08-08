<#Version 1.0
But : Création en lot de mailContact importé d'un fichier CSV.
Entrée : mailcontact.csv au format "," (comma sepated) entete : Name,Firstname,LastName,ExternalEmailAddress
Createur : Pierre-Yves Gauthier
Date : 2017-03-25

Example de Data dans fichier CSV:

 Name,Firstname,LastName,ExternalEmailAddress
 CompteTest,Test,Compte,comptetest@test.com

Emplacement du csv à la base du Run Script
#>


Import-Csv -Path “mailcontact.csv” | 
        ForEach {New-MailContact -Name $_.Name -Firstname $_.FirstName -LastName $_.LastName -ExternalEmailAddress $_.ExternalEmailAddress -OrganizationalUnit “mtq.min.intra/DPSAG”}