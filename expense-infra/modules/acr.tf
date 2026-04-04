resource "azurerm_container_registry" "main" {
  name                = substr(lower(replace("${var.prefix}${var.environment}acr", "/[^a-zA-Z0-9]/", "")), 0, 50)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = local.default_tags
}
