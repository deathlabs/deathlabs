Import-Csv "C:\Vagrant\Configuration-Files\UserSet.csv" |
ForEach-Object {
    $Parameters = @{
        GivenName               = $_.GivenName
        Surname                 = $_.Surname
        Name                    = $($_.Surname + ", " + $_.GivenName)
        SamAccountName          = $_.SamAccountName 
        UserPrincipalName       = $($_.GivenName + "." + $_.Surname + "@evil.corp")
        Company                 = $_.Company
        Organization            = $_.Organization
        Description             = $_.Description
        EmployeeId              = $_.EmployeeId
        Path                    = "OU=Users,DC=Evil,DC=Corp"
        AccountPassword         = $(ConvertTo-SecureString -AsPlainText -Force "1qaz2wsx!QAZ@WSX")
        ChangePasswordAtLogon   = $true 
        Enabled                 = $true
    }

    New-AdUser @Parameters
}
