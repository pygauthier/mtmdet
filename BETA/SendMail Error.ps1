

# Définitions des Array pour l'envoie de courriel d'erreur.
$to = @()
                    
# Définitions des parametres pour le courriel
$to = ('Gauthier, Pierre-Yves (Consultant) <pierre-yves.gauthier-c@transports.gouv.qc.ca>')
$from = "_C DTI, CMI <cmi@transports.gouv.qc.ca>"
$subject = "ZZ Accès Une erreur s'est produite"
$serverInfo = "casarrayqc.mtq.min.intra"
$encoding=[System.Text.Encoding]::UTF8

$script = "nom du script"
$version = "1.2"
$utilisateur = "user"
$usercredential = $env:UserName
$pc = $env:ComputerName
$msgError = "Message d'erreur"
$optionMail = "3"

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
$body += "Utilisateur en erreur : "
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
$SendMailTemp = Send-MailMessage -To $to -From $from -Subject $subject -Body $body -SmtpServer $serverInfo -Encoding $encoding
Write-Host "L'erreur a été signalé"
Write-Host $body