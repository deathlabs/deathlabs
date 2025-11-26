# create the GPO
$Name = "Wallpaper"
New-GPO -Name $Name -Comment "Sets the wallpaper to the company logo."

# create a share
New-Item -ItemType Directory -Path "C:\Share\"
New-SmbShare -Name "Share" -Path "C:\Share\" -FullAccess "Administrators" -ReadAccess "Everyone"

# copy the wallpaper to the guest
Copy-Item -Path "C:\Vagrant\Wallpapers\evil-corp-wallpaper.jpg" -Destination "C:\Share\Wallpaper.jpg"

# set the wallpaper path
$Key = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
Set-GPRegistryValue -Name $Name -Key $Key -ValueName $Name -Value "\\$env:COMPUTERNAME\Share\Wallpaper.jpg" -Type "String"

# set the wallpaper style
Set-GPRegistryValue -Name $Name -Key $Key -ValueName "WallpaperStyle" -Value "0" -Type "String"

# link the GPO to the domain root
New-GPLink -Name $Name -Target $(Get-ADDomain -Current LocalComputer).DistinguishedName