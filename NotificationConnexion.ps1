# Description: Envoi un email de notification lorsqu'un utilisateur se connecte à l'ordinateur

# Paramètres du serveur SMTP
$smtpServer = ""

# Adresse email de l'expéditeur et du destinataire
$smtpFrom = ""

# Adresse email du destinataire
$smtpTo = ""

# Objet du message
$messageSubject = "Notification de connexion"

# Mot de passe du compte (Remplacer ... par le mot de passe du compte)
$smtpPassword = ConvertTo-SecureString -String "..." -AsPlainText -Force

# Date et heure de connexion
$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", [System.Globalization.CultureInfo]::GetCultureInfo("fr-FR"))
$messageBody = "Heure de connexion : $timestamp"

# Utilisateur connecté
$loggedInUser = $env:USERNAME
$messageBody += "`nUtilisateur connecte : $loggedInUser"

# Nom de l'ordinateur
$computerName = $env:COMPUTERNAME
$messageBody += "`nNom de l'ordinateur : $computerName"

# Modèle de l'ordinateur
$computerModel = (Get-WmiObject -Class Win32_ComputerSystem).Model
$messageBody += "`nModele de l'ordinateur : $computerModel"

# Adresse IP
$ipAddress = (Invoke-WebRequest -Uri "http://ipinfo.io/ip").Content
$messageBody += "`nAdresse IP : $ipAddress"

# Adresse IP privé
$privateIpAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }).IPAddress[0]
$messageBody += "`nAdresse IP prive : $privateIpAddress"

# Adresse MAC
$macAddress = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty MacAddress
$messageBody += "`nAdresse MAC : $macAddress"

# Emplacement de l'ordinateur
$location = (Invoke-WebRequest -Uri "http://ipinfo.io").Content | ConvertFrom-Json
$messageBody += "`nEmplacement de l'ordinateur : $($location.city), $($location.region), $($location.country)"

# Localisation de l'ordinateur
$latitude = (Invoke-WebRequest -Uri "https://ipapi.co/latitude/").Content
$longitude = (Invoke-WebRequest -Uri "https://ipapi.co/longitude/").Content
$messageBody += "`nLocalisation de l'ordinateur : https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"

$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ("NotificationConnexion <" + $smtpFrom + ">")
$mailmessage.To.add($smtpTo)
$mailmessage.Subject = $messageSubject
$mailmessage.Body = $messageBody
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Port = 587
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($smtpFrom, $smtpPassword)
$smtp.Send($mailmessage)


