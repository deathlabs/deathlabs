$NetworkId = "192.168.1.*"
$DnsServer = "192.168.1.5"
$InterfaceIndex = Get-NetIpAddress | Where-Object { $_.IpAddress -like $NetworkId } | Select-Object -ExpandProperty InterfaceIndex
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ($DnsServer)