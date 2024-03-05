resource "random_id" "prefix" {
  byte_length = 8
}

locals {
  resource_group = {
    name     = var.resource_group_name
    location = var.resource_group_location
  }
}

resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "test" {
  address_prefixes                               = ["10.52.0.0/24"]
  name                                           = "${random_id.prefix.hex}-sn"
  resource_group_name                            = local.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.test.name
  enforce_private_link_endpoint_network_policies = true
}

module "aks_without_monitor" {
  source  = "Azure/aks/azurerm"
  version = "8.0.0"

  prefix                 = "prefix2-${random_id.prefix.hex}"
  resource_group_name    = local.resource_group.name
  admin_username         = null
  azure_policy_enabled   = true
  disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  #checkov:skip=CKV_AZURE_4:The logging is turn off for demo purpose. DO NOT DO THIS IN PRODUCTION ENVIRONMENT!
  log_analytics_workspace_enabled   = false
  net_profile_pod_cidr              = "10.1.0.0/16"
  private_cluster_enabled           = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true
}
