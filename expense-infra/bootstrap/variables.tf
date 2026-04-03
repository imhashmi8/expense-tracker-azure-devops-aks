variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region for the Terraform state resources."
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Resource group name for Terraform state."
  type        = string
  default     = "expenseflow-tfstate-rg"
}

variable "storage_account_name" {
  description = "Exact storage account name for Terraform state. Must be globally unique, lowercase, and 3-24 characters long."
  type        = string
  default     = "expenseflowtfstate01"
}

variable "container_name" {
  description = "Blob container name for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags for bootstrap resources."
  type        = map(string)
  default = {
    project    = "expenseflow"
    managed_by = "terraform"
    purpose    = "tfstate"
  }
}
