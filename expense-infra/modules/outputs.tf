output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Resource group name."
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "AKS cluster name."
}

output "acr_name" {
  value       = azurerm_container_registry.main.name
  description = "Azure Container Registry name."
}

output "acr_login_server" {
  value       = azurerm_container_registry.main.login_server
  description = "Azure Container Registry login server."
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "Key Vault name."
}

output "storage_account_name" {
  value       = azurerm_storage_account.main.name
  description = "Storage account name."
}

output "receipts_container_name" {
  value       = azurerm_storage_container.receipts.name
  description = "Blob container used for receipts."
}

output "postgres_server_name" {
  value       = azurerm_postgresql_flexible_server.main.name
  description = "PostgreSQL Flexible Server name."
}

output "postgres_fqdn" {
  value       = azurerm_postgresql_flexible_server.main.fqdn
  description = "PostgreSQL Flexible Server FQDN."
}

output "postgres_database_name" {
  value       = azurerm_postgresql_flexible_server_database.application.name
  description = "Application database name."
}

output "redis_hostname" {
  value       = azurerm_redis_cache.main.hostname
  description = "Azure Cache for Redis hostname."
}

output "redis_ssl_port" {
  value       = azurerm_redis_cache.main.ssl_port
  description = "Azure Cache for Redis TLS port."
}
