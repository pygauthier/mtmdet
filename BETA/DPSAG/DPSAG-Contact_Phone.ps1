<#Version 1.0
But : Set le téléphone avec un CSV pour une Batch User.
Entrée : phonecontact.csv au format "," (comma sepated) entete : Identity,OfficePhone 
Createur : Pierre-Yves Gauthier
Date : 2017-04-04

Example de Data dans fichier CSV:

Identity,OfficePhone 
testUser,1 418 555-5555

Emplacement du csv à la base du Run Script
#>

Import-Csv -Path “phonecontact.csv” | 
        ForEach {Set-ADUser -Identity $_.Identity -OfficePhone $_.OfficePhone
                 Get-ADUser -Identity $_.Identity | fl sAMAccountName,OfficePhone}