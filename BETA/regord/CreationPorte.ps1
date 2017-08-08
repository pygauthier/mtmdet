
Import-Csv -Path “V:\portemtl.csv” | ForEach {

        $Porte = "V:\Porte"
        $RepRoot = $_.Nom
        $Target = $_.Lien

        $root = $porte + "\" + $RepRoot
        New-Item $root -type directory
        $repApp = $root + "\" + "Répertoires Application"
        $repService = $root + "\" + "Répertoires Service"
        $repEspace = $root + "\" + "Répertoires Espace Collaboratif"


        $Shell = New-Object -ComObject WScript.Shell
        New-Item $RepApp -type directory
        New-Item $repService -type directory
        New-Item $repEspace -type directory

        $Shortcut = $Shell.CreateShortcut($repService + "\"+ $RepRoot +".lnk")
        $Shortcut.TargetPath = $Target
        $Shortcut.Save()

}