$Users = Import-Csv -Path "Userlist-sn.csv" 
$OU = "MTQ.MIN.INTRA/DPSAG/_Utilisateurs/"  
$Password = "Bateau01!"         
foreach ($User in $Users)            
{            
    $Displayname = $User.Lastname + " " + $User.Firstname            
    $UserFirstname = $User.Firstname            
    $UserLastname = $User.Lastname                          
    #New-ADUser -Name $Displayname -DisplayName $Displayname -GivenName $UserFirstname -Surname $UserLastname -Path $OU
    New-ADUser -Name $Displayname -SamAccountName $Displayname -DisplayName $Displayname -Enabled $true -Path $OU
}