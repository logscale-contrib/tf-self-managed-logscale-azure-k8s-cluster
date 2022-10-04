data "azuread_client_config" "current" {}

# Create an application
resource "azuread_application" "app" {
  display_name = "${var.resource_group_name}-aks"
}

# Create a service principal
resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

# Create Service Principal password
resource "azuread_service_principal_password" "app" {
  #end_date             = "2299-12-30T23:00:00Z" # Forever
  #end_date_relative = "10000d"
  service_principal_id = azuread_service_principal.app.id
}


# resource "azurerm_role_assignment" "ra1" {
#   scope                = azurerm_subnet.kubesubnet.id
#   role_definition_name = "Network Contributor"
#   principal_id         = azuread_service_principal.app.object_id

# }

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_user_assigned_identity.aid.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_service_principal.app.object_id
}

# resource "azurerm_role_assignment" "ra3" {
#   scope                = azurerm_application_gateway.network.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.app.object_id
# }

