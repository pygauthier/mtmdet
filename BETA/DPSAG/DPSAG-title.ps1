<#Version 1.0
But : Appliqué une date de fin pour une Batch User.
Entrée : title.csv au format "," (comma sepated) entete : Identity,title
Createur : Pierre-Yves Gauthier
Date : 2017-04-04

Example de Data dans fichier CSV:

Identity,date 
codeNT,title

Emplacement du csv à la base du Run Script
#>

Import-Csv -Path “title.csv” | 
        ForEach { Set-ADUser $_.codeNT -Title $_.title 
                  Get-ADUser $_.codeNT | Select SamAccountName, Title    }