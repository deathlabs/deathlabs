# create the GPO
$Name = "Windows-Event-Forwarding"
$Collector = "wec1"
New-GPO -Name $Name -Comment "Configures domain-joined computers to forward Windows events to the domain Windows Event Collector."

# configure the GPO
$Key = 'HKLM\Software\Policies\Microsoft\Windows\EventLog\EventForwarding\SubscriptionManager'
$Value = 'Server=http://' + $Collector + ':5985/wsman/SubscriptionManager/WEC,Refresh=60'
Set-GPRegistryValue -Name $Name -Key $Key -Value $Value -Type "String"

# link the GPO
New-GPLink -Name $Name -Target $(Get-ADDomain -Current LocalComputer).DistinguishedName