Set objShell = WScript.CreateObject("WScript.Shell")
' Remplacer "..." par le chemin du script à exécuter
objShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File "...", 0, False
Set objShell = Nothing