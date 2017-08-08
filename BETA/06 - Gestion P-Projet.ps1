<#Version 1.0
But : Création des P:\ Projet
Entrée : Direction, Nom du projet, Description
Sortie : Dossier sur projet
Createur : Pierre-Yves Gauthier
Date : 2017-07-22#>



Clear-Host



#------------    Emplacement des fichier .pproj    -------------------#

$dirRessource = "\\mtq.min.intra\fic\QC\Espace Collaboratif\V2\DSOC-CMI\Procédures du CMI\05 Accès\Powershell\"

#------------                                      -------------------#



<#
    Fonction permettant d'initialisé les variables à NULL

    Entrée: N\A
    Sortie: N\A

#>
function initVars{

    [cmdletbinding()]

    # Déclaration des variable globlal à ""

    #Pour le choix du menu
    $direction = ""

    # Nom du dossier à créer
    $folder

    # Désigne la base du dossier projet P:\
    $path = ""

    #description pour le dossier A)
    $description = ""

    #Crée le chemin du dossier de base
    $folderconstruct = ""
    
    # Création du dossier A) avec sa description
    $a = ""


    # Variable pour sécurité
    $acl = ""
    $group = ""

    # Importation du fichier de dossier
    $fileToImport = ""

    # Array pour utilisation interne de la fonction createFolder
    $array = ""

    # Variable pour utilisation interne de la fonction createFolder
    $dossierBase = ""
    $temp = ""

    # Variable pour utilisation interne de la fonction validation
    $base = ""
    $foldercount = ""

    #Array pour faire le liens entre l'importation et createFolder
    $arr = @()

    #Array pour faire la création
    $importedFiles = @()
}

<#
    Fonction permettant de supprimé les variables.

    Entrée: N\A
    Sortie: N\A

#>
function clearVars{

    Try{

    # Déclaration des variable globlal à ""

    #Pour le choix du menu
    Remove-Variable -name direction -erroraction SilentlyContinue

    # Nom du dossier à créer
    Remove-Variable -name folder -erroraction SilentlyContinue

    # Désigne la base du dossier projet P:\
    Remove-Variable -name path -erroraction SilentlyContinue

    #description pour le dossier A)
    Remove-Variable -name description -erroraction SilentlyContinue

    #Crée le chemin du dossier de base
    Remove-Variable -name folderconstruct -erroraction SilentlyContinue
    
    # Création du dossier A) avec sa description
    Remove-Variable -name a -erroraction SilentlyContinue


    # Variable pour sécurité
    Remove-Variable -name acl -erroraction SilentlyContinue
    Remove-Variable -name group -erroraction SilentlyContinue

    # Importation du fichier de dossier
    Remove-Variable -name fileToImport -erroraction SilentlyContinue

    # Array pour utilisation interne de la fonction createFolder
    Remove-Variable -name array -erroraction SilentlyContinue

    # Variable pour utilisation interne de la fonction createFolder
    Remove-Variable -name dossierBase -erroraction SilentlyContinue
    Remove-Variable -name temp -erroraction SilentlyContinue

    # Variable pour utilisation interne de la fonction validation
    Remove-Variable -name base -erroraction SilentlyContinue
    Remove-Variable -name foldercount -erroraction SilentlyContinue

    #Array pour faire le liens entre l'importation et createFolder
    Remove-Variable -name arr -erroraction SilentlyContinue

    #Array pour faire la création
    Remove-Variable -name importedFiles -erroraction SilentlyContinue

    }
    catch [System.Management.Automation.ErrorRecord]{ Write-Host "Variables Clear."}

    Write-Host "Variables Clear."
}

<#
    Fonction permettant d'appliquer une sécurité en écriture

    Entrée: $path; Chemin de base pour l'application de la sécurité
            $group; Groupe de de sécurité à ajouté avec les permitions modify

    Sortie: Confirmation Console
#>
function setWrite {

    [cmdletbinding()]
    param($path,
          $group)

    $basepath = $folderconstruct + $path
    Write-Host ""
    Write-Host "-------------------------"
    Write-Host " Ajout sécurité Écriture "
    Write-Host "-------------------------"
    Write-Host "Path: $basepath"
    Write-Host "Groupe: $group"
    Write-Host ""

    $acl = Get-Acl $basepath
    $permission = $group, 'Modify', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    $acl | Set-Acl -Path $basepath

}

