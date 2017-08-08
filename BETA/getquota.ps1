

$server = Read-Host "Nom du server: "

$user = Read-Host "CodeNT de l'utilisateur: "

$s = New-PSSession -ComputerName $server

Enter-PSSession -Session $s


Start-Sleep -s 10

$path = "D:\Usager\$user"

Get-FSRMQuota -Path $path

Exit-PSSession
