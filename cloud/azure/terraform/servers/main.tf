resource "azurerm_windows_virtual_machine" "dc" {
  name                      = "dc"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  size                      = "Standard_DS1_v2"
  admin_username            = var.local_admin_username
  admin_password            = var.local_admin_password
  network_interface_ids     = [
    var.dc_nic_id
  ]
  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    name                    = "dc"
  }
  source_image_reference {
    publisher               = "MicrosoftWindowsServer"
    offer                   = "WindowsServer"
    sku                     = "2022-Datacenter"
    version                 = "latest"
  }
  computer_name             = "XYZ9000DC01"
  timezone                  = "UTC"
  additional_unattend_content {
    setting      = "AutoLogon"
    content      = <<-EOF
      <AutoLogon>
        <Enabled>true</Enabled>
        <Username>${var.local_admin_username}</Username>
        <Password>
          <Value>${var.local_admin_password}</Value>
        </Password>
        <LogonCount>1</LogonCount>
      </AutoLogon>
    EOF
  }
  additional_unattend_content {
    setting      = "FirstLogonCommands"
    content      = <<-EOF
      <FirstLogonCommands>
        <SynchronousCommand>
          <Order>1</Order>
          <Description>Set PowerShell Execution Policy</Description>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Force"</CommandLine>
        </SynchronousCommand>
        <SynchronousCommand>
          <Order>2</Order>
          <Description>Configure WinRM</Description>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>powershell.exe -EncodedCommand ${textencodebase64(file("${path.module}/Enable-WinRM.ps1"), "UTF-16LE")}</CommandLine>
        </SynchronousCommand>
      </FirstLogonCommands>
    EOF
  }
}

resource "azurerm_windows_virtual_machine" "wec" {
  name                      = "wec"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  size                      = "Standard_DS1_v2"
  admin_username            = var.local_admin_username
  admin_password            = var.local_admin_password
  network_interface_ids     = [
    var.wec_nic_id
  ]
  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    name                    = "wec"
  }
  source_image_reference {
    publisher               = "MicrosoftWindowsServer"
    offer                   = "WindowsServer"
    sku                     = "2022-Datacenter"
    version                 = "latest"
  }
  computer_name             = "XYZ9000WEC1"
  timezone                  = "UTC"
  additional_unattend_content {
    setting                 = "AutoLogon"
    content                 = <<-EOF
      <AutoLogon>
        <Enabled>true</Enabled>
        <Username>${var.local_admin_username}</Username>
        <Password>
          <Value>${var.local_admin_password}</Value>
        </Password>
        <LogonCount>1</LogonCount>
      </AutoLogon>
    EOF
  }
  additional_unattend_content {
    setting      = "FirstLogonCommands"
    content      = <<-EOF
      <FirstLogonCommands>
        <SynchronousCommand>
          <Order>1</Order>
          <Description>Set PowerShell Execution Policy</Description>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Force"</CommandLine>
        </SynchronousCommand>
        <SynchronousCommand>
          <Order>2</Order>
          <Description>Configure WinRM</Description>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>powershell.exe -EncodedCommand ${textencodebase64(file("${path.module}/Enable-WinRM.ps1"), "UTF-16LE")}</CommandLine>
        </SynchronousCommand>
      </FirstLogonCommands>
    EOF
  }
}

resource "azurerm_linux_virtual_machine" "velociraptor" {
  name                            = "velociraptor"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_DS1_v2"
  admin_username                  = var.local_admin_username
  admin_ssh_key {
    username                      = var.local_admin_username
    public_key                    = file("~/.ssh/id_rsa.pub")
  }
  network_interface_ids           = [
    var.velociraptor_nic_id
  ]
  os_disk {
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
    name                          = "velociraptor"
  }
  source_image_reference {
    publisher                     = "Canonical"
    offer                         = "0001-com-ubuntu-server-jammy"
    sku                           = "22_04-lts"
    version                       = "latest"
  }
  computer_name                   = "XYZ9000VR01"
}
