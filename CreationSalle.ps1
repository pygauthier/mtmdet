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

$Surname = Read-Host "Préfix de la boite (Ex: _S 700RLE): "
$Given = Read-Host "Sufix de la boite (Ex: Salle 22.03): "
$samaccount = Read-Host "Code NT de la boite (Ex: cr-mtq000-salle2203): "
$description = Read-Host "Description à donné: "
$preseau = Read-Host "Nombre de prise réseaux: "
$ptelephone = Read-Host "Nombre de prise téléphoniques: "
$nbplace = Read-Host "Nombre de place"

$title = $preseau +" prise(s) réseau(x), " + $ptelephone + " prise(s) téléphonique(s)"

if ( $Surname[0] -eq "_"){ $Surname = $Surname.ToUpper()}

$nomcomplet = $Surname + ", " + $Given + " (" + $nbplace +")"

""
"Nom complet: " + $nomcomplet
""
"Voulez-vous procéder ?"
pause


#------------------- Création de l'objet dans l'AD ----------------------#

New-ADUser -Name $nomcomplet -GivenName $Given -Surname $Surname -UserPrincipalName $UPN -SamAccountName $samaccount -Description $description -Path $path -PassThru | Enable-ADAccount

""
"Voulez vous attribuer automatiquement les champs suivant du propriétaire à la ressource ?"
""
"Adresse physique (StreetAddress)"
"Direction Général (adminDisplayName)"
"Sous-Ministariat (Division)"
"Ville (City)"
"Code Postal (PostalCode)"
"extensionAttribute2 (extensionAttribute2)"
""
$setad = Read-host "Oui / Non"

if($setad -eq "oui"){

    Set-aduser $samaccount -StreetAddress $infoprop.StreetAddress
    Set-aduser $samaccount -Replace @{adminDisplayName = $infoprop.adminDisplayName}
    Set-aduser $samaccount -Company $infoprop.Company
    Set-aduser $samaccount -Department $infoprop.Department
    Set-aduser $samaccount -Division $infoprop.Division
    Set-aduser $samaccount -City $infoprop.City
    Set-aduser $samaccount -PostalCode $infoprop.PostalCode
    Set-aduser $samaccount -State $infoprop.State
    Set-aduser $samaccount -Replace @{extensionAttribute2 = $infoprop.extensionAttribute2}
    Set-aduser $samaccount -Title $title
    Set-aduser $samaccount -Replace @{info = $champInfo}

}

if($setad -eq "non"){
    
    $ntprop = Read-Host "Code NT d'une ressource sembable : "
    $infoprop = (Get-ADUser $ntprop -Properties *)

    Set-aduser $samaccount -StreetAddress $infoprop.StreetAddress
    Set-aduser $samaccount -Replace @{adminDisplayName = $infoprop.adminDisplayName}
    Set-aduser $samaccount -Company $infoprop.Company
    Set-aduser $samaccount -Department $infoprop.Department
    Set-aduser $samaccount -Division $infoprop.Division
    Set-aduser $samaccount -City $infoprop.City
    Set-aduser $samaccount -PostalCode $infoprop.PostalCode
    Set-aduser $samaccount -State $infoprop.State
    Set-aduser $samaccount -Replace @{extensionAttribute2 = $infoprop.extensionAttribute2}
    Set-aduser $samaccount -Title $title
    Set-aduser $samaccount -Replace @{info = $champInfo}


}

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
"UPN : "
" " + $newUPN
"---------------------------------"

Set-ADUser $samaccount -UserPrincipalName $newUPN

Set-Mailbox $samaccount -Alias $samaccount

""
"---------------------------------"
" Convertion de la boite en Room "
"---------------------------------"

Set-Mailbox $samaccount -Type Room



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
""
""    
""
"---------------------------------"
"        Traitement terminé       "
"---------------------------------"
"    Que la force soit avec vous  "
"---------------------------------"

#------------------ /Création de la boite exchange ----------------------#