$LongString = @(Get-ADUser -Identity tspygauthier -Properties departmentNumber) | ft departmentNumber


$LongString | Export-Csv -Path "LongString_export.csv"
