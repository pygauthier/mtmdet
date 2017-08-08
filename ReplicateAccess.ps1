$partageRacineOrigine = "\\SDSEC00-FIC001\Test-ACL$"
$partageRacineDestination = "\\mtq.min.intra\fic\QC\Espace Collaboratif\V4\Test-ACL"
$err = ""

$listFolderDest = ls "$partageRacineDestination" -Recurse -Directory -ErrorVariable +err

foreach ($folderName in $listFolderDest)
{
    $accessDest = Get-ACL $foldername.FullName -ErrorVariable +err
    $accessOrigin = Get-ACL (($folderName.FullName).Replace("$partageRacineDestination","$partageRacineOrigine")) -ErrorVariable +err

    foreach ($listAccessIndiv in $accessOrigin.access)
    {
        [string]$listAccessName = $listAccessIndiv.IdentityReference
        $verif = $listAccessName.split("\")
        if ($verif[0] -eq "BSM" -and $verif[1] -notmatch "U-DSEC00-D-ADMINISTRATION_PARTAGES")
        {
            $addPerm = ""
            $listAccessName = $listAccessName.replace("BSM","MTQ")
            $addPerm = New-Object System.Security.AccessControl.FileSystemAccessRule($listAccessName,$listAccessIndiv.FileSystemRights,$listAccessIndiv.InheritanceFlags,$listAccessIndiv.PropagationFlags,$listAccessIndiv.AccessControlType)
            $accessDest.AddAccessRule($addPerm)
        }
        elseif ($verif[0] -eq "MTQ" -and $verif[1] -notmatch "U-" -or $verif[1] -notmatch "D-")
        {
            $addPerm = ""
            $addPerm = New-Object System.Security.AccessControl.FileSystemAccessRule($listAccessName,$listAccessIndiv.FileSystemRights,$listAccessIndiv.InheritanceFlags,$listAccessIndiv.PropagationFlags,$listAccessIndiv.AccessControlType)
            $accessDest.AddAccessRule($addPerm)
        }
    }

    if ($accessOrigin.AreAccessRulesProtected -eq $true)
    {
        $accessDest.SetAccessRuleProtection($true,$false)
    }

    Set-Acl $foldername.FullName $accessDest -ErrorVariable +err
}

$err >> C:\logDFS.txt