$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sinfra0-exc010.mtq.min.intra/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session -AllowClobber
