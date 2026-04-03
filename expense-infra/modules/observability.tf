resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.base_name}-log"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_in_days
  tags                = local.default_tags
}
