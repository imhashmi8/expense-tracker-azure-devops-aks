variable "subscription_id" {
  description = "Azure subscription ID for the prod environment."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID."
  type        = string
}

variable "key_vault_admin_object_ids" {
  description = "AAD object IDs to grant Key Vault Administrator."
  type        = list(string)
  default     = []
}

variable "location" {
  description = "Azure region for production."
  type        = string
  default     = "Central India"
}

variable "postgres_admin_password" {
  description = "Optional override for PostgreSQL admin password."
  type        = string
  default     = ""
  sensitive   = true
}
