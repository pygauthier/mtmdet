<#Version 1.0
But : Donner accès à tous les répertoires
Entrée : -
Sortie : Log des erreurs sur le lecteur C:
Createur : Gabriel Pelletier
Date : 2016-08-04#>

#Initialisation de la varriable d'erreur
$err = ""

#Répertoire racine pour les accès à donner (Lister dans la variable les répertoires seulements et logger les erreurs)
$accList = ls "\\Sinfra0-fic001\dc$" -Recurse -Directory -ErrorVariable +err

#Traitement de la liste, par dossier
foreach ($folder in $accList)
{
    #Extraction de la sécurité courrante
    $listACL = Get-Acl $folder.FullName -ErrorVariable +err

    #Création des objets de sécurité à ajouter (5 paramètres)
    $addPerm1 = New-Object System.Security.AccessControl.FileSystemAccessRule("sematte","Modify",“ContainerInherit, ObjectInherit”,"None","Allow")

    #Ajout des objets de sécurité à l'extraction faite
    $listACL.AddAccessRule($addPerm1)

    #Écraser la sécurité avec la liste extraite + les ajouts
    Set-Acl $folder.FullName $listACL -ErrorVariable +err
}

#Création du fichier de log sur le C:
$err >> C:\logSSE.txt