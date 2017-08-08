<#Version 1.0
But : Appliqué une date de fin pour une Batch User.
Entrée : endDate.csv au format "," (comma sepated) entete : Identity,date
Createur : Pierre-Yves Gauthier
Date : 2017-04-04

Example de Data dans fichier CSV:

Identity,date 
codeNT,date_de_fin(mm/jj/annee)

Emplacement du csv à la base du Run Script
#>

Import-Csv -Path “endDate.csv” | 
        ForEach {Set-ADUser -Identity $_.Identity -AccountExpirationDate $([datetime]$_.date)
                 Get-ADUser -Identity $_.Identity -Properties AccountExpirationDate}