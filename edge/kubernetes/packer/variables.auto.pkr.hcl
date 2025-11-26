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

variable "iso_file" {
  type    = string
  default = null
}

variable "vm_id" {
  type    = string
  default = null
}

variable "vm_template_name" {
  type    = string
  default = null
}

variable "vm_template_description" {
  type    = string
  default = null
}

variable "vm_admin_username" {
  type    = string
  default = null
}

variable "vm_admin_password" {
  type    = string
  default = null
}

variable "vm_cores" {
  type    = string
  default = "2"
}

variable "vm_memory" {
  type    = string
  default = "4096"
}

variable "vm_disk_size" {
  type    = string
  default = "20G"
}
