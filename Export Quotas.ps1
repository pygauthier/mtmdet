$strComputer = "."
$path = "C:\Temp\QuotaList.csv"

$colItems = get-wmiobject -class "Win32_VolumeUserQuota" -namespace "root\CIMV2" `
-computername $strComputer
$hostData = "Compte;","Espace Utilisée;","Limite;"

foreach ($objItem in $colItems) {
$hostData += $objItem.Account + ";" + $objItem.DiskSpaceUsed + ";" + $objItem.Limit
}

$hostData >> C:\Temp\QuotaList.txt