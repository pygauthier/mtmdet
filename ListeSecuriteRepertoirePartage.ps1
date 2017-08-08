$OutFile = "C:\OutputDC.csv"
Remove-Item $OutFile -ErrorAction SilentlyContinue
$Header = "Folder Path,Exception,IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
Add-Content -Value $Header -Path $OutFile 

 $RootPath = "\\SINFRA0-FIC001\DCRM$"

 try
 {
     $Folders = dir $RootPath -recurse 2>&1 | where {$_.psiscontainer -eq $true} 
 }
 catch [System.Exception]
 {
     $_.Exception.Message
 }

 foreach ($Folder in $Folders){
     
     try
     { 
         $ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
         $Exception = $false 
       }
     catch [System.Exception]
     {
         $Exception = $true
         $SystemMessage = $_.Exception.Message 
     }
     Finally
     {
         Foreach ($ACL in $ACLs)
         {
              if ($Exception -eq $false) {
                if ($ACL.IdentityReference -ne 'AUTORITE NT\Système' -and $ACL.IdentityReference -ne 'BUILTIN\Administrateurs' -and $ACL.IdentityReference -ne 'CREATEUR PROPRIETAIRE' -and $ACL.IdentityReference -ne 'BUILTIN\Utilisateurs')
                    {
                    $Perm = $ACL.FileSystemRights -replace ',','-'
                    $OutInfo = $Folder.Fullname + "," + $Exception  + "," + $ACL.IdentityReference + "," + $Perm + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags 
                    Add-Content -Value $OutInfo -Path $OutFile
                    #$OutInfo = $Folder.Fullname + "," + $Exception  + "," + $ACL.IdentityReference + "," + { $ACL.FileSystemRights -replace ',','-' } + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags 
                    }
              }
            else {
             $OutInfo = $Folder.Fullname + "," + $Exception  + "," + $SystemMessage
             Add-Content -Value $OutInfo -Path $OutFile
            }
      
        }
     }
 } 