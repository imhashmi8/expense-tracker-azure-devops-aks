module "platform" {
  source = "../../modules"

  project_name               = "expenseflow"
  prefix                     = "expenseflow"
  environment                = "dev"
  location                   = var.location
  tenant_id                  = var.tenant_id
  key_vault_admin_object_ids = var.key_vault_admin_object_ids
  postgres_admin_password    = var.postgres_admin_password

  vnet_address_space   = ["10.10.0.0/16"]
  aks_subnet_cidr      = "10.10.1.0/24"
  database_subnet_cidr = "10.10.2.0/24"

  kubernetes_version  = "1.29.7"
  system_node_count   = 1
  system_node_vm_size = "Standard_B4ms"

  acr_sku                  = "Basic"
  log_retention_in_days    = 30
  storage_replication_type = "LRS"

  postgres_sku_name      = "B_Standard_B1ms"
  postgres_storage_mb    = 32768
  postgres_database_name = "expenseflow"

  redis_sku_name = "Basic"
  redis_family   = "C"
  redis_capacity = 0

  tags = {
    cost_center = "learning"
    owner       = "Md Qamar Hashmi"
  }
}
