$Retries = 5
$Services = @(
    "NTDS", # Active Directory Domain Services
    "EventSystem", # COM+ Event System
    "RpcSs", # Remote Procedure Call
    "SamSs", # Security Accounts Manager
    "DFSR", # DFS Replication
    "DNS", # DNS Server
    "IsmServ", # Intersite Messaging
    "Kdc", # Kerberos Key Distribution Center
    "Adws" # Active Directory Web Services
)
do {
    Write-Output "Waiting 60 seconds for all required services to start..."
    $RequiredServicesHaveStarted = (Get-Service $Services | Where-Object { $_.Status -eq "Running"}).Count -eq 9
    $Retries--
} until ($RequiredServicesHaveStarted -or $Retries -eq 0)