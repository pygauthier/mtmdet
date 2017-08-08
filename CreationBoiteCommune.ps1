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