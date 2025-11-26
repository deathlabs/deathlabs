# create the GPO
Import-GPO -BackupGpoName "Audit-Policy" -Path "C:\Vagrant\Group-Policy-Objects\Audit-Policy" -TargetName "Audit-Policy" -CreateIfNeeded

# link the GPO
New-GPLink -Name "Audit-Policy" -Target $(Get-ADDomain -Current LocalComputer).DistinguishedName