
# Importation du fichier
$import = get-content -Path "getmailbox.txt"

# Declaration du pourcentage
$Percent=1

# Comptage des éléments pour la barre de pourcentage
$total = $import.Count

# Déclaration du Array pour l'affichage Final
$Tab = @()
    
    # Loop pour "Chaque utilisateur"
    foreach($codeNT in $import){
    

    #Création de la barre de pourcentage
    $currentPercent = $percent/$total*100
    Write-Progress -activity "Processing du compte $codeNT" -PercentComplete "$currentPercent" -CurrentOperation "$codeNT en cours de Traitement"


       # Liste le nombre de dossier présent
       $folderCount = (Get-MailboxFolderStatistics $codeNT).count
       
       # Récupération du nom complet de la personne
       $nomComplet =  (Get-ADUser $codeNT).name
       
        # Jusqua ce que i sois égle au nombre de dossier
        for($i= 0; $i -lt $folderCount; $i++){

            #On récupère le nom du dossier en court (i)
            $folderName =  (Get-MailboxFolderStatistics $codeNT).name[$i]

            #On récupère le nombre d'objet dans le dossier $folderName
            $folderItems = (Get-MailboxFolderStatistics $codeNT).ItemsInFolder[$i]
            

            # Déclaration d'un nouvelle objet
            $ObjTab = New-Object PSCustomObject

            # Ajout de variable dans nos objet
            $ObjTab | Add-Member -Type NoteProperty -name NomComplet -Value $nomComplet

            $ObjTab | Add-Member -Type NoteProperty -name sAMAccountName -Value $codeNT

            $ObjTab | Add-Member -Type NoteProperty -name FolderName -Value $folderName

            $ObjTab | Add-Member -Type NoteProperty -name folderCount -Value $folderItems
            
            # Ajout de notre objet dans l'array Table
            $Tab += $ObjTab

            $ObjTab
            # On vide l'objet
            remove-variable ObjTab

            
        }
        
            $ObjTab = New-Object PSCustomObject

            # Ajout de variable dans nos objet
            $ObjTab | Add-Member -Type NoteProperty -name NomComplet -Value "N/A"

            
            # Ajout de notre objet dans l'array Table
            $Tab += $ObjTab

            # On vide l'objet
            remove-variable ObjTab


     #Incrémentation de la barre de pourcentage
     $Percent++
    }

    # Exportation de l'objet dans un csv
    $Tab | Export-Csv "exportTabObj.csv" -Encoding Unicode