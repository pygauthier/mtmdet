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
"------------------------------"
"Groupe restant : "
$adgroup = (Get-ADPrincipalGroupMembership -Identity $User)
$adgroup.name
"------------------------------"