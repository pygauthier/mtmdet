4<#Version 1.3
But : Gestion des Courriel.
Entrée : Nom de la boîte courriel, Nom de l'utilisateur
Createur : Pierre-Yves Gauthier
Date : 2017-03-09

Liste des versions:
1.0 création
1.1 Ajout option 8 Gestion des redirection courriel de la DPSAG. - 2017-06-22
1.2 Ajout du Try Catch pour une meilleur gestion des erreurs
1.3 Remise en fonction de l'option 6 - 2017-08-03
1.4 Ajout option 9 Création boite commune - 2017-08-04
#>

# Information pour la gestion des erreurs
$script = "01 - GestionCourriel"
$version = "1.2"

# Nettoyage de la fênetre de powershell
Clear-Host

#Initiation des variables Global

#Adresse courriel de la boîte
$Mailbox = ""
#Choix de l'opération à faire tant que le choix n'est pas valide
$Operation = ""
#Nom d'utilisateur a donner les accès
$User = ""
# Type de boite vers laquel convertir
$Type = ""
# Résponse Menu
$Menu = ""


# Début du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - Donne les accès au calendrier"
Write-Host "2 - Donne les accès au Éléments Supprimés"
Write-Host "3 - Liste les accès sur la boîte entière"
Write-Host "4 - Donne les accès sur une boîte au complet"
Write-Host "5 - Donne les accès sur une ou plusieurs boite et Users"
Write-Host "6 - Donne les accès d'envoyé de la part de"
Write-Host "7 - Convertir une boîte"
Write-Host "8 - Gestion Courriel DPSAG"
Write-Host "9 - Création d'une boite commune"
Write-Host ""
$Menu = Read-Host "Numéro de l'option: "


# Début du case des options

