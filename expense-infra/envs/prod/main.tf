module "platform" {
  source = "../../modules"

  project_name               = "expenseflow"
  prefix                     = "expenseflow"
  environment                = "prod"
  location                   = var.location
  tenant_id                  = var.tenant_id
  key_vault_admin_object_ids = var.key_vault_admin_object_ids
  postgres_admin_password    = var.postgres_admin_password

  vnet_address_space   = ["10.20.0.0/16"]
  aks_subnet_cidr      = "10.20.1.0/24"
  database_subnet_cidr = "10.20.2.0/24"

  kubernetes_version          = "1.29.7"
  system_node_count           = 3
  system_node_vm_size         = "Standard_D4s_v5"
  system_node_os_disk_size_gb = 128

  acr_sku                  = "Standard"
  log_retention_in_days    = 90
  storage_replication_type = "ZRS"

  postgres_sku_name              = "GP_Standard_D2s_v3"
  postgres_storage_mb            = 65536
  postgres_backup_retention_days = 14
  postgres_database_name         = "expenseflow"

  redis_sku_name = "Standard"
  redis_family   = "C"
  redis_capacity = 1

  tags = {
    cost_center = "production"
    owner       = "Md Qamar Hashmi"
  }
}
