$Parameters = @{
    GivenName               = "Elliot"
    Surname                 = "Alderson"
    Name                    = "Alderson, Elliot" 
    SamAccountName          = "elliot.alderson.da" 
    UserPrincipalName       = "elliot.alderson.da@evil.corp" 
    Company                 = "Evil Corp"
    Organization            = "Allsafe Security"
    Description             = "Senior Cybersecurity Engineer"
    EmployeeId              = "1337"
    AccountPassword         = $(ConvertTo-SecureString -AsPlainText -Force "1qaz2wsx!QAZ@WSX")
    ChangePasswordAtLogon   = $true 
    Enabled                 = $true
}

New-ADUser @Parameters
Add-ADGroupMember -Identity "Domain Admins" -Members $Parameters["SamAccountName"]