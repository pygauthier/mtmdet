<#Version 1.0
But : Appliqué une redirection d'adresse courreil sur une Batch User.
Entrée : contactForward.csv au format "," (comma sepated) entete : Identity,ForwardAddress 
Createur : Pierre-Yves Gauthier
Date : 2017-03-25

Example de Data dans fichier CSV:

Identity,ForwardAddress 
testUser,test.user@hotmail.com

Emplacement du csv à la base du Run Script
#>

Import-Csv -Path “contactForward.csv” | 
        ForEach {Set-Mailbox -Identity $_.Identity -ForwardingSmtpAddress $_.ForwardingAddress
                 Get-Mailbox -Identity $_.Identity | fl ForwardingSMTPAddress,DeliverToMailboxandForward}