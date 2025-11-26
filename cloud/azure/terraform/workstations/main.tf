resource "azurerm_windows_virtual_machine" "user" {
  name                      = "user"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  size                      = "Standard_DS1_v2"
  admin_username            = var.local_admin_username
  admin_password            = var.local_admin_password
  network_interface_ids     = [
    var.user_nic_id
  ]
  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    name                    = "user"
  }
  source_image_reference {
    publisher           = "MicrosoftWindowsDesktop"
    offer               = "Windows-11"
    sku                 = "win11-22h2-ent"
    version             = "latest"
  }
  computer_name             = "XYZ9000WK01"
  timezone                  = "UTC"
}