resource "azurerm_resource_group" "main" {
  name     = "deathlab"
  location = var.location
}

#module "attacker" {
#  source              = "./attacker"
#  location            = var.location
#  resource_group_name = azurerm_resource_group.main.name
#  attacker_nic_id     = module.network.attacker_nic_id
#  attacker_username   = var.attacker_username
#  attacker_password   = var.attacker_password 
#}

module "bastion" {
  source               = "./bastion"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  bastion_nic_id       = module.network.bastion_nic_id
  bastion_username     = var.bastion_username
  bastion_password     = var.bastion_password 
}

module "network" {
  source               = "./network"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
}

module "servers" {
  source               = "./servers"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  dc_nic_id            = module.network.dc_nic_id
  wec_nic_id           = module.network.wec_nic_id
  velociraptor_nic_id  = module.network.velociraptor_nic_id
  local_admin_username = var.local_admin_username
  local_admin_password = var.local_admin_password 
}

module "workstations" {
  source               = "./workstations"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  user_nic_id          = module.network.user_nic_id
  local_admin_username = var.local_admin_username
  local_admin_password = var.local_admin_password 
}