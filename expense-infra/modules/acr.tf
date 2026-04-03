resource "azurerm_container_registry" "main" {
  name                = "${substr(lower(regexreplace(var.prefix, "[^a-zA-Z0-9]", "")), 0, 18)}${local.environment}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = local.default_tags
}
