
variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = null
}

variable "resource_group_location" {
  type = string
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type    = string
}
