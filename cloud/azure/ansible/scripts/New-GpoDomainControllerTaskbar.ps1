# import GPO
Import-GPO -BackupGpoName "Taskbar" -Path "C:\Vagrant\Group-Policy-Objects\Taskbar" -TargetName "Taskbar" -CreateIfNeeded

# copy XML file
Copy-Item -Path "C:\Vagrant\Configuration-Files\Taskbar.xml" -Destination "C:\Share\Taskbar.xml"

# link the GPO
$Target = 'ou=Domain Controllers,' + $(Get-ADDomain -Current LocalComputer).DistinguishedName
New-GPLink -Name "Taskbar" -Target $Target