Switch ($Menu){
    1 { Try{

        #Choix de l'opération à faire tant que le choix n'est pas valide
                Do {
        $Operation = Read-Host "Quel opération voulez-vous faire ((A)jout / (M)odification / (S)upression)"
            }
            Until ($Operation -eq "A" -or $Operation -eq "M" -or $Operation -eq "S")

            #Adresse courriel de la boîte du calendrier
            $Mailbox = Read-Host "L'adresse courriel de la boite"

            #Nom d'utilisateur a donner les accès
            $User = Read-Host "Le code NT de l'utilisateur"

            #Si ce n'est pas une supression, le rôle a donner
            if ($Operation -ne "S")
                {
        $Rights = Read-Host "Le nom du role des droits d'acces (Owner, PublishingEditor, Editor, Author, Reviewer)"
            }

            #Chemin du calendrier dans la boîte
            $identity = "$($mailbox):\Calendrier"

            #Traitement
            Write-Host "Verification de $identity pour les permissions pour l'utilisateur $User"
	            try
	                                                                                                                                                                                    {
        #Traitement dépendament de l'opération choisie au début
		Switch ($Operation)
		{
			A{Add-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
			Write-Host -ForegroundColor Green "Permission ajoutee!"
			}
			M{Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
			Write-Host -ForegroundColor Green "Permission modifiee!"
			}
			S{Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
			Write-Host -ForegroundColor Green "Permission retiree!"
			}
		}
	}
                #Affichage de l'erreur, si présente
	            catch
	                                    {
		Write-Warning $_.Exception.Message
	}

           -ErrorAction Stop

} Catch [Exception] {
    
    echo $_.Exception.GetType().FullName, $_.Exception.Message
    senderror

    }

      ; Break}

    2 { 
    #Choix de l'opération à faire tant que le choix n'est pas valide
Do {
$Operation = Read-Host "Quel opération voulez-vous faire ((A)jout / (M)odification / (S)upression)"
}
Until ($Operation -eq "A" -or $Operation -eq "M" -or $Operation -eq "S")

#Adresse courriel de la boîte du calendrier
$Mailbox = Read-Host "L'adresse courriel de la boite"

#Nom d'utilisateur a donner les accès
$User = Read-Host "Le code NT de l'utilisateur"

#Si ce n'est pas une supression, le rôle a donner
if ($Operation -ne "S")
{
$Rights = Read-Host "Le nom du role des droits d'acces (Owner, PublishingEditor, Editor, Author, Reviewer)"
}

#Chemin du calendrier dans la boîte
$identity = "$($mailbox):\Eléments supprimés"

#Traitement
Write-Host "Verification de $identity pour les permissions pour l'utilisateur $User"
	try
	{
        #Traitement dépendament de l'opération choisie au début
		Switch ($Operation)
		{
			A{Add-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
			Write-Host -ForegroundColor Green "Permission ajoutee!"
			}
			M{Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
			Write-Host -ForegroundColor Green "Permission modifiee!"
			}
			S{Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
			Write-Host -ForegroundColor Green "Permission retiree!"
			}
		}
	}
    #Affichage de l'erreur, si présente
	catch
	{
		Write-Warning $_.Exception.Message
	} ; Break}

    3 { 
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
}    ; Break} 

    4 {
        #Choix de l'opération à faire (tant que le choix n'est pas valide)
Do {
$Operation = Read-Host "Quel opération voulez-vous faire ((A)jout / (M)odification / (S)upression)"
}
Until ($Operation -eq "A" -or $Operation -eq "M" -or $Operation -eq "S")

#Adresse courriel de la boîte
$Mailbox = Read-Host "L'adresse courriel de la boîte"

#Nom d'utilisateur a donner les accès
$User = Read-Host "Le code NT de l'utilisateur"

#Si ce n'est pas une supression, le rôle a donner
if ($Operation -ne "S")
{
$Rights = Read-Host "Le nom du rôle des droits d'accès (Owner, PublishingEditor, Editor, Author, Reviewer)"
}

#Vecteur des dossiers à exclure des accès à donner
$arrExceptions = "\Contacts suggérés", "\Conversation Action Settings", "\Flux RSS", "\Journal", "\Recoverable Items", "\Deletions", "\Purges", "\Versions", "\Paramètres d'action de conversation"

#Liste de tous les dossiers de la boîte
$mailboxfolders = @(Get-MailboxFolderStatistics $Mailbox | Where {!($exclusions -icontains $_.FolderPath)} | Select FolderPath)

#Traitement
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

    #Traitement si le dossier n'est pas dans le vecteur d'exception
    if ($arrExceptions -notcontains $folder -or $Operation -eq "S")
    {
        Write-Host "Vérification de $identity pour les permissions de l'utilisateur $User"

            #Traitement dépendament de l'opération choisie au début
            try
            {
                Switch ($Operation)
                {
                    A{Add-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                    Write-Host -ForegroundColor Green "Permission ajoutée!"
                    }
                    M{Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                    Write-Host -ForegroundColor Green "Permission modifiée!"
                    }
                    S{Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
                    Write-Host -ForegroundColor Green "Permission retirée!"
                    }
                }
            }
            catch
            {
                #Tentative de modifier si les permissions sont déjà exisantes
                if ($_.Exception.Message -match "Une entrée d'autorisation existante a été trouvée pour l'utilisateur")
                {
                    try
                    {
                        Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                        Write-Host -ForegroundColor Green "Une permission éxistait déjà, elle a été modifiée pour celle demandée!"
                    }

                    #Affichage de l'erreur, si présente
                    catch
                    {
                        Write-Warning $_.Exception.Message
                    }
                }

                #Affichage de l'erreur, si présente
                else
                {
                    Write-Warning $_.Exception.Message
                }
            }
    }
} ; Break}

    5 { 
        $arrayUtil = @()
$arrayBoite = @()
$arrExceptions = "\Contacts suggérés", "\Conversation Action Settings", "\Flux RSS", "\Journal", "\Recoverable Items", "\Deletions", "\Purges", "\Versions", "\Paramètres d'action de conversation"
Do {
$Operation = Read-Host "Quel opération voulez-vous faire ((A)jout / (M)odification / (S)upression)"
}
Until ($Operation -eq "A" -or $Operation -eq "M" -or $Operation -eq "S")
do
{
    $utilisateur = Read-Host "Entrer le nom d'utilisateur (tapez arret pour arreter la saisie)"
    if ($utilisateur -ne "arret")
    {
        $arrayUtil += $utilisateur
    }
}while ($utilisateur -ne "arret")
do

{
    $boite = Read-Host "Entrez le nom de la boîte courriel (tapez arret pour arreter la saisie)"
    if ($boite -ne "arret")
    {
        $arrayBoite += $boite
    }
}while ($boite -ne "arret")
if ($Operation -ne "S")
{
$Rights = Read-Host "Le nom du rôle des droits d'accès (Owner, PublishingEditor, Editor, Author, Reviewer)"
}
foreach ($User in $arrayUtil)
{
    foreach ($Mailbox in $arrayBoite)
    {
        $mailboxfolders = @(Get-MailboxFolderStatistics $Mailbox | Where {!($exclusions -icontains $_.FolderPath)} | Select FolderPath)

        foreach ($mailboxfolder in $mailboxfolders)
        {
            $folder = $mailboxfolder.FolderPath.Replace("/","\")
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
            $identity = "$($mailbox):$folder"
            if ($arrExceptions -notcontains $folder -or $Operation -eq "S")
            {
                Write-Host "Vérification de $identity pour les permissions de l'utilisateur $User"
                try
                {
                    Switch ($Operation)
                    {
                        A{Add-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                        Write-Host -ForegroundColor Green "Permission ajoutée!"
                        }
                        M{Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                        Write-Host -ForegroundColor Green "Permission modifiée!"
                        }
                        S{Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
                        Write-Host -ForegroundColor Green "Permission retirée!"
                        }
                    }
                }
                catch
                {
                    if ($_.Exception.Message -match "autorisation existante")
                    {
                        try
                        {
                            Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                            Write-Host -ForegroundColor Green "Une permission éxistait déjà, elle a été modifiée pour celle demandée!"
                        }
                        catch
                        {
                            Write-Warning $_.Exception.Message
                        }
                    }
                    else
                    {
                        Write-Warning $_.Exception.Message
                    }
                }
            }
        }
    }
}; Break}

    6 { 

        #Adresse courriel de la boîte
        $Mailbox = Read-Host "L'adresse courriel de la boîte"

        #Nom d'utilisateur a donner les accès
        $User = Read-Host "Le code NT de l'utilisateur"

        #Affiche le résultat
        Get-Mailbox $Mailbox | fl grantsendonbehalfto

        $fullName = (Get-ADUser $User).name
        $MailboxName = (Get-Mailbox $Mailbox).name

        "Voulez vous ajouté l'utilisateur $fullName à $MailboxName"
        $banane = Read-host "1 - oui 2- non"
            

        if($banane -eq '1'){

        #EasterEGG
        ""
        "---------------------------------------------------------------"
        " Gandalf est parti ajouter le compte dans la console Exchange"
        "---------------------------------------------------------------"

        #Donne les droits d'envoyé de la part de
        set-Mailbox $Mailbox -GrantSendOnBehalfTo @{add="$User"}


        Start-Sleep -s 10

        #Affiche le résultat
        Get-Mailbox $Mailbox | fl grantsendonbehalfto

        }

        else { "Gandalf est retourné fumé." }
        
        ; Break
        
        }

    7 { 

        #Adresse courriel de la boîte
        $Mailbox = Read-Host "L'adresse courriel de la boîte"

        #Type de vers la convertions
        $Type = Read-Host "Type de conversion: Regular, Room, Equipment, Shared"

        #Conversion
        Set-Mailbox $Mailbox -Type $Type

        #confirmation
        Write-Host "La boite" $Mailbox "a été convertie en " $Type -ForegroundColor Black -BackgroundColor Green
        ; Break
        
       }

    8 { 
        $user = Read-Host "CodeNT de l'Utilisateur"
        Write-Host "`n"
        Write-Host " 1 - Valider une redirection"
        Write-Host " 2 - Entrée une redirection"
        Write-Host " 3 - Supprimée une redirection"
        $choixDPSAG = Read-Host "Veuillez faire un Choix" 
        Write-Host "`n"
        
        Switch ($choixDPSAG){
        1 { Write-Host "La redirection pour $user est la suivante: "
            Get-Mailbox -Identity $user | fl ForwardingSMTPAddress,DeliverToMailboxandForward 
        
            ; Break}

        2 { $ForwardingAddress = Read-Host "Adresse complète de la redirection"
            Set-Mailbox -Identity $user -ForwardingSmtpAddress $ForwardingAddress
            Get-Mailbox -Identity $user | fl ForwardingSMTPAddress,DeliverToMailboxandForward 
            
            ; Break}

        3 { Write-Host "La redirection pour $user est la suivante: "
            Set-Mailbox -Identity $user -ForwardingSmtpAddress $null
            Get-Mailbox -Identity $user | fl ForwardingSMTPAddress,DeliverToMailboxandForward 
            
            ; Break}
        
        }
        ; Break}

    9 { 
     
        Clear-host

        #------------------- Progress bar ----------------------#
        $Percent=1
        $total = 45
        $currentPercent = $percent/$total*100
        #------------------ /Progress bar ----------------------#


        #------------------- Récupération donnée utilisateur ----------------------#
        $numDS = Read-Host "Numéro de la demande: "

        $ntprop = Read-Host "Code NT du propriétaire: "

        $infoprop = (Get-ADUser $ntprop -Properties *)

        $champInfo = $numDS + " - " +  $infoprop.Name


        $nomcomplet = ""
        $Given = ""
        $Surname = ""
        $UPN = "upnGenerique@transports.gouv.qc.ca"
        $samaccount = ""
        $description = ""
        $path = "OU=_Utilisateurs,OU=DGTI,OU=SMSG,DC=MTQ,DC=MIN,DC=INTRA"

        $Surname = Read-Host "Préfix de la boite (Ex: _C DGTI): "
        $Given = Read-Host "Sufix de la boite (Ex: boite de test): "
        $samaccount = Read-Host "Code NT de la boite (Ex: cc-dgti00-boitetest): "
        $description = Read-Host "Description à donné: "

        if ( $Surname[0] -eq "_"){ $Surname = $Surname.ToUpper()}

        $nomcomplet = $Surname + ", " + $Given

        ""
        "Nom complet: " + $nomcomplet
        ""
        "Voulez-vous procéder ?"
        pause
        #------------------ /Récupération donnée utilisateur ----------------------#


        #------------------- Création de l'objet dans l'AD ----------------------#

        New-ADUser -Name $nomcomplet -GivenName $Given -Surname $Surname -UserPrincipalName $UPN -SamAccountName $samaccount -Description $description -Path $path -PassThru | Enable-ADAccount


        Set-aduser $samaccount -StreetAddress $infoprop.StreetAddress
        Set-aduser $samaccount -Replace @{adminDisplayName = $infoprop.adminDisplayName}
        Set-aduser $samaccount -Company $infoprop.Company
        Set-aduser $samaccount -Department $infoprop.Department
        Set-aduser $samaccount -Division $infoprop.Division
        Set-aduser $samaccount -City $infoprop.City
        Set-aduser $samaccount -PostalCode $infoprop.PostalCode
        Set-aduser $samaccount -State $infoprop.State
        Set-aduser $samaccount -Replace @{extensionAttribute2 = $infoprop.extensionAttribute2}
        Set-aduser $samaccount -Title "Boîte Commune"
        Set-aduser $samaccount -Replace @{info = $champInfo}

        ""
        "---------------------------------"
        "    Création de l'utilisateur    "
        "---------------------------------"
        for($i = 0; $i -lt 30; $i++){

        $total = 30

        Start-Sleep -Seconds 1
        $currentPercent = $percent/$total*100
        Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de création compte AD"

        $Percent++

        }

        #------------------ /Création de l'objet dans l'AD ----------------------#



        #------------------- Création de la boite exchange ----------------------#
        ""
        "---------------------------------"
        "      Création de la boite       "
        "---------------------------------"

        Enable-Mailbox -Identity $samaccount

        $Percent=1

        for($i = 0; $i -lt 15; $i++){

        $total = 15

        Start-Sleep -Seconds 1
        $currentPercent = $percent/$total*100
        Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de création de la boite"

        $Percent++

        }

        ""
        "---------------------------------"
        "      Récupération du UPN        "
        "---------------------------------"

        $getUPN = (Get-Recipient $samaccount).EmailAddresses


        # définition du séparateur
        $separateur = ":"
         # Split du numéro d'UA
        $upn = $getUPN[1].split($separateur, [System.StringSplitOptions]::RemoveEmptyEntries)

        $newUPN = $upn[1]
        ""
        "---------------------------------"
        " " + $newUPN
        "---------------------------------"

        Set-ADUser $samaccount -UserPrincipalName $newUPN

        Set-Mailbox $samaccount -Alias $samaccount

        ""
        "---------------------------------"
        " Convertion de la boite en share "
        "---------------------------------"

        Set-Mailbox $samaccount -Type Shared



        $Percent=1

        for($i = 0; $i -lt 15; $i++){

        $total = 15

        Start-Sleep -Seconds 1
        $currentPercent = $percent/$total*100
        Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de convertion"

        $Percent++

        }
        ""
        "---------------------------------"
        "        Convertion réussi        "
        "---------------------------------"


        $choixPrimaire = Read-Host "Voulez-vous changer l'adresse primaire ? 1-oui 2-non"

        switch($choixPrimaire){

            1{$Percent++
            Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de convertion"

                ""
                "*************************************************"
                "@transports.gouv.qc.ca sera ajout automatiquement"
                "*************************************************"
                ""
                $getMail = Read-host " Quelle adresse voulez vous ajouter: "

                $newmail = $getMail + "@transports.gouv.qc.ca"
                ""
                $newmail
                ""
                "Voulez-vous procéder ?"
                pause
                ""
                ""
                "---------------------------------"
                " Application du nouveau courriel "
                "---------------------------------"
                Set-Mailbox $samaccount -EmailAddressPolicyEnabled $False
                Set-Mailbox $samaccount -EmailAddresses @{ Add = $newmail }
                Set-Mailbox $samaccount -PrimarySmtpAddress $newmail
                Set-ADUser  $samaccount -UserPrincipalName $newmail
                $Percent++
                Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de convertion"

                ""
                "---------------------------------"
                "        Traitement terminé       "
                "---------------------------------"
                "    Que la force soit avec vous  "
                "---------------------------------"
                $Percent++

                ""
                "----------------------------------"
                "  Veuillez changer la boite d'OU  "
                "----------------------------------"
                " MTQ.MIN.INTRA/SMSG/DGTI/_Utilisateurs/ "
                "----------------------------------"
                ""
                ; break
    
                }

            2{
    
                ""
                "---------------------------------"
                "        Traitement terminé       "
                "---------------------------------"
                "    Que la force soit avec vous  "
                "---------------------------------"
                ; break
                }


        }

        #------------------ /Création de la boite exchange ----------------------#


        #------------------ Application des droits de la boite ----------------------#

        ""
        "---------------------------------"
        " Ajout des droits de propriétaire "
        "---------------------------------"
        ""
        $Operation = "A"
        #Adresse courriel de la boîte
        $Mailbox = $samaccount
        #Nom d'utilisateur a donner les accès
        $User = $ntprop
        #Si ce n'est pas une supression, le rôle a donner
        if ($Operation -ne "S")
        {
        $Rights = "Owner"
        }
        #Vecteur des dossiers à exclure des accès à donner
        $arrExceptions = "\Contacts suggérés", "\Conversation Action Settings", "\Flux RSS", "\Journal", "\Recoverable Items", "\Deletions", "\Purges", "\Versions", "\Paramètres d'action de conversation"
        #Liste de tous les dossiers de la boîte
        $mailboxfolders = @(Get-MailboxFolderStatistics $samaccount | Where {!($exclusions -icontains $_.FolderPath)} | Select FolderPath)
        $Percent++
        Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de convertion"

        #Traitement
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

            #Traitement si le dossier n'est pas dans le vecteur d'exception
            if ($arrExceptions -notcontains $folder -or $Operation -eq "S")
            {
                Write-Host "Vérification de $identity pour les permissions de l'utilisateur $User"

                    #Traitement dépendament de l'opération choisie au début
                    try
                    {
                        Switch ($Operation)
                        {
                    
                            A{Add-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                            Write-Host -ForegroundColor Green "Permission ajoutée!"
                            $Percent++
                            Write-Progress -activity "Création de la boite commune..." -PercentComplete "$currentPercent" -CurrentOperation "$nomcomplet en cours de convertion"
                            }
                            M{Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                            Write-Host -ForegroundColor Green "Permission modifiée!"
                            }
                            S{Remove-MailboxFolderPermission -Identity $identity -User $User -Confirm:$false -ErrorAction STOP
                            Write-Host -ForegroundColor Green "Permission retirée!"
                            }
                        }
                    }
                    catch
                    {
                        #Tentative de modifier si les permissions sont déjà exisantes
                        if ($_.Exception.Message -match "Une entrée d'autorisation existante a été trouvée pour l'utilisateur")
                        {
                            try
                            {
                                Set-MailboxFolderPermission -Identity $identity -AccessRights $Rights -User $User -ErrorAction STOP > $null
                                Write-Host -ForegroundColor Green "Une permission éxistait déjà, elle a été modifiée pour celle demandée!"
                            }

                            #Affichage de l'erreur, si présente
                            catch
                            {
                                Write-Warning $_.Exception.Message
                            }
                        }

                        #Affichage de l'erreur, si présente
                        else
                        {
                            Write-Warning $_.Exception.Message
                        }
                    }
            }
         }


        ""
        "---------------------------------"
        " Ajout du droit d'envoyé de la par de: "
        "---------------------------------"
         set-Mailbox $Mailbox -GrantSendOnBehalfTo @{add="$User"}

         #------------------ /Application des droits de la boite ----------------------#
     
      }
 
}


