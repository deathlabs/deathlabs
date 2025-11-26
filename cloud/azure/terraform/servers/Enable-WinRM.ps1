# Change the firewall's network profile to Private
Set-NetConnectionProfile -NetworkCategory Private

# Enable PowerShell Remoting
Enable-PSRemoting -Force

# Configure WinRM server settings
Set-Item WSMan:\localhost\service\AllowUnencrypted -Value true 
Set-Item WSMan:\localhost\service\Auth\Basic -Value true

# Debug
New-Item -Type File -Path "C:\debug.log"