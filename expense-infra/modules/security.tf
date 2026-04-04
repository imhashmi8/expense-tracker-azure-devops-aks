resource "azurerm_key_vault" "main" {
  name                          = "${substr(lower(replace(var.prefix, "/[^a-zA-Z0-9]/", "")), 0, 14)}${local.environment}kv${random_string.suffix.result}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  enable_rbac_authorization     = true
  public_network_access_enabled = true
  tags                          = local.default_tags
}

resource "azurerm_role_assignment" "key_vault_admins" {
  for_each             = toset(var.key_vault_admin_object_ids)
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}
