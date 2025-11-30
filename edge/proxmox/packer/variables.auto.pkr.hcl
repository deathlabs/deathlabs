variable "pm_api_url" {
  type    = string
  default = null
}

variable "pm_api_token_id" {
  type    = string
  default = null
}

variable "pm_api_token_secret" {
  type      = string
  default   = null
  sensitive = true
}

variable "pm_target_node_name" {
  type    = string
  default = "hypervisor-01"
}

variable "iso_file_name" {
  type    = string
  default = "ubuntu-24.04.3-live-server-amd64.iso"
}

variable "vm_id" {
  type    = string
  default = 100
}

variable "vm_template_name" {
  type    = string
  default = "ubuntu-server-24.04"
}

variable "vm_template_description" {
  type    = string
  default = "Ubuntu Server 24.04"
}

variable "vm_admin_username" {
  type    = string
  default = null
}

variable "vm_admin_password" {
  type    = string
  default = null
}

variable "vm_socket_count" {
  type    = number
  default = 1
}

variable "vm_core_count" {
  type    = number
  default = 4
}

variable "vm_memory_gb_size" {
  type    = number
  default = 8
}

variable "vm_disk_gb_size" {
  type    = number
  default = 60
}

variable "cloud_init_server_ip_address" {
  type    = string
  default = "192.168.1.211"
  description = "The IP address Proxmox must use to reach the HTTP server started by Packer."
}

variable "cloud_init_server_port" {
  type    = number
  default = 8336
}
