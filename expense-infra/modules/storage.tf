resource "azurerm_storage_account" "main" {
  name                            = "st${local.storage_name_base}${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = var.storage_replication_type
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  tags                            = local.default_tags

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "receipts" {
  name                  = var.receipts_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
