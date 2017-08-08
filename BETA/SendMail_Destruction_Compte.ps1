$to = @()
$from
$userInfo = @()
$userName = @()
$adRequets = Get-ADUser douthenthapanya -Properties *
$userName += $adRequets | ft name -HideTableHeaders
$userName += $adRequets | ft extensionAttribute2 -HideTableHeaders
$userName += $adRequets | ft adminDisplayName -HideTableHeaders
$userName += $adRequets | ft Department -HideTableHeaders
$userName += $adRequets | ft Division -HideTableHeaders
$userName += $adRequets | ft employeeType -HideTableHeaders
$userName += $adRequets | ft l -HideTableHeaders
$userName += $adRequets | ft StreetAddress -HideTableHeaders
$userName += $adRequets | ft DistinguishedName -HideTableHeaders

$to = ('_C DTI, Équipe des services cellulaires <services.cellulaires@transports.gouv.qc.ca>')
$from = "ZZ DSoC, Sy accès <cmi@transports.gouv.qc.ca>"
$subject = "Départ d'un utilisateur"
$serverInfo = "casarrayqc.mtq.min.intra"
$encoding=[System.Text.Encoding]::UTF8

$userInfo += $userName
Send-MailMessage -To "$to" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
Send-MailMessage -To "pierre-yves.gauthier-c@transports.gouv.qc.ca" -From $from -Subject $subject -Body ($userInfo | Out-String) -SmtpServer $serverInfo -Encoding $encoding
Write-Host "Message a l'équipe des services cellulaires envoyé."
