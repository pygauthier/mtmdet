<#Version 1.5
But : Gestion des utilisateurs.
Entrée : Varriable
Createur : Pierre-Yves Gauthier
Date : 2017-03-09

Liste des versions:
1.0 création
1.1 Ajout de l'envoie d'un courriel au répondant cellulaire avec les données de l'utilisateur dans l'option 5
1.2 Ajout d'une fonction pour validé si l'utilisateur posssède les groupes Airwatch.
1.3 Ajout de l'option 6 qui permet de normaliser les comptes génériques, de tests et de services (Francis Trudel)
1.4 Ajout de la désactivation et déplacement du compte dans l'ou désactivé - 2017-08-04
1.5 Ajout des logs utilisateur lors du retrait. 
#>

# Nettoyage de la fênetre de powershell
Clear-Host

#Initiation des variables Global
$UserName =""
$groupName = ""
$Menu =""
$Menu2=""
$user1 =""
$member1 =""
$user2 =""
$member2 =""
$indent =""
$user =""
$NTinput =""

# Début du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - Comparaison des groupes de 2 utilisateurs"
Write-Host "2 - Extraire les membres d'un groupe"
Write-Host "3 - Extraire les membres et leur courriel d'un groupe"
Write-Host "4 - Extraire les groupes de sécurité d'un utilisateur"
Write-Host "5 - Détruire le compte d'un utilisateur"
Write-Host "6 - Normaliser les comptes génériques, de tests et de services"
Write-Host ""
$Menu = Read-Host "Numéro de l'option: "

