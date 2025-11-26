resource "azurerm_virtual_network" "attacker" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "attacker"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "attacker" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.attacker.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "attacker" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "attacker"
  ip_configuration {
    subnet_id                     = azurerm_subnet.attacker.id
    name                          = "attacker"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.75"
  }
}

resource "azurerm_virtual_network_peering" "attacker_to_main" {
  name                      = "attacker-to-main"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.attacker.name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}

resource "azurerm_virtual_network" "main" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "network"
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_virtual_network_peering" "main_to_attacker" {
  name                      = "main-to-attacker"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = azurerm_virtual_network.attacker.id
}

resource "azurerm_subnet" "bastion" {
  name                 = "bastion"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "bastion" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "bastion"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "bastion" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "bastion"
  ip_configuration {
    subnet_id                     = azurerm_subnet.bastion.id
    name                          = "bastion"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.0.10"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_subnet" "servers" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  name                 = "servers"
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_network_interface" "dc" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "dc"
  ip_configuration {
    subnet_id                     = azurerm_subnet.servers.id
    name                          = "dc"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.10"
  }
}

resource "azurerm_network_interface" "wec" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "wec"
  ip_configuration {
    subnet_id                     = azurerm_subnet.servers.id
    name                          = "wec"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.20"
  }
}

resource "azurerm_network_interface" "velociraptor" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "velociraptor"
  ip_configuration {
    subnet_id                     = azurerm_subnet.servers.id
    name                          = "velociraptor"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.30"
  }
}

resource "azurerm_subnet" "workstations" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  name                 = "workstations"
  address_prefixes     = ["192.168.2.0/24"]
}

resource "azurerm_network_interface" "user" {
  location                        = var.location
  resource_group_name             = var.resource_group_name
  name                            = "user"
  ip_configuration {
    subnet_id                     = azurerm_subnet.workstations.id
    name                          = "user"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.2.69"
  }
}

resource "azurerm_network_security_group" "network" {
  name                = "network"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "AllowICMP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "network" {
  network_security_group_id = azurerm_network_security_group.network.id
  network_interface_id      = azurerm_network_interface.bastion.id
}