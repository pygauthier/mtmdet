<#Version 1.1
But : Pr�parer les utilisateurs pour AirWatch MTQ
Entr�e : Code NT
Sortie : -
Createur : Francis Trudel
Date : 2017-03-09

Liste des versions:
1.0 cr�ation
1.1 Ajout de l'envoie d'un courriel au r�pondant cellulaire avec les donn�es de l'utilisateur
#>

# Nettoyage de la f�netre de powershell
Clear-Host

#Initiation des variables Global

#Nom d'utilisateur a donner les acc�s
$User = ""
# R�sponse Menu
$Menu = ""



# D�but du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - iPhone"
Write-Host "2 - iPhone du BSM"
Write-Host "3 - iPhone Commun"
#Write-Host "4 - iPhone Multiple"
Write-Host ""
$Menu = Read-Host "Numero de l'option: "


$user = read-Host "Nom d'utilisateur"

                    # D�finitions des Array pour l'envoie de courriel au Service Cellulaire.
                    $to = @()
                    $userInfo = @()
                    $userNameDel = @()
                    
                    # D�finitions des parametres pour le courriel
                    $to = ('_C DTI, �quipe des services cellulaires <services.cellulaires@transports.gouv.qc.ca>')
                    $from = "ZZ DSoC, Sy acc�s <cmi@transports.gouv.qc.ca>"
                    $subject = "ZZ Acc�s Ajout d'un utilisateur � AirWatch"
                    $serverInfo = "casarrayqc.mtq.min.intra"
                    $encoding=[System.Text.Encoding]::UTF8

                    # Ajout des informations de l'utilisateur dans le courriel
                    $adRequets = Get-ADUser $user -Properties *
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
                    $SendMail = Send-MailMessage -To "$to" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
                    $SendMailTemp = Send-MailMessage -To "pierre-yves.gauthier-c@transports.gouv.qc.ca" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
                    $Confirmation = Write-Host "Message a l'�quipe des services cellulaires envoy�."


# D�but du case des options

Switch ($Menu){
	1{
		#Nom du groupe de s�curit� pour AirWatch MTQ
		$group = "U-MIN000-G-AirwatchMTQ"

		#Ajoute le compte dans le groupe de s�curit�.
		try {Add-ADGroupMember $group -members $user}
		catch {Write-Host "Un erreur est survenue ou le compte est d�j� membre du groupe $group"}

		#Activer ActiveSync pour le compte.
		try {Set-CASMailbox -identity:$user -ActiveSyncEnabled:$True}
		catch {Write-Host "Un erreur est survenue ou le compte a d�j� ActiveSync d'activ�"}
		
		; Break}	

	2{
		#Nom du groupe de s�curit� pour AirWatch BSM
		$group = "U-MIN000-G-AirwatchBSM"


		#Ajoute le compte dans le groupe de s�curit�.
		try {Add-ADGroupMember $group -members $user}
		catch {Write-Host "Un erreur est survenue ou le compte est d�j� membre du groupe $group"}

		#Activer ActiveSync pour le compte.
		try {Set-CASMailbox -identity:$user -ActiveSyncEnabled:$True}
		catch {Write-Host "Un erreur est survenue ou le compte a d�j� ActiveSync d'activ�"}	
	
	
	; Break}
	
	3{
		#Nom du groupe de s�curit� pour AirWatch MTQ
		$group = "U-MIN000-G-AirwatchMTQCommun"


		#Ajoute le compte dans le groupe de s�curit�.
		try {Add-ADGroupMember $group -members $user}
		catch {Write-Host "Un erreur est survenue ou le compte est d�j� membre du groupe $group"}

		#Activer ActiveSync pour le compte.
		try {Set-CASMailbox -identity:$user -ActiveSyncEnabled:$True}
		catch {Write-Host "Un erreur est survenue ou le compte a d�j� ActiveSync d'activ�"}
	

	; Break}
	
	4{

        Try {
		#Vider le vecteur de noms
		$arrayuser = @()

		#Groupe de s�curit� pourn AirWatch MTQ
		$group = "U-MIN000-G-AirwatchMTQ"

		#Entr�e du/des noms d'utilisateurs, tant que l'entr�e n'est pas vide
		do
		{
			$user = read-Host "Nom d'utilisateur (laissez vide pour arreter)"
			if ($user -ne "")
			{
				$arrayuser += $user
			}
		}while ($user -ne "")

		#Traitement pour la liste des noms fournis
		foreach ($utilisateurs in $arrayuser)
		{
			#Ajout dans le groupe de s�curit�
			try {Add-ADGroupMember $group -members $utilisateurs -ErrorAction:Stop -WarningAction:Stop}
			catch {"Un erreur est survenue ou le compte est d�j� membre du groupe $group pour le compte $utilisateurs"}

			#Activer ActiveSync pour le compte
			try {Set-CASMailbox -identity:$utilisateurs -ActiveSyncEnabled:$True -ErrorAction:Stop -WarningAction:Stop}
			catch {"Un erreur est survenue ou le compte a d�j� ActiveSync d'activ� pour le compte $utilisateurs"}
		}}Catch { $ErrorMessage = $_.Exception.Message}
	
	; Break}
}
