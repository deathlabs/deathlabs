resource "azurerm_linux_virtual_machine" "bastion" {
  name                            = "bastion"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_DS1_v2"
  admin_username                  = var.bastion_username
  admin_ssh_key {
    username                      = var.bastion_username
    public_key                    = file("~/.ssh/id_rsa.pub")
  }
  network_interface_ids           = [
    var.bastion_nic_id
  ]
  os_disk {
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
    name                          = "bastion"
  }
  source_image_reference {
    publisher                     = "Canonical"
    offer                         = "0001-com-ubuntu-server-jammy"
    sku                           = "22_04-lts"
    version                       = "latest"
  }
  computer_name                   = "XYZ9000BN01"
}
