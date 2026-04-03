variable "project_name" {
  description = "Logical project name for tagging."
  type        = string
  default     = "expenseflow"
}

variable "prefix" {
  description = "Short naming prefix for Azure resources."
  type        = string
}

variable "environment" {
  description = "Target environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID used by Key Vault."
  type        = string
}

variable "key_vault_admin_object_ids" {
  description = "AAD object IDs that should administer the Key Vault."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space for the shared VNet."
  type        = list(string)
}

variable "aks_subnet_cidr" {
  description = "Subnet CIDR for AKS nodes."
  type        = string
}

variable "database_subnet_cidr" {
  description = "Subnet CIDR for PostgreSQL Flexible Server."
  type        = string
}

variable "kubernetes_version" {
  description = "AKS version to deploy."
  type        = string
}

variable "system_node_count" {
  description = "AKS system node count."
  type        = number
}

variable "system_node_vm_size" {
  description = "AKS node size."
  type        = string
}

variable "system_node_os_disk_size_gb" {
  description = "AKS node OS disk size."
  type        = number
  default     = 128
}

variable "acr_sku" {
  description = "Azure Container Registry SKU."
  type        = string
  default     = "Basic"
}

variable "log_analytics_sku" {
  description = "Log Analytics Workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "Log retention period."
  type        = number
  default     = 30
}

variable "storage_replication_type" {
  description = "Storage account replication type."
  type        = string
  default     = "LRS"
}

variable "receipts_container_name" {
  description = "Blob container name for receipts."
  type        = string
  default     = "receipts"
}

variable "postgres_version" {
  description = "PostgreSQL Flexible Server version."
  type        = string
  default     = "16"
}

variable "postgres_sku_name" {
  description = "PostgreSQL Flexible Server SKU."
  type        = string
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage allocation in MB."
  type        = number
}

variable "postgres_backup_retention_days" {
  description = "PostgreSQL backup retention."
  type        = number
  default     = 7
}

variable "postgres_zone" {
  description = "Availability zone for PostgreSQL."
  type        = string
  default     = "1"
}

variable "postgres_admin_username" {
  description = "PostgreSQL admin username."
  type        = string
  default     = "psqladmin"
}

variable "postgres_admin_password" {
  description = "Optional PostgreSQL admin password. Leave blank to generate one."
  type        = string
  default     = ""
  sensitive   = true
}

variable "postgres_database_name" {
  description = "Application database name."
  type        = string
  default     = "expenseflow"
}

variable "redis_sku_name" {
  description = "Azure Cache for Redis SKU."
  type        = string
}

variable "redis_family" {
  description = "Azure Cache for Redis family."
  type        = string
}

variable "redis_capacity" {
  description = "Azure Cache for Redis capacity."
  type        = number
}
