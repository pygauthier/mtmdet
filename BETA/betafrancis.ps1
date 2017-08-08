<#Version 1.9.2
But : Gestion des dossier.
Entrée : Varriable
Createur : Pierre-Yves Gauthier
Date : 2017-05-05

Liste des versions:
1.0 création
1.1 Correction Try{}Catch{} dans l'option 4
1.2 Ajout de l'Option 5 Accès PLN - 2017/03/15
1.3 Ajout d'un popup - 2017/04/27
1.4 Ajout du V: DCNAT
1.5 Ajout de l'option 5 et modification de l'option PLN pour le numéro 6 - 2017/06/27
1.6 Ajout du groupe de mise en cache dans l'option 1 - 2017/07/04
1.7 Ajout d'un deuxième choix pour l'option PNL - 2017/07/07
1.8 Modification de l'option qui ne permet plus de créée des codes NT avec des espaces.
1.9 Ajout de la Gestion des Espace Collaboratif Avancé (GECA)
1.9.1 Ajout de l'invocation du courriel d'ajout réseaux.
1.9.2 Ajout de l'utilisateur dans son groupe D-MTQ000-G-Intranet_MonUnite-****
#>


# Nettoyage de la fênetre de powershell
Clear-Host

#Initiation des variables Global

#Choix de l'opération à faire tant que le choix n'est pas valide
$Operation = ""
#Nom d'utilisateur a donner les accès
$User = ""
# Résponse Menu
$Menu = ""


# Début du menu
Write-Host "Veuillez choisir une des options suivante"
Write-Host ""
Write-Host "1 - Création Dossier Personnel (V:\)"
Write-Host "2 - Création Dossier DFS (Service, Espace Collaboratif, Application)"
Write-Host "3 - Liste la sécurité d'un dossier"
Write-Host "4 - Liste la sécurité d'un dossier et ses membres"
Write-Host "5 - Liste la sécurité d'un dossier et Ajoute un membre"
Write-Host "6 - Ajout d'un utilisateur au Système PLN"
Write-Host ""
$Menu = Read-Host "Numéro de l'option: "

