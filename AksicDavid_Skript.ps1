
<# Scriptname: AksicDavid_Skript
Author: David Aksic
Date: 2024-06-19
Version: 1.0
Description: Dateien Verschiebung und eventuell ordner Erstellung#> 


# Legt den Pfad zum Zielverzeichnis fest
$targetPath = "$env:USERPROFILE\Documents\Davids Dokumente"

# Erstellt das Zielverzeichnis, falls es nicht existiert
if (-not (Test-ath -Path $targetPath)) {
    New-Item -ItemType Directory -Path $targetPath
    Write-Output "Zielverzeichnis erstellt: $targetPath"
} else {
    Write-Output "Zielverzeichnis existiert bereits: $targetPath"
}

# Definiert den Pfad zum Downloads-Ordner
$downloadPath = "$env:USERPROFILE\Downloads"

# Holt das aktuelle Datum und die Uhrzeit, um Dateien zu prüfen, die nach diesem Zeitpunkt erstellt oder geändert wurden
$startTime = Get-Date
Write-Output "Überwachung von Dateien, die nach dem Startzeitpunkt erstellt oder geändert wurden: $startTime"

# Funktion zum Überprüfen und Verschieben neuer oder geänderter .docx-Dateien
function CheckAndMoveFiles {
    $docxFiles = Get-ChildItem -Path $downloadPath -Filter "*.docx" | Where-Object { $_.LastWriteTime -gt $startTime }
    foreach ($file in $docxFiles) {
        $destination = Join-Path -Path $targetPath -ChildPath $file.Name
        try {
            Move-Item -Path $file.FullName -Destination $destination -Force
            Write-Output "Verschobene Datei $($file.Name) nach $destination"
        } catch {
            Write-Output "Fehler beim Verschieben der Datei: $_"
        }
    }
}

# Überprüft alle vorhandenen .docx-Dateien im Downloads-Ordner, die nach dem Startzeitpunkt erstellt oder geändert wurden
Write-Output "Auflistung aller vorhandenen .docx-Dateien im Ordner $downloadPath, die nach dem Startzeitpunkt erstellt oder geändert wurden:"
CheckAndMoveFiles

# Hält das Skript im Hintergrund am Laufen und überprüft alle 3 Sekunden auf neue Dateien
while ($true) {
    Start-Sleep -Seconds 3
    CheckAndMoveFiles
    Write-Output "Überwachung läuft..."
}
