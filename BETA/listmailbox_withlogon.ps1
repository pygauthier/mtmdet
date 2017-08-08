<#Version 1.0
But : Lister les accès sur une boîte courriel
Entrée : Code NT ou Nom affiché ou Adresse Courriel
Sortie : Liste des accès par répertoire/utilisateur/niveau
Createur : Pierre-Yves Gauthier 
Date : 2017-05-26#>


# Validation si la connection au serveur est existante.
If(-not($Session)){

# Récupération des identifiants utilisateur
$UserCredential = Get-Credential

# Ouverture de la connection 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sinfra0-exc010.mtq.min.intra/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session -AllowClobber

}


    #Entrée de la boîte courriel à lister
    $Mailbox = Read-Host "L'adresse courriel de la boîte"

    #Extraction de la boîte entière
    $mailboxfolders = @(Get-MailboxFolderStatistics $Mailbox | Where {!($exclusions -icontains $_.FolderPath)} | Select FolderPath)

    #Traitement des dossiers
    foreach ($mailboxfolder in $mailboxfolders)
    {
        #Remplacement des / par des \ pour la compatibilité avec Exchange
        $folder = $mailboxfolder.FolderPath.Replace("/","\")

        #Remplacement des noms possible pour la racine d'une boîte par \
        if ($folder -match "Partie supérieure de la banque d'informations")
        {
            $folder = $folder.Replace(“\Partie supérieure de la banque d'informations”,”\”)
        }
        elseif ($folder -match "Top of Information Store")
        {
            $folder = $folder.Replace(“\Top of Information Store”,”\”)
        }
        elseif ($folder -match "Haut de la banque d'informations")
        {
            $folder = $folder.Replace(“\Haut de la banque d'informations”,”\”)
        }
        elseif ($folder -match "Sommet de la banque d'informations")
        {
            $folder = $folder.Replace(“\Sommet de la banque d'informations”,”\”)
        }

        #Extraction du nom de dossier de la boîte
        $identity = "$($mailbox):$folder"

        #Extraction de la sécurité du répertoire en listant seulement le nom de dossier, l'utilisateur et les droits
        Get-MailboxFolderPermission $identity | Select-Object FolderName,User,AccessRights
    }