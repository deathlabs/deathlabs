# ------------------------------------------
# Proxmox arguments.
# ------------------------------------------
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
  default = null
}

# ------------------------------------------
# Arguments for all nodes.
# ------------------------------------------
variable "vm_template_name" {
  type    = string
  default = null
}

variable "gateway_ip_address" {
  type    = string
  default = null
}

variable "cluster_subnet" {
  type    = string
  default = null
}

# ------------------------------------------
# Controller nodes.
# ------------------------------------------
variable "controller_name_prefix" {
  type    = string
  default = "controller"
}

variable "controller_socket_count" {
  type    = number
  default = 1
}

variable "controller_cores_count" {
  type    = number
  default = 4
}

variable "controller_memory_size" {
  type    = number
  default = 8192
}

variable "controller_disk_size" {
  type    = number
  default = 60
}

variable "controller_count" {
  type    = number
  default = 1
}

variable "controller_vm_id" {
  type    = number
  default = 200
}

variable "controller_ip_address" {
  type    = string
  default = null
}

# ------------------------------------------
# Worker nodes.
# ------------------------------------------

variable "worker_name_prefix" {
  type    = string
  default = "worker"
}

variable "worker_socket_count" {
  type    = number
  default = 1
}

variable "worker_cores_count" {
  type    = number
  default = 8
}

variable "worker_memory_size" {
  type    = number
  default = 16384
}

variable "worker_disk_size" {
  type    = number
  default = 120
}

variable "worker_count" {
  type    = number
  default = 1
}