Switch($Menu){
        
        1 { 
            # Enter First AD User
            $user1 = Read-Host "Enter the identity of the first AD User"

            # Get AD group membership of User1
            $member1 = Get-ADPrincipalGroupMembership -Identity $user1

            # Enter Second AD User
            $user2 = Read-Host "Enter the identity of the second AD User"

            # Get AD group membership of User2
            $member2 = Get-ADPrincipalGroupMembership -Identity $user2

            # Output Message
            Write-Host
            "$user1 and $user2 have the following difference in AD group membership.
            The SideIndicator indicates which AD user was found in the corresponding AD group. 
            $user1 is a member of SideIndicator <= and $user2 is a member of SideIndicator =>
            Groups that both users are a part of are not displayed.
            "

            # Compare user1 membership to user2 membership and display only the difference in membership. Only show the name of the group and sort alphabetically.
            # The SideIndicator indicates which AD user was found in the corresponding AD group.
            Compare-Object -ReferenceObject ($member1) -DifferenceObject ($member2) -Property Name | Sort Name
        ; Break}
        2 { 
            #Entrée du nom de groupe a extraire
            $groupName = Read-Host "Nom du groupe a extraire"

            #Initialisation de l'indentation
            $indent = ""

            #Affichage du groupe initial
            Write-Host $groupName

            #Fonction pour extraire les membres d'un groupe (appelée de façon récursive quand il y a des sous-groupes)
            function printLoop
            {
                #Paramètre d'entrée : Groupe a extraire
                param( $groups )
                $groupContent = Get-ADGroupMember $groups | Sort-Object ObjectClass,Name
                #$indent = $indent + "`t"
                #Boucle pour éclater les sous-groupes
                foreach($G in $groupContent)
                {
                    if ($G.ObjectClass -ccontains "group")
                    {
                        Write-Host "$indent"$G.Name
                        printLoop -groups $G
                    }
                    elseif ($G.ObjectClass -ccontains "user")
                    {
                        Write-Host "$indent"$G.Name
                    }
                }
            }

            #Appel initial de la fonction
            printLoop -groups $groupName
        ; Break}
        3 { 
            #Entrée du Groupe
            $groupName = Read-Host "Nom du groupe a extraire"


            Get-ADGroupMember -Identity "$groupName" -Recursive | 
            Get-ADUser -Properties Mail | 
            Select-Object Name,Mail,sAMAccountName | 
            Export-CSV -Path V:\Get-ADGroupMembers_Emails.csv -encoding UNICODE
            ; Break}
        4 { 

            $UserName = Read-Host "Le code NT de l'utilisateur"
            Import-Module ActiveDirectory 
            If ($UserName) { 
                $UserName = $UserName.ToUpper().Trim() 
                $Res = (Get-ADPrincipalGroupMembership $UserName | Measure-Object).Count 
                If ($Res -GT 0) { 
                    Write-Output "`n" 
                    Write-Output "The User $UserName Is A Member Of The Following Groups:" 
                    Write-Output "===========================================================" 
                    Get-ADPrincipalGroupMembership $UserName | Select-Object -Property Name <#, GroupScope, GroupCategory #> | Sort-Object -Property Name | FT -A 
                } 
            }
            ; Break}
        5 { $NT=@()
                $Percent=1
                do
                {
                    $NTinput = Read-Host "Nom du compte a supprimer"
                    if ($NTinput -ne "")
                    {
                        $NT += $NTinput
                    }
                }while ($NTinput -ne "")
                $total = $NT.Count
                    
                    # Initiation des groupes pour airwatch
                    $groupBSM = "U-MIN000-G-AirwatchBSM"
                    $groupCommun = "U-MIN000-G-AirwatchMTQCommun"
                    $groupAirwatch = "U-MIN000-G-AirwatchMTQ"

                foreach ($user in $NT)
                {
                    #Création de la barre de pourcentage
                    $currentPercent = $percent/$total*100
                    Write-Progress -activity "Suppression de compte..." -PercentComplete "$currentPercent" -CurrentOperation "$user en cours de suppression"
                    
                    #Désactivation du compte
                    Disable-ADAccount $user

                    #Ajustement du parametre dans exchange pour caché la boite courriel
                    Set-Mailbox -Identity $user -HiddenFromAddressListsEnabled $true

                    #Destruction du V:\
                    $homedir = Get-ADUser $user -Properties Name, homedirectory
                    rm -Force -Recurse $homedir.homedirectory
                    Echo "Veuillez vérifier le BES pour $user"

                    # Validation d'accès Airwatch
                    $members1 = Get-ADGroupMember -Identity $groupBSM -Recursive | Select -ExpandProperty SamAccountName
                    $members2 = Get-ADGroupMember -Identity $groupCommun -Recursive | Select -ExpandProperty SamAccountName
                    $members3 = Get-ADGroupMember -Identity $groupAirwatch -Recursive | Select -ExpandProperty SamAccountName

                    #Si l'utilisateur fait parti d'un groupe Airwatch, on retourne une boite de dialogue
                    If ($members1 -contains $user) {

                           $wshell = New-Object -ComObject Wscript.Shell
                           $wshell.Popup("L'utilisateur est membre de $groupBSM`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)
            
                          }
                    Elseif ($members2 -contains $user) {

                           $wshell = New-Object -ComObject Wscript.Shell
                           $wshell.Popup("L'utilisateur est membre de $groupCommun`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)

                         }
                    Elseif ($members3 -contains $user) {

                           $wshell = New-Object -ComObject Wscript.Shell
                           $wshell.Popup("L'utilisateur est membre de $groupAirwatch`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)

                         } 
                    Else {
                                Write-Host "$user n'est pas membre de groupe AirWatch"
                         }
                    
                    #Incrémentation de la barre de pourcentage
                    $Percent++

                    #----------------- Integration Script EN -------------------------------------#

                    $Utilisateur = $user
                    $DemandeService = Read-Host "Quel est le numéro de la demande de service"

                    $AujourdHui = Get-Date -format "yyyyMMdd"
                    $User = Get-ADUser $Utilisateur -Properties *
                    $Description = @()
                    $Description = ($User.Description).Split(";")

                    try{
                    if ($Description -like $null ) {
                    $CreationDate = Get-Date ([DateTime] $User.Created) -Format "yyyyMMdd"
                    $Creation = "C"+$CreationDate+";;"
                    Set-ADUser $User -Description $Creation
                    $User = Get-ADUser $Utilisateur -Properties *
                    }

                    if ($Description.count -eq 1)
                    {
                    $DescTemp = "","",$Description[0]
                    }
                    $DescTemp[0] = "D"+$AujourdHui
                    $DescTemp[1] = $DemandeService.ToUpper()
                    $DescFinal = $DescTemp -join (";")
                    }
                    catch{ "Erreur dans l'écriture de la description veuillez inscrire: " + $DescFinal }

                    $User | Disable-ADAccount
                    Set-ADUser $User -Description $DescFinal
                    $User | Move-ADObject -TargetPath "OU=_Comptes Inactifs,OU=_Utilisateurs,OU=GLOBAL,DC=MTQ,DC=MIN,DC=INTRA"
                    Write-Host "Le compte a été désactivé et déplacé dans l'OU en conséquence."
                    #----------------- Integration Script EN Fin ---------------------------------#


                    # Définitions des Array pour l'envoie de courriel au Service Cellulaire.
                    $to = @()
                    $userInfo = @()
                    $userNameDel = @()
                    
                    # Définitions des parametres pour le courriel
                    $to = ('_C DTI, Équipe des services cellulaires <services.cellulaires@transports.gouv.qc.ca>')
                    $from = "ZZ DSoC, Sy accès <cmi@transports.gouv.qc.ca>"
                    $subject = "ZZ Accès Départ d'un utilisateur"
                    $serverInfo = "casarrayqc.mtq.min.intra"
                    $encoding=[System.Text.Encoding]::UTF8

                    # Ajout des informations de l'utilisateur dans le courriel
                    $adRequets = Get-ADUser $Utilisateur -Properties *
                    $userNameDel += $adRequets | ft name -HideTableHeaders
                    $userNameDel += $adRequets | ft extensionAttribute2 -HideTableHeaders
                    $userNameDel += $adRequets | ft adminDisplayName -HideTableHeaders
                    $userNameDel += $adRequets | ft Department -HideTableHeaders
                    $userNameDel += $adRequets | ft Division -HideTableHeaders
                    $userNameDel += $adRequets | ft employeeType -HideTableHeaders
                    $userNameDel += $adRequets | ft l -HideTableHeaders
                    $userNameDel += $adRequets | ft StreetAddress -HideTableHeaders
                    $userNameDel += $adRequets | ft DistinguishedName -HideTableHeaders
                    $userInfo += $userNameDel

                    #Envoie du message
                    Send-MailMessage -To "$to" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
                    Send-MailMessage -To "pierre-yves.gauthier-c@transports.gouv.qc.ca" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
                    Write-Host "Message a l'équipe des services cellulaires envoyé."

                    #----------------- Integration Script log user info + delete group ---------------------------------#

                    #---------------------------- Home Path ------------------------------#
                    $homePath = "\\mtq.min.intra\fic\QC\Espace Collaboratif\V2\DSOC-Acces\retraitUtilisateur\"
                    #---------------------------- Home Path ------------------------------#

                    $User = "tspygauthier"

                    $fileGroup = $homePath + $User+ ".group"
                    $fileInfo  = $homePath + $User + ".info"
                    $output = @()
                    $output2 = @()
                    $userGroups = @()
                    $userDetails = Get-ADUser $User -Properties *
                    $groupsRaw = $userDetails.MemberOf

                        ForEach ( $group in $groupsRaw ) {

                            $userGroups += $group.SubString(3,$group.IndexOf(',')-3)

                        }

                        $props = @{
                            User = $userDetails.Name
                            Groups = $userGroups -join '; '
                        }

                        $output += New-Object PsObject -Property $props


                        $infoUser = @{
        
                            CN = $userDetails.CN
                            SamAccountName = $userDetails.SamAccountName
                            physicalDeliveryOfficeName = $userDetails.physicalDeliveryOfficeName
                            extebsuibAttrubyte2 = $userDetails.extensionAttribute2
                            admindisplayName = $userDetails.adminDisplayName
                            whenCreated = $userDetails.whenCreated
                            whenChanged = $userDetails.whenChanged
                            HomeDrive = $userDetails.HomeDrive
                            HomeDirectory = $userDetails.HomeDirectory
                            mail = $userDetails.mail
                        }

                        $output2 += New-Object PsObject -Property $infoUser

                    $output | New-Item $fileGroup -type file
                    $output2 | New-Item $fileInfo -type file

                    "------------------------------"
                    "Groupe présent : "
                    $adgroup = (Get-ADPrincipalGroupMembership -Identity $User)
                    $adgroup.name
                    "------------------------------"
                    ""
                    for($i = 0; $i -lt $adgroup.Count; $i++){
    
                        Try{
                        Remove-ADGroupMember -Identity $adgroup[$i].SamAccountName -Members $User -Confirm:$false
                        }catch{ Write-Host "Vous n'avez pas les autorisations pour retirer ce groupe: "$adgroup[$i].name}
                    }

                    Start-Sleep -Seconds 5
                    ""
                    ""
                    "------------------------------"
                    "Groupe restant : "
                    $adgroup = (Get-ADPrincipalGroupMembership -Identity $User)
                    $adgroup.name
                    "------------------------------"
                    ""
                    "Transfert à Infra - Windows pour le retrait des groupes suivant: "
                    $adgroup.name
                    "Nous ne possèdons pas les droits"
                    "S.V.P transféré par la suite au groupe CMI - Acces sans mettre de responsable"

                    #---------------- /Integration Script log user info + delete group ---------------------------------#
                }; Break}				
		6 { 
			# Début du menu
			Write-Host "Veuillez choisir une des options suivante"
			Write-Host ""
			Write-Host "1 - Compte de Service et de test"
			Write-Host "2 - Compte Générique"
			Write-Host "3 - Modifier l'attribut"
			Write-Host "4 - Valider l'attribut d'un compte"
			Write-Host ""

			$Menu2 = read-Host "Numéros de l'option"

			Switch ($Menu2){
				1 {
					#Entrée Code NT du compte a modifier
					$user1 = read-Host "Nom d'utilisateur"
					SET-ADUSER $User1 -add @{carLicense="CS"}
					Write-Host "L’attribut CarLicense a été modifié pour" (get-aduser $user1 -Properties *).carLicense

				  ; Break}


				2 { 
					#Entrée Code NT du compte a modifier
					$user1 = read-Host "Nom d'utilisateur"
					SET-ADUSER $User -add @{carLicense="CG"}
					Write-Host "L’attribut CarLicense a été modifié pour" (get-aduser $user1 -Properties *).carLicense
				
				 ; Break}

				3 { 
					#Entrée Code NT du compte a modifier
					$user1 = read-Host "Nom d'utilisateur"
					$carLicense = Read-Host "CS ou CG"
					SET-ADUSER $User -Replace @{carLicense="$carLicense"}
					Write-Host "Gandalf procède à la modification de l’attribut actuellement"
					Start-Sleep -s 10
					Write-Host "L’attribut CarLicense est maintenant" (get-aduser $user1 -Properties *).carLicense
				
				 ; Break}

				4 { 
					#Entrée Code NT du compte a valider
					$user1 = read-Host "Nom d'utilisateur"
					Write-Host "L’attribut CarLicense est" (get-aduser $user1 -Properties *).carLicense
				
				 ; Break}

						}
           ; Break}

    }