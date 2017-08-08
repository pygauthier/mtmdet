<#
"U-MIN000-G-AirwatchBSM"
"U-MIN000-G-AirwatchMTQCommun"
"U-MIN000-G-AirwatchMTQ"
#>

$user = "tspygauthier"
$groupBSM = "U-MIN000-G-AirwatchBSM"
$groupCommun = "U-MIN000-G-AirwatchMTQCommun"
$groupAirwatch = "U-MIN000-G-AirwatchMTQ"
$members1 = Get-ADGroupMember -Identity $groupBSM -Recursive | Select -ExpandProperty SamAccountName
$members2 = Get-ADGroupMember -Identity $groupCommun -Recursive | Select -ExpandProperty SamAccountName
$members3 = Get-ADGroupMember -Identity $groupAirwatch -Recursive | Select -ExpandProperty SamAccountName

If ($members1 -contains $user) {

   $wshell = New-Object -ComObject Wscript.Shell
   $wshell.Popup("L'utilisateur est membre de $groupBSM`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)
            
 }
Elseif ($members2 -contains $user) {

   $wshell = New-Object -ComObject Wscript.Shell
   $wshell.Popup("L'utilisateur est membre de $groupCommun`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)

}
Elseif ($members3 -contains $user) {

   $wshell = New-Object -ComObject Wscript.Shell
   $wshell.Popup("L'utilisateur est membre de $groupAirwatch`n`nValidez la console AirWatch",0,"Console AirWatch",0x0)

} 
  Else {
        Write-Host "$user n'est pas membre de groupe AirWatch"
}