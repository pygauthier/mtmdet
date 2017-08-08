<#Version 1.0
But : Applique une note dans le champs descriptions sur une Batch User.
Entrée : description_note.csv au format "," (comma sepated) entete : Identity,note 
Createur : Pierre-Yves Gauthier
Date : 2017-04-04

Example de Data dans fichier CSV:

Identity,note 
testUser,note de description
Emplacement du csv à la base du Run Script
#>

Import-Csv -Path “description_note.csv” | 
        ForEach {Set-ADUser $_.Identity -Description $_.note
                 Get-ADUser -Identity $_.Identity -Properties Description} | Export-csv -Path "rapport.csv"