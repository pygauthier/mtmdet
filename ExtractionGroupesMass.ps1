$listUser = Get-Content "C:\dbgi.txt"

foreach ($user in $listUser)
{
    $infoUser = Get-ADUser $user -Properties memberof, city
    "`n" + $infoUser.Name + "`t" + $infoUser.SamAccountName + "`t" + $infoUser.city >> "C:\OutputDBGI.txt"
    $infoUser.memberOf >> "C:\OutputDBGI.txt"
}