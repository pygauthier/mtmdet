foreach ($user in $users) {

        Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * | 
        Set-ADUser -Replace @{admindisplayname = "$($user.admindisplayname)"; 
                            physicaldeliveryofficename = "$($user.physicaldeliveryofficename)"; 
                            department = "$($user.department)"; 
                            extensionattribute2 = "$($user.extensionattribute2)"; 
                            departmentnumber = "$($user.departmentnumber)"}

        if($_.Division -eq ''){
                    
                    Set-ADUser -Replace {division = $NULL}
        
                }Else {
                
                     Set-ADUser -Replace {division = "($user.division)"}

                }
  }