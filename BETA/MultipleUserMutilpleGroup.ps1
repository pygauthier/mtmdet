<#Version 1.0
But : Ajoute plusieur utilisateur avec plusieur groupe.
Entrée : users.csv au format "," (comma sepated) entete : user,group 
Createur : Pierre-Yves Gauthier
Date : 2017-04-12

Example de Data dans fichier CSV:

user,group
CodeNT,U-Global-G-Machin

Emplacement du csv à la base du Run Script
#>

$InGroup = “False”
[System.Convert]::ToBoolean($InGroup)

Import-Csv -Path “users.csv” | 
        ForEach {
                 try { 
                      $InGroup = “False”
                      

                       Add-ADGroupMember -Identity $_.group -Members $_.user -ErrorAction Continue
                       }
                       Catch{Write-host "$_ déjà dans le groupe"
                                          $InGroup = “True”
                                             }
                                            if($InGroup -eq "False"){ Write-host " $_ added successfully”  }
                       }
