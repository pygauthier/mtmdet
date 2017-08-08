<#Version 1.0
But : Connexion au serveur exchange
Entrée : Identifiant de l'utilisateur.
Sortie : -
Createur : Pierre-Yves Gauthier 
Date : 2017-05-26#>

namespace LoginCMI
{

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sinfra0-exc010.mtq.min.intra/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session -AllowClobber

}