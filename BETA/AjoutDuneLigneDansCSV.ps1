               # ajout du d'une ligne dans le fichier des répertoires: 
                $demande = Read-Host "Numéro de la demande de service: "
                $responsable = Read-Host "Nom du responsable: "
                $gestionnaire = Read-Host "Nom du gestionnaire signataire: "
                $lien = $FolderPath
                $groupem = $GroupeModif
                $groupel = $GroupeLecture
                $quota = Read-Host "Quota désiré (GO): "
                $date = Get-Date -format d
                $creator = $env:UserName

                $file = "\\mtq.min.intra\fic\QC\Service\V2\DSOC\Création de répertoires\espace_collabo.geca"
                $newRow = New-Object PsObject -Property @{ demande = $demande ; responsables = $responsable ; gestionnaire = $gestionnaire ; lien = $lien ; groupem = $groupem ; grouper = $groupel ; quota = $quota ; date = $date ; createur = $creator}


                $newRow| Export-Csv $file -Append -Encoding Unicode -Force



