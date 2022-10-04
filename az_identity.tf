# User Assigned Identities 
resource "azurerm_user_assigned_identity" "aid" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  name = "azgwidentity"

  tags = var.tags
}


resource "azurerm_role_assignment" "rgreader" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aid.principal_id
}
