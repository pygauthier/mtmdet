ForEach ($User in (Get-Content fullnames.csv | ConvertFrom-CSV -Header LastName,FirstName))
{   $Filter = "givenName -like ""*$($User.FirstName)*"" -and sn -like ""$($User.LastName)"""
    Get-ADUser -Filter $Filter | select-Object sAMAccountName
}