function senderror{



$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName

# Définitions des Array pour l'envoie de courriel d'erreur.
$to = @()
                    
# Définitions des parametres pour le courriel
$to = ('Gauthier, Pierre-Yves (Consultant) <pierre-yves.gauthier-c@transports.gouv.qc.ca>')
$from = "_C DTI, CMI <cmi@transports.gouv.qc.ca>"
$subject = "ZZ Accès Une erreur s'est produite"
$serverInfo = "casarrayqc.mtq.min.intra"
$encoding=[System.Text.Encoding]::UTF8


$utilisateur = $User
$usercredential = $env:UserName
$pc = $env:ComputerName
$msgError = ""
$optionMail = $Menu

$msgError += " Error Message : "
$msgError += $ErrorMessage
$msgError += "`n`n"
$msgError += " FailedItem : "
$msgError += $FailedItem

$body = ""
$body += "Nom du script : "
$body += $script
$body += "`n`n"
$body += "Version du script : "
$body += $version
$body += "`n`n"
$body += "Option du script : "
$body += $optionMail
$body += "`n`n"
$body += "Utilisateur en modification : "
$body += $utilisateur
$body += "`n`n"
$body += "Opérateur : "
$body += $usercredential
$body += "`n`n"
$body += "Nom du poste : "
$body += $pc
$body += "`n`n"
$body += "Message d'erreur : "
$body += "`n`n"
$body += $msgError
$body += "`n`n"

#Envoie du message
#$SendMail = Send-MailMessage -To "$to" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
$SendMailTemp = Send-MailMessage -To $to -From $from -Subject $subject -Body $body -SmtpServer $serverInfo -Encoding $encoding
Write-Host "Message d'erreur été transféré à l'équipe "
Write-Host ""
Write-Host $Body

}