<#
    Fonction permettant d'appliquer une sécurité en lecture

    Entrée: $path; Chemin de base pour l'application de la sécurité
            $group; Groupe de de sécurité à ajouté avec les permitions ReadAndExecute

    Sortie: Confirmation Console
#>
function setRead {

    [cmdletbinding()]
    param($path,
          $group)
    
    $basepath = $folderconstruct + $path
    Write-Host ""
    Write-Host "-------------------------"
    Write-Host " Ajout sécurité Lecture "
    Write-Host "-------------------------"
    Write-Host "Path: $basepath"
    Write-Host "Groupe: $group"
    Write-Host ""

    $acl = Get-Acl $basepath
    $permission = $group, 'ReadAndExecute', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    $acl | Set-Acl -Path $basepath

}

<#
    Fonction permettant d'appliquer une sécurité en FullControl

    Entrée: $path; Chemin de base pour l'application de la sécurité
            $group; Groupe de de sécurité à ajouté avec les permitions FullControl

    Sortie: Confirmation Console
#>
function setFull {

    [cmdletbinding()]
    param($path,
          $group)

    $basepath = $folderconstruct + $path
    Write-Host ""
    Write-Host "-------------------------"
    Write-Host " Ajout sécurité Full Ctrl"
    Write-Host "-------------------------"
    Write-Host "Path: $basepath"
    Write-Host "Groupe: $group"
    Write-Host ""

    $acl = Get-Acl $basepath
    $permission = $group, 'FullControl', 'ContainerInherit, ObjectInherit', 'None','Allow'
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    $acl | Set-Acl -Path $basepath

}

<#
    Fonction permettant de créer des dossiers en lot

    Entrée: $array; ArrayList contenant les noms de dossier à créer
            $dossierBase; dossier de base pour les créations des dossiers contenu dans le ArrayList

    Sortie: Confirmation Console + Dossier vide dans le dossier de base
#>
function createFolder {

    [cmdletbinding()]
    param ($array,
           $dossierBase)

    $ErrorActionPreference = "Stop"

    for($i = 0; $i -lt $array.Length; $i++){
     
     Try{
        $temp = $folderconstruct + $array[$i]

         New-Item $temp -type directory | Out-Null

         Write-Host "Création du dossier: "$array[$i]

         }Catch [System.IO.IOException]
            {
               "Directory Exists Already $array[$i]"
            }
         }

}

<#
    Fonction permettant d'importé un fichier dans un array

    Entrée: $fileToImport; Chemin complet du fichier.
    Sortie: Array des fichier importés.
#>
function importFolder {

    [cmdletbinding()]
    param($fileToImport)


    Write-Host ""
    Write-Host "---------------------"
    Write-Host " Importation en cours "
    Write-Host "---------------------"
    Write-Host ""

    $arrOfFile = (Get-Content $fileToImport -Encoding UTF8)

    $countimport = $arrOfFile.count + 1

    Write-Host ""
    Write-Host "---------------------"
    Write-Host " " $countimport " Fichiers à créer "
    Write-Host "---------------------"
    Write-Host ""

    return $arrOfFile

}

<#
    Fonction permettant de valider si tous les dossiers ont été créée

    Entrée: $base; Chemin de base du dossier (P:\xxxxxxxxx\)
    Sortie: Confirmation Console
#>
function validation {
    
    param($base)

    Write-Host ""
    Write-Host "---------------------"
    Write-Host " Validation en cours "
    Write-Host "---------------------"
    Write-Host ""

    $foldercount = (Get-ChildItem $base -Recurse).count
    $folderCreated = $importedFiles.count

    Write-Host ""
    Write-Host "---------------------"
    Write-Host " "$foldercount "/" $folderCreated " Ont été créés"
    Write-Host "---------------------"
    Write-Host ""

    if ($foldercount -eq $folderCreated) {
    "Dossier a bien été créée"
    } else {
        "Des erreurs sont survenue."
        pause
    }
    
}


#Initiation des variable
initVars

