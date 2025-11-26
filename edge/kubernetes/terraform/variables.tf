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

variable "vm_template_name" {
  type    = string
  default = null
}

variable "vm_name" {
  type    = string
  default = null
}
