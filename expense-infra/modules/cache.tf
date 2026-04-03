resource "azurerm_redis_cache" "main" {
  name                          = "${local.base_name}-redis"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  capacity                      = var.redis_capacity
  family                        = var.redis_family
  sku_name                      = var.redis_sku_name
  minimum_tls_version           = "1.2"
  non_ssl_port_enabled          = false
  public_network_access_enabled = true
  redis_version                 = 6
  tags                          = local.default_tags
}
