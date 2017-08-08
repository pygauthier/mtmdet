$printers = Get-WmiObject -Class Win32_Printer

$serveur1 = "\\Sinfra0-imp001"
$serveur2 = "\\sinfra0-imp002"

ForEach ($print in $printers){
    if ($print.SystemName -eq "$serveur1" -or $print.SystemName -eq "$serveur2")
    {
        $print.delete()
    }
}