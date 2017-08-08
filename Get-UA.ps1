function Get-UA {

param($User)

$longString = (Get-aduser $User -Properties *).departmentNumber

$separateur = "<UA> </UA> root"

$ua = $longString.split($separateur, [System.StringSplitOptions]::RemoveEmptyEntries)

return $ua[0]
}