# Le fichier doit obligatoirement avoir l'entête tel qu'écrit (avec les mêmes nom exactement(Sans accent pour éviter les problèmes d'encodage)) sinon il ne pourra pas aller chercher les variables.
Write-Host -ForegroundColor Green "Le fichier CSV doit avoir la nomenclature suivante (avec une entête) : Contact, Prenom, Nom, OU, Courriel"
$csv = Read-Host "V:\contact.csv"
Import-Csv -Encoding Default -Delimiter ";" "$csv" | ForEach-Object {New-MailContact -Name $_.Contact -FirstName $_.Prenom -LastName $_.Nom -ExternalEmailAddress $_.Courriel -OrganizationalUnit $_.OU -DisplayName $_.Contact}