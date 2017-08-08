Import-Csv -Path "ADUsers.csv" | ForEach-Object {
 $samAccountName = $_."samAccountName"
Get-ADUser -Identity $samAccountName | 
 Set-ADUser -PasswordNeverExpires:$False -verbose
}