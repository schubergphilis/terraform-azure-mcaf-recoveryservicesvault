data "azurerm_user_assigned_identity" "this" {
  count = var.cmk_identity != null ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.cmk_identity)["resource_name"]
  resource_group_name = provider::azurerm::parse_resource_id(var.cmk_identity)["resource_group_name"]
}
