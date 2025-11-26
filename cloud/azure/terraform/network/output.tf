output "attacker_nic_id" {
  value = azurerm_network_interface.attacker.id
}

output "attacker_ip_address" {
  value = azurerm_network_interface.attacker.private_ip_address
}

output "bastion_nic_id" {
  value = azurerm_network_interface.bastion.id
}

output "bastion_ip_address" {
  value = azurerm_public_ip.bastion.ip_address
}

output "dc_nic_id" {
  value = azurerm_network_interface.dc.id
}

output "dc_ip_address" {
  value = azurerm_network_interface.dc.private_ip_address
}

output "velociraptor_nic_id" {
  value = azurerm_network_interface.velociraptor.id
}

output "velociraptor_ip_address" {
  value = azurerm_network_interface.velociraptor.private_ip_address
}

output "user_nic_id" {
  value = azurerm_network_interface.user.id
}

output "user_ip_address" {
  value = azurerm_network_interface.user.private_ip_address
}

output "wec_nic_id" {
  value = azurerm_network_interface.wec.id
}

output "wec_ip_address" {
  value = azurerm_network_interface.wec.private_ip_address
}
