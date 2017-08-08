Get-ADUser -filter * -Properties * | 
Select-Object -Property HomeDriveRaccourci,adminDisplayName,sAMAccountName,Title,employeeType,Name,EmailAddress,RTCSIP,mail,proxyAddresses,division,physicalDeliveryOfficeName,
                        extensionAttribute2,Domain,homeDirectory,homeDrive,scriptPath,streetAddress,st,postalCode,telephoneNumber,whenCreated,
                        lastLogon,LastLogonDate,accountExpires,accountexpiresCalcul,logonCount,distinguishedName,description | 
Export-CSV -path c:\temp\adusers.csv -notypeinformation -encoding "unicode"