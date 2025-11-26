Install-WindowsFeature DNS, AD-Domain-Services -IncludeManagementTools

$Parameters = @{
    DomainName                    = "evil.corp"
    InstallDns                    = $True
    SafeModeAdministratorPassword = $(ConvertTo-SecureString -AsPlainText -Force "1qaz2wsx!QAZ@WSX")
    NoRebootOnCompletion          = $True
    Force                         = $True
}

Install-ADDSForest @Parameters