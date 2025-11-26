resource "azurerm_marketplace_agreement" "attacker" {
  publisher = "kali-linux"
  offer     = "kali"        
  plan      = "kali-2023-4" # sku
}

resource "azurerm_linux_virtual_machine" "attacker" {
  name                   = "attacker"
  location               = var.location
  resource_group_name    = var.resource_group_name
  size                   = "Standard_DS1_v2"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "attacker" 
  }
  plan {
    publisher            = "kali-linux"
    product              = "kali"        # offer
    name                 = "kali-2023-4" # sku
  }
  source_image_reference {
    publisher            = "kali-linux"
    offer                = "kali"
    sku                  = "kali-2023-4"
    version              = "latest"
  }
  network_interface_ids  = [
    var.attacker_nic_id
  ]
  computer_name       = "attacker"
  disable_password_authentication = false
  admin_username      = var.attacker_username
  admin_password      = var.attacker_password
}