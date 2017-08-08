<#Version 1.0
But : Création d'un Dossier pour la porte unique
Entrée : Nom de la direction et le volume
Sortie : Dossier de la porte unique
Createur : Pierre-Yves Gauthier
Date : 2017-06-12#>

        # Création d'un Dossier Porte sur le V:\
        New-Item "V:\Porte" -type directory -Force
        $Porte = "V:\Porte"

        # Recueille les informations du dossier a creer
        $RepRoot = Read-Host "Nom du répertoire: "
        $volume = Read-Host "Numero du volume: " 
        $ville = Read-Host "QC ou MTL: "

        # Création du string du racourcie.
        $Target = "\\mtq.min.intra\fic\" + $ville + "\V" + $volume + "\Service\"

        # Création du dossier de base
        $root = $porte + "\" + $RepRoot
        New-Item $root -type directory

        # Création des path pour les répertoire Service, Espace Collabo et Application
        $repApp = $root + "\" + "Répertoires Application"
        $repService = $root + "\" + "Répertoires Service"
        $repEspace = $root + "\" + "Répertoires Espace Collaboratif"


        # Création des dossiers
        $Shell = New-Object -ComObject WScript.Shell
        New-Item $RepApp -type directory
        New-Item $repService -type directory
        New-Item $repEspace -type directory

        #Création du raccourcie vers le dossier service.
        $Shortcut = $Shell.CreateShortcut($repService + "\"+ $RepRoot +".lnk")
        $Shortcut.TargetPath = $Target
        $Shortcut.Save()