Switch($Menu){

    1 { 
    
                    <# Array de texte #>
            $text = @("Code NT de l'utilisateur","QC, MTL, DCNAT","Entrée Invalide. Veuillez choisir","Ouverture du répertoire: ","Ajout du group de la Porte Unique","Ajout du group de DFS à ","`n","=================================","","Groupe du service en écriture de l'utilisateur")

            <# Définition du domaine #>
            $Domain = "mtq.min.intra"

            <# Configuration de la sécurité à appliquer #>
            $OU = "OU=_" + $GR + ",OU=_FIC,OU=_Groupes Globaux,OU=GLOBAL,DC=MTQ,DC=MIN,DC=INTRA"


            <# Définition des groups de sécurité DFS #>
            $DfsQC = "U-GLOBAL-G-SEC-QC-Employés-LIST"
            $DfsMTL = "U-GLOBAL-G-SEC-MTL-Employés-LIST"
            $PorteQC = "U-GLOBAL-G-GUI-GPO-PORTE_UNIQUE_700RL-QC"
            $PorteMTL = "U-GLOBAL-G-GUI-GPO-PORTE_UNIQUE_500RL"
            $MiseEnCache = "U-GLOBAL-G-GPO-OUTLOOK-CACHE-DO"


            <# Définition du répertoire de base #>
            $PathRoot = "\\"+$Domain+"\fic\"

            <# Initialisation des variables #>
            $PathV = ""
            $UserLocationPath = ""
            $UserService = ""

            <# Obtention du code NT #>
            $User = Read-Host $text[0]
            $User = $User.replace(' ','')
            <# Obtention de la localisation de l'utilisateur #>
            $UserLocation = Read-Host $text[1]
			
			#Cherche extensionAttribute2 de l'utilisateur
			$EA2 = (get-aduser $User -Properties *).extensionAttribute2

			#Trouve le groupe D-MTQ000-G-Intranet_MonUnite-**** de l'utilisateur
			$groupe = "D-MTQ000-G-Intranet_MonUnite-"+$EA2

			#Ajoute l'utilisateur dans son groupe D-MTQ000-G-Intranet_MonUnite-****
			try {Add-ADGroupMember $groupe -members $User}
			catch {Write-Host "Un erreur est survenue ou le compte est déjà membre du groupe $groupe"}
			Write-Host "L'utilisateur a été ajouté dans le groupe " $groupe
	

            #Entrée du Path
            $fullpath = Read-Host "Path complet du service"

            if ($fullpath -eq ""){
 
                Write-Host $text[7]
                Write-Host $text[8]
                write-host "Aucune sécurité à lister" -BackgroundColor Red -ForegroundColor Black
                Write-Host $text[8]
                }
            else {
                Write-Host $text[7]
                Write-Host $text[8]
            #Extraction de la sécurtié du répertoire
            (get-acl "$fullpath").access | Select IdentityReference #, FileSystemRights
                Write-Host $text[8]
                Write-Host $text[7]
            }

            <# Obtention du service de l'utilisateur de l'utilisateur #>
            $UserService = Read-Host $text[9]
            $UserService = $UserService.replace(' ','')


            <# Assignation du répertoire de localisation + Ajout du groupe d'autorisation du DFS #>
            Switch ($userLocation){
            QC {$UserLocationPath = "qc"}
            QC {Write-Host $text[8]}
            QC {Write-Host $text[7]}
            QC {Write-Host $text[8]}
            QC {Add-ADGroupMember $PorteQC -members $User}
            QC {Write-Host $text[4] $User -BackgroundColor Green -ForegroundColor Black}
            QC {Write-Host $text[8]}
            QC {Write-Host $text[7]}
            QC {Write-Host $text[8]}
            QC {Add-ADGroupMember $DfsQC -members $User}
            QC {Write-Host $text[5] $User -BackgroundColor Green -ForegroundColor Black}
            QC {Write-Host $text[8]}
            QC {Write-Host $text[7] ; break}
            DCNAT {$UserLocationPath = "qc"}
            DCNAT {Write-Host $text[8]}
            DCNAT {Write-Host $text[7]}
            DCNAT {Write-Host $text[8]}
            DCNAT {Write-Host $text[4] $User -BackgroundColor Green -ForegroundColor Black}
            DCNAT {Write-Host $text[8]}
            DCNAT {Write-Host $text[7]}
            DCNAT {Write-Host $text[8]}
            DCNAT {Add-ADGroupMember $DfsQC -members $User}
            DCNAT {Write-Host $text[5] $User -BackgroundColor Green -ForegroundColor Black}
            DCNAT {Write-Host $text[8]}
            DCNAT {Write-Host $text[7] ; break}
            MTL {$UserLocationPath = "mtl"}
            MTL {Write-Host $text[8]}
            MTL {Write-Host $text[7]}
            MTL {Write-Host $text[8]}
            MTL {Add-ADGroupMember $PorteMTL -members $User}
            MTL {Write-Host $text[4] $User -BackgroundColor Green -ForegroundColor Black}
            MTL {Write-Host $text[8]}
            MTL {Write-Host $text[7]}
            MTL {Write-Host $text[8]}
            MTL {Add-ADGroupMember $DfsMTL -members $User}
            MTL {Write-Host $text[5] $User -BackgroundColor Green -ForegroundColor Black}
            MTL {Write-Host $text[8]}
            MTL {Write-Host $text[7] ; break}
            CIGC {$UserLocationPath = "mtl"}
            CIGC {Write-Host $text[8]}
            CIGC {Write-Host $text[7]}
            CIGC {Write-Host $text[8]}
            CIGC {Add-ADGroupMember $PorteMTL -members $User}
            CIGC {Write-Host $text[4] $User -BackgroundColor Green -ForegroundColor Black}
            CIGC {Write-Host $text[8]}
            CIGC {Write-Host $text[7]}
            CIGC {Write-Host $text[8]}
            CIGC {Add-ADGroupMember $DfsMTL -members $User}
            CIGC {Write-Host $text[5] $User -BackgroundColor Green -ForegroundColor Black}
            CIGC {Write-Host $text[8]}
            CIGC {Write-Host $text[7] ; break}
            default {$text[2] + " " + $text[1]; break}
            "" {$text[2] + " " + $text[1]; break}
            }

            <# Vérification pour traitement des bons volume #>
            Switch($UserLocationPath){

            <# Vérification de la première lettre du cote NT pour assignation du volume pour Québec #>
            qc{Switch($User)
            {
            {$User.Substring(0,1) -match("a")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("b")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("c")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("d")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("e")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("f")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("g")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("h")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("i")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("j")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("k")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("l")}{$PathVolume = "v3"; break}
            {$User.Substring(0,1) -match("m")}{$PathVolume = "v3"; break}
            {$User.Substring(0,1) -match("n")}{$PathVolume = "v3"; break}
            {$User.Substring(0,1) -match("o")}{$PathVolume = "v3"; break}
            {$User.Substring(0,1) -match("p")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("q")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("r")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("s")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("t")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("u")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("v")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("w")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("x")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("y")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("z")}{$PathVolume = "v4"; break}
            }; break}

            <# Vérification de la première lettre du cote NT pour assignation du volume pour Montréal #>
            mtl{Switch($User)
            {
            {$User.Substring(0,1) -match("a")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("b")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("c")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("d")}{$PathVolume = "v1"; break}
            {$User.Substring(0,1) -match("e")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("f")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("g")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("h")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("i")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("j")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("k")}{$PathVolume = "v2"; break}
            {$User.Substring(0,1) -match("l")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("m")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("n")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("o")}{$PathVolume = "v4"; break}
            {$User.Substring(0,1) -match("p")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("q")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("r")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("s")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("t")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("u")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("v")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("w")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("x")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("y")}{$PathVolume = "v5"; break}
            {$User.Substring(0,1) -match("z")}{$PathVolume = "v5"; break}
            }; break }


            <# Assignation du volume pour la CIGC #>
            cigc {
            $UserLocationPath = "mtl";$PathVolume = "v3"; break}
            }

            <# Assignation de la sécurité du Service #>

            if ($UserService -eq ""){
 
                Write-Host $text[7]
                Write-Host $text[8]
                write-host "Aucune sécurité à assignée" -BackgroundColor Red -ForegroundColor Black
                Write-Host $text[8]
                }
             else {

                 Add-ADGroupMember $UserService -members $User
                Write-Host $text[7]
                Write-Host $text[8]
                 write-host "Utilisateur " $User "A été ajouté au groupe" $UserService -BackgroundColor Green -ForegroundColor Black
                Write-Host $text[8]
                Write-Host $text[7]

             }

             <# Ajout du groupe de mise en cache #>
             Add-ADGroupMember $MiseEnCache -members $User
             Write-Host $text[7]
             Write-Host $text[8]
             Write-Host "L'utilisateur a été ajouté au groupe de mise en cache"
             Write-Host $text[8]
             

            <# Création du path complet pour le répertoire  #>
            $PathV = $PathRoot + $UserLocationPath + "\Usager\" + $PathVolume + "\" + $User
            Write-Host $text[8]


            <# Notification du Path #>
            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Le répertoire a été créé: "
            write-host $User V:$PathV
            Write-Host $text[8]


            <# Création du répertoire #>
            Write-Host $text[7]
            Write-Host $text[8]
            New-Item $PathV -ItemType Directory
            Write-Host $text[8]

            <# Ajout du répertoire et assignation à la lettre V #>
            Set-ADUSER $User -HomeDrive "V:" -HomeDirectory $PathV

            # Ajustement de la sécurité
            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Début ajustement de la Sécurité" $PathV -BackgroundColor Cyan -ForegroundColor Black
            Write-Host $text[8]
            Write-Host $text[7]
            # get permissions
            $acl = Get-Acl -Path $PathV

            # add a new permission
            $GroupeMMTQ = 'MTQ\' + $User
            $permission = $GroupeMMTQ, 'Modify', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
            $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission
            $acl.SetAccessRule($rule)

            # set new permissions
            $acl | Set-Acl -Path $PathV



            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Ajustement de la Sécurité terminé" $PathV -BackgroundColor Green -ForegroundColor Black
            Write-Host $text[8]
            Write-Host $text[7]


            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Traitement terminé" $PathV -BackgroundColor Green -ForegroundColor Black
            Write-Host $text[8]
            Write-Host $text[7]

            if($userLocation -eq "DCNAT"){
            Write-HosT "Traitement terminé."
            }
            Else{

            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Ouverture du courriel LiveLink" $PathV -BackgroundColor Yellow -ForegroundColor Black
            Write-Host $text[8]
            Write-Host $text[7]
            Invoke-Item "\\mtq.min.intra\fic\QC\Espace Collaboratif\V2\DSOC-CMI\Procédures du CMI\05 Accès\Powershell\Livelink.oft"

            Write-Host $text[7]
            Write-Host $text[8]
            Write-Host "Code NT: " $User
            Write-Host $text[8]
            Write-Host $text[7]

            $wshell = New-Object -ComObject Wscript.Shell
            $wshell.Popup("Change le Code Utilisateur TATA !",0,"Done",0x1)
            }
            ; Break}
    2 { #Importation du modue Active Directory + 
            Import-Module ActiveDirectory
            Do {$Folder = Read-Host -Prompt 'Nom du répertoire'} while ($Folder -eq "")
            Do {$Volume = Read-Host -Prompt 'Nom du volume V(1,2,3,4,5)'} while ((1..5) -notcontains $Volume)
            Do {$DEST = Read-Host -Prompt 'Destination, QC ou MTL'} while ($DEST.ToUpper() -ne "QC" -And $DEST.ToUpper() -ne "MTL")
            Do {$Do = Read-Host -Prompt 'Nom du dossier - (1=Application, 2=Espace Collaboratif, 3=Service)'} while ((1..3) -notcontains $Do)

            switch ($Do) 
                { 
                    1 {$Dossier = 'Application'} 
                    2 {$Dossier = 'Espace Collaboratif'} 
                    3 {$Dossier = 'Service'} 
                }

            if ($Dossier -EQ 'Application') {$GR = 'AP'}
            if ($Dossier -EQ 'Espace Collaboratif') {$GR = 'EC'}
            if ($Dossier -EQ 'Service') {$GR = 'SE'}




            $Path = '\\mtq.min.intra\fic\' + $DEST + '\' + $Dossier + '\V' + $Volume + '\'
            $FolderPath = $Path + $Folder  

            $GroupeLecture = 'U-GLOBAL-G-' + $GR + '-' + $DEST.ToUpper() + '-' + $Folder + '-R'
            $GroupeModif = 'U-GLOBAL-G-' + $GR + '-' + $DEST.ToUpper() + '-' + $Folder + '-M'
            $OU = "OU=_" + $GR + ",OU=_FIC,OU=_Groupes Globaux,OU=GLOBAL,DC=MTQ,DC=MIN,DC=INTRA"


            $DescriptionL = 'Sécurité en lecture pour le projet ' + $Folder 
            $DescriptionM = 'Sécurité en modification ' + $Folder 
            $GroupeLMTQ = 'MTQ\' + $GroupeLecture
            $GroupeMMTQ = 'MTQ\' + $GroupeModif

            # create new folder
            $null = New-Item -Path $FolderPath -ItemType Directory
                Write-Host "`n"
                Write-Host "================================="
                Write-Host "Création du dossier " $Folder
                Write-Host "================================="
                Write-Host "`n"



            # create new group
            New-ADGroup -Name $GroupeLecture -SamAccountName $GroupeLecture -GroupCategory Security -GroupScope Global -DisplayName $GroupeLecture -Path $OU -Description $DescriptionL
            New-ADGroup -Name $GroupeModif -SamAccountName $GroupeModif -GroupCategory Security -GroupScope Global -DisplayName $GroupeModif -Path $OU -Description $DescriptionM
                Write-Host "`n"
                Write-Host "================================="
                Write-Host "Création des groupe de sécurité"
                Write-Host "`n"
                Write-Host "Lecture: " $GroupeLecture -BackgroundColor Yellow -ForegroundColor Black
                Write-Host "`n"
                Write-Host "Écriture: " $GroupeModif -BackgroundColor Yellow -ForegroundColor Black
                Write-Host "`n"
                Write-Host "================================="
                Write-Host "`n"

            Start-Sleep -s 50

            # get permissions
            $acl = Get-Acl -Path $FolderPath
                Write-Host "`n"
                Write-Host "================================="
                Write-Host "Début Ajustement de la Sécurité" -BackgoundColor Green -ForegroundColor Black
                Write-Host "================================="
                Write-Host "`n"

            # add a new permission
            #$permission = $GroupeLMTQ,'fullcontrol','allow'
            $permission = $GroupeLMTQ, 'ReadAndExecute', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
            #$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
            $acl.SetAccessRule($rule)

            # set new permissions
            $acl | Set-Acl -Path $FolderPath


            # add a new permission
            $permission = $GroupeMMTQ, 'Modify', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
            $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission
            $acl.SetAccessRule($rule)

            # set new permissions
            $acl | Set-Acl -Path $FolderPath

                Write-Host "`n"
                Write-Host "================================="
                Write-Host "Fin de l'ajustement de la Sécurité" -BackgoundColor Green -ForegroundColor Black
                Write-Host "================================="
                Write-Host "`n"

            # afficher le chemain du dossier
                Write-Host "`n"
                Write-Host "================================="
                Write-Host "Path" $FolderPath
                Write-Host "================================="
                Write-Host "Ouverture de la porte unique"
                Write-Host "================================="
                Invoke-Item "\\mtq.min.intra\fic\QC\Espace Collaboratif\V3\Porte Unique"


            # ajout du d'une ligne dans le fichier des répertoires: 
                $demande = Read-Host "Numéro de la demande de service: "
                $responsable = Read-Host "Nom du responsable: "
                $gestionnaire = Read-Host "Nom du gestionnaire signataire: "
                $lien = $FolderPath
                $groupem = $GroupeModif
                $groupel = $GroupeLecture
                $quota = Read-Host "Quota désiré (GO): "
                $date = Get-Date -format d
                $creator = $env:UserName

                $file = "\\mtq.min.intra\fic\QC\Service\V2\DSOC\Création de répertoires\espace_collabo.geca"
                $newRow = New-Object PsObject -Property @{ demande = $demande ; responsables = $responsable ; gestionnaire = $gestionnaire ; lien = $lien ; groupem = $groupem ; grouper = $groupel ; quota = $quota ; date = $date ; createur = $creator}


                $newRow| Export-Csv $file -Append -Encoding Unicode -Force


                ; Break}
    3 { #Entrée du Path
        $fullpath = Read-Host "Path complet a lister"
        #Extraction de la sécurtié du répertoire
        (get-acl "$fullpath").access | Select IdentityReference, FileSystemRights
        ; Break}
    4 { 
        #Initialisation de l'indentation
        $indent = ""

        #Entrée du Path
        $fullpath = Read-Host "Path complet a lister"

        #Extraction de la sécurtié du répertoire
        $acl = @(get-acl -Path "$fullpath").access | Select IdentityReference #, FileSystemRights

        #Export to CSV
        $acl | Export-Csv -Path "acl_export.csv" -NoTypeInformation

        #Affiche Résultat CSV
        Import-Csv -Path "acl_export.csv"

        $file = import-csv -Path "acl_export.csv" 
         $file |% { 
            $_.IdentityReference = $_.IdentityReference.replace("BUILTIN\","")
            $_.IdentityReference = $_.IdentityReference.replace("MTQ\","")
            $_.IdentityReference = $_.IdentityReference.replace("AUTORITE NT\","")
            $_.IdentityReference = $_.IdentityReference.replace("Syst?me","")
            $_.IdentityReference = $_.IdentityReference.replace("Administrateurs","")
            $_.IdentityReference = $_.IdentityReference.replace("IdentityReference","")
            } 
    


         $file | Export-Csv -Path "acl_export2.csv"

          (get-content -Path "acl_export2.csv") | Foreach-Object {
                    $_ -replace '"', ''} | 
                    set-content -Path "acl_export3.txt"

  
        $fileFinal = get-content -Path "acl_export3.txt" 



        #Loop pour sortir les membres de chaque groupe
        for ($i=0; $i -lt $fileFinal.length; $i++){
            $fileFinal[$i]
                function printLoop
                {
                    #Paramètre d'entrée : Groupe a extraire
                    param( $groups )
                    $groupContent = Get-ADGroupMember $groups | Sort-Object ObjectClass,Name,SamacountName
                    $indent = $indent + "`t"
                     #Boucle pour éclater les sous-groupes
                     foreach($G in $groupContent)
                        {
                            if ($G.ObjectClass -ccontains "group")
                             {
                            Write-Host "$indent"$G.Name
                            printLoop -groups $G
                        }
                            elseif ($G.ObjectClass -ccontains "user")
                        {
                            Write-Host "$indent"$G.Name
                        }
                        }

                }

        #Appel initial de la fonction
        Try{
            printLoop -groups $fileFinal[$i]
            }Catch { $ErrorMessage = $_.Exception.Message}
           } 
           
         # set-content -Path "EXPORT_GROUP_AND_MEMBER.txt"
           Remove-Item -Path "acl_export.csv"
           Remove-Item -Path "acl_export2.csv"
           Remove-Item -Path "acl_export3.txt"
           ; Break}
    5 {
    
        # Initionation des varribles.
        $fullpath = ""
        $SecurityGroup = ""
        $User = ""
        $g = ""

        Try{

        #Entrée du Path
        $fullpath = Read-Host "Path complet a lister"

        #Extraction de la sécurtié du répertoire
        (get-acl "$fullpath").access | Select IdentityReference

        Write-Host "`n`n"
        # Récupération du nom du groupe
        $SecurityGroup = Read-Host "Nom du groupe à ajouté"

        Write-Host "`n`n"
        $User = Read-Host "CodeNT de l'utilisateur"

        $g =  Get-ADGroupMember -Identity $SecurityGroup| select -ExpandProperty sAMAccountName
        #Loop de vérification si l'utilisateurs est dans le groupe demandé.
        If ($g -contains $User ) {

                #écrire le code nt du user avec ;
                Write-Host "`n`n"
                Write-Host "L'utilisateur $user est déjà dans le groupe."


            }

        #Si l'utilisateur n'est pas dans le groupe.
            Else {


            #Ajout de l'utilisateur dans le groupe.
            Add-ADGroupMember $SecurityGroup -Members $user


            # Validation que l'opération a réussi
            $g =  Get-ADGroupMember -Identity $SecurityGroup| select -ExpandProperty sAMAccountName

            #Loop de vérification si l'utilisateurs à été ajouté groupe demandé.
                If ($g -contains $User ) {

                    #écrire le code nt du user avec ;
                    Write-Host "`n`n"
                    Write-Host "L'utilisateur $user a été ajouté avec succès."

                    $message = "Voulez-vous envoyer le courriel ?"
                    $titre = "Information"
                    $Icon = "64"
                    $btn = "YesNo"
                    $msgbox = [System.Windows.Forms.MessageBox]::Show($Message, $Titre , $Btn, $Icon)

                    switch  ($msgbox) {

                      'Yes' {

                      write-host "Ouverture du courriel en cours"

                      Invoke-Item "\\mtq.min.intra\fic\QC\Espace Collaboratif\V2\DSOC-CMI\Procédures du CMI\05 Accès\Powershell\Acces_reseaux.oft"
 
                      }

                      'No' { write-host "Traitement terminé" }

                      'Cancel' { write-host "Traitement terminé" }

                      }

                    

                }

                #Si l'utilisateur n'est pas dans le groupe.
                Else {

                   Write-host " Une erreur est survenue pour ajouter $user dans $SecurityGroup”
    
   

                  }
             }

         }
 
         # Gestion des erreurs
         Catch { 
                  $ErrorMessage = $_.Exception.Message
                  Write-Host "Une erreur est survenue validé vos données" -BackgroundColor Red -ForegroundColor Gray
                }

        ; Break}
    6 {
        #Emplacement du fichier XLS de suivi des comptes
        $fichierXLS	= "\\mtq\min\Donnees\PLN\Plan\Administration_PLN\Sécurité DocumentsPLN_GroupesGlobaux.xls"
		#Nom du groupe de sécurité pour PLN
		$groupWrite = "D-MTQ000-G-PLAN-ECRITURE-FCH004"
        $groupRead = "U-MTQ000-G-PLN-Plan-RenoDWG_Lecture"

		#Entrée du nom d'utilisateur
		$user = read-Host "Nom d'utilisateur"
        
        Do {$Do = Read-Host -Prompt 'Lecture(1) ou Écriture(2)'} while ((1..2) -notcontains $Do)

        switch($Do){
                    1{$group = $groupRead}
                    2{$group = $groupWrite}
                    }
		#Ajoute le compte dans le groupe de sécurité.
		try {Add-ADGroupMember $group -members $user
               Write-Host "L'utilisateur $user a été ajouté à $group"
               Get-ADuser clarocque -Properties departmentNumber
               Get-Date -format d

                }
		catch {Write-Host "Un erreur est survenue ou le compte est déjà membre du groupe $group"}

        Invoke-Item $fichierXLS
		
		; Break}

}