# Pour test
#$direction = "DGCNAT"

# Choix du menu pour la sélection de la DT
"Direction Disponible présentement: DGCNAT, DGO, DGBGI, DGE"
$direction = Read-Host "Nom de la direction (DGxxxxx): "

# choix du dossier à créée
$folder = Read-Host "Nom du dossier: "

# Sélection d'action selon le choix de la direction
switch($direction){


    # Si le choix est DGCNAT
    DGCNAT { 
    
        #définition du Path
        # $path = "\\mtq.min.intra\fic\QC\Espace Collaboratif\V5\DCNAT-Projets\"
        $path = "V:\projet"

        # Création de la Description
        $description = Read-Host "Description: "
        $a = "A) " + $description

        # Création du Path de base
        $folderconstruct = $path + "\" + $folder +"\"

    
        #------------    Création des répertoires    -------------------#


        # Création du dossier A) avec la description
  

        # Importation du fichier des répertoire avec la fonction importFoler
        $fileBaseDir = $dirRessource + "dgcnat.pproj"
    
    
        $importedFiles = importFolder -fileToImport $fileBaseDir

        # Création du dossier A) avec la description
        $importedFiles += $a

        # Création des répertoire avec la fonction createFolder
        createFolder -array $importedFiles -dossierBase $folderconstruct


        #Validation des dossiers créée.
        validation -base $folderconstruct


        #------------    Application des sécurité    -------------------#

        # Sécurité sur dossier de base
        setWrite -path "" -group U-GLOBAL-G-EC-QC-DCNAT-Projets-M
        setRead  -path "" -group U-GLOBAL-G-EC-QC-DCNAT-Projets-R

        # Sécurité pour CGID sur dossier de base. 
        setRead  -path "" -group U-DCNAT0-G-P_Livelink

        # Sécurité pour dossier AmenageTerritoire
        setFull  -path "AmenageTerritoire" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "AmenageTerritoire" -group U-DCNAT0-G-P_AmenageTerritoire
        setWrite -path "AmenageTerritoire" -group U-DCNAT0-G-P_ChefService-SIP

        # Sécurité pour dossier Arpentage
        setFull  -path "Arpentage" -group U-DCNAT0-G-P_Admin-SP_Arp
        setWrite -path "Arpentage" -group U-DCNAT0-G-P_Arpentage
        setWrite -path "Arpentage" -group U-DCNAT0-G-P_ChefService-SP

        # Sécurité pour dossier AssuranceQualite
        setWrite -path "AssuranceQualite" -group U-DCNAT0-G-P_AssuranceQualite-M

        # Sécurité pour dossier AvantProjet
        setFull  -path "AvantProjet" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "AvantProjet" -group U-DCNAT0-G-P_AvantProjet
        setWrite -path "AvantProjet" -group U-DCNAT0-G-P_ChefService-SIP

        # Sécurité pour dossier Chaussee
        setFull  -path "Chaussee" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "Chaussee" -group U-DCNAT0-G-P_Chaussee
        setWrite -path "Chaussee" -group U-DCNAT0-G-P_ChefService-SP

        # Sécurité pour dossier communication
        setFull  -path "Communication (Liaison partenaire)" -group U-DCNAT0-G-P_Admin-SIP
        setFull  -path "Communication (Liaison partenaire)" -group U-DCNAT0-G-P_Admin-SP_Arp
        setWrite -path "Communication (Liaison partenaire)" -group U-DCNAT0-G-P_Communication
        setRead  -path "Communication (Liaison partenaire)" -group U-DCNAT0-G-P_Admin-SP_Proj

        # Sécurité pour dossier Construction
        setFull  -path "Construction (#contrat)" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "Construction (#contrat)" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "Construction (#contrat)" -group U-DCNAT0-G-P_Construction

        # Sécurité pour dossier Eclairage
        setFull  -path "Eclairage" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "Eclairage" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "Eclairage" -group U-DCNAT0-G-P_Eclairage

        # Sécurité pour dossier EnrobeBitumineux
        setFull  -path "EnrobeBitumineux" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "EnrobeBitumineux" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "EnrobeBitumineux" -group U-DCNAT0-G-P_EnrobeBitume

        # Sécurité pour dossier Environnement
        setFull  -path "Environnement" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "Environnement" -group U-DCNAT0-G-P_ChefService-SIP
        setWrite -path "Environnement" -group U-DCNAT0-G-P_Environnement

        # Sécurité pour dossier FeuxCirculation
        setWrite -path "FeuxCirculation" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "FeuxCirculation" -group U-DCNAT0-G-P_FeuxCirculation

        # Sécurité pour dossier GestionProjet
        setRead  -path "GestionProjet" -group U-DCNAT0-G-P_ChefService-SIP
        setFull  -path "GestionProjet" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "GestionProjet" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "GestionProjet" -group U-DCNAT0-G-P_GestionProjet-SIP
        setWrite -path "GestionProjet" -group U-DCNAT0-G-P_GestionProjet-SP

        # Sécurité pour dossier Immobilier
        setFull  -path "Immobilier" -group U-DCNAT0-G-P_Admin-SP_Arp
        setWrite -path "Immobilier" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "Immobilier" -group U-DCNAT0-G-P_Immobillier

        # Sécurité pour dossier Paysage
        setFull  -path "Paysage" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "Paysage" -group U-DCNAT0-G-P_ChefService-SIP
        setWrite -path "Paysage" -group U-DCNAT0-G-P_Paysage
    
        # Sécurité pour dossier Photogrammetrie
        setFull  -path "Photogrammetrie" -group U-DCNAT0-G-P_Admin-SP_Arp
        setWrite -path "Photogrammetrie" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "Photogrammetrie" -group U-DCNAT0-G-P_Photogrammetrie
    
        # Sécurité pour dossier SecurCircSignal
        setFull  -path "SecurCircSignal" -group U-DCNAT0-G-P_Admin-SIP
        setWrite -path "SecurCircSignal" -group U-DCNAT0-G-P_ChefService-SIP
        setWrite -path "SecurCircSignal" -group U-DCNAT0-G-P_SecuCircSignal
    
        # Sécurité pour dossier ServicePublic
        setFull  -path "ServicePublic" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "ServicePublic" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "ServicePublic" -group U-DCNAT0-G-P_ServicePublic
    
        # Sécurité pour dossier SolMateriaux
        setFull  -path "SolMateriaux" -group U-DCNAT0-G-P_Admin-SP_Proj
        setWrite -path "SolMateriaux" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "SolMateriaux" -group U-DCNAT0-G-P_SolMateriaux

        # Sécurité pour dossier Structure
        setFull  -path "Structure" -group U-DCNAT0-G-P_Admin-SP_Proj
        setRead  -path "Structure" -group U-DCNAT0-G-P_ChefService-SP
        setWrite -path "Structure" -group U-DCNAT0-G-P_Structure


    }
    # Si le choix est DGO
    DGO {

        #définition du Path
        # $path = "\\SSTAO00-fic894\e$\Communs\Projet"
        $path = "V:\projet"


        # Création du Path de base
        $folderconstruct = $path + "\" + $folder +"\"

        #------------    Création des répertoires    -------------------#


        # Création du dossier A) avec la description
  

        # Importation du fichier des répertoire avec la fonction importFoler
        $fileBaseDir = $dirRessource + "dgo.pproj"
    
    
        $importedFiles = importFolder -fileToImport $fileBaseDir


        # Création des répertoire avec la fonction createFolder
        createFolder -array $importedFiles -dossierBase $folderconstruct


        #Validation des dossiers créée.
        validation -base $folderconstruct


        #------------    Application des sécurité    -------------------#

        setFull -path "" -group U-DO0000-D-L_SP_ADMIN

        setFull -path "" -group U-DO0000-G-ADMINISTRATION

        setRead -path "" -group U-DO0000-G-Utilisateurs
    
        setRead -path "Arpentage" -group U-DO0000-D-L_SP_ARPENTAGE

        setRead -path "AvantProjet" -group U-DO0000-D-L_SP_AVANTPROJET

        setRead -path "Chaussee" -group U-DO0000-D-L_SP_CHAUSSEE

        setRead -path "ServicePublique" -group U-DO0000-D-L_SP_SERVICEPUBLIC

        setRead -path "Structure" -group U-DO0000-D-L_SP_STRUCTURE


        }
    # Si le choix est DGBGI
    DGBGI {
    
    #définition du Path
    # $path = "\\sstao00-fic501\Commun\Projets\"
    $path = "V:\projet"

    # Création de la Description
    $description = Read-Host "Description du dossier A) : "
    $a = "A) " + $description

    # Création du Path de base
    $folderconstruct = $path + "\" + $folder +"\"

    
    #------------    Création des répertoires    -------------------#


    # Création du dossier A) avec la description
  

    # Importation du fichier des répertoire avec la fonction importFoler
    $fileBaseDir = $dirRessource + "dgbgi.pproj"
    
    
    $importedFiles = importFolder -fileToImport $fileBaseDir

    # Création du dossier A) avec la description
    $importedFiles += $a

    # Création des répertoire avec la fonction createFolder
    createFolder -array $importedFiles -dossierBase $folderconstruct


    #Validation des dossiers créée.
    validation -base $folderconstruct


    #------------    Application des sécurité    -------------------#


    setFull -path "" -group U-DBGI00-D-ADMINISTRATION

    setFull -path "" -group U-DBGI00-D-SEC-Communs-Projets-CT

    setRead -path "" -group U-DBGI00-D-SEC-Communs-Projets-L

    }
    # Si le choix est DGE
    DGE { 
    
        #définition du Path
        #$path = "\\sstao00-fic903\projets "
        $path = "V:\projet"


        # Création du Path de base
        $folderconstruct = $path + "\" + $folder +"\"

        #------------    Création des répertoires    -------------------#
  

        # Importation du fichier des répertoire avec la fonction importFoler
        $fileBaseDir = $dirRessource + "DGE.pproj"
    
    
        $importedFiles = importFolder -fileToImport $fileBaseDir


        # Création des répertoire avec la fonction createFolder
        createFolder -array $importedFiles -dossierBase $folderconstruct


        #Validation des dossiers créée.
        validation -base $folderconstruct


        #------------    Application des sécurité    -------------------#
    

        setFull  -path "" -group U-DE0000-D-L_SP_ADMIN

        setRead  -path "" -group GI6100
        setRead  -path "" -group GL5700

        setWrite -path "Arpentage" -group U-DE0000-D-L_SP_ARPENTAGE

        setWrite -path "AvantProjet" -group U-DE0000-D-L_SP_AVANTPROJET

        setWrite -path "Chaussee" -group U-DE0000-D-L_SP_CHAUSSEE
        setWrite -path "Chaussee" -group U-DE0000-D-L_SP_SECRETAIRE

        setWrite -path "Communication" -group U-DE0000-D-L_SP_COMMUNICATION

        setWrite "Eclairage" -group U-DE0000-D-L_SP_ECLAIRAGE
        setWrite "Eclairage" -group U-DE0000-D-L_SP_SECRETAIRE

        setWrite "Environnement" -group U-DE0000-D-L_SP_ENVIRONNEMENT

        setWrite "FeuxCirculation" -group U-DE0000-D-L_SP_FEUXCIRCULATION

        setWrite "FeuxClignotant" -group U-DE0000-D-L_SP_FEUXCLIGNOTANTS

        setWrite "GestionProjet" -group U-DE0000-D-L_SP_GESTIONPROJET

        setWrite "Immobilier" -group U-DE0000-D-L_SP_IMMOBILIER
        setWrite "Immobilier" -group U-DE0000-D-L_SP_SECRETAIRE

        setWrite "Paysager" -group U-DE0000-D-L_SP_PAYSAGER

        setWrite "Photogrammetrie" -group U-DE0000-D-L_SP_PHOTOGRAMMET

        setWrite "SecurCircSignal" -group U-DE0000-D-L_SP_SECURCIRSIGNAL

        setWrite "ServicePublic" -group U-DE0000-D-L_SP_SERVICEPUBLIC

        setWrite "SolMateriaux" -group U-DE0000-D-L_SP_SOLMATERIAUX

        setWrite "Structure" -group U-DE0000-D-L_SP_SECRETAIRE
        setWrite "Structure" -group U-DE0000-D-L_SP_STRUCTURE

    }

}

clearVars