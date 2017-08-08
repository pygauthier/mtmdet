
Import-Csv -Path “V:\porteecCorrection.csv” | ForEach {

        $Porte = $_.pathhome
        $RepRoot = $_.Nom
        $Target = $_.Lien

        $repEC = "V:\Porte\" + $Porte + "\" + "Répertoires Espace Collaboratif"

        $Shell = New-Object -ComObject WScript.Shell

        $Shortcut = $Shell.CreateShortcut($repEC + "\"+ $RepRoot +".lnk")
        $Shortcut.TargetPath = $Target
        $Shortcut.Save()

}