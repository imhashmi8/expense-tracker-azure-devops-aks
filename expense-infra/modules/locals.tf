locals {
  name_prefix       = lower(var.prefix)
  environment       = lower(var.environment)
  base_name         = "${local.name_prefix}-${local.environment}"
  storage_name_base = substr(lower(regexreplace("${var.prefix}${var.environment}", "[^a-zA-Z0-9]", "")), 0, 10)
  default_tags = merge(
    {
      environment = var.environment
      project     = var.project_name
      managed_by  = "terraform"
      workload    = "expenseflow"
    },
    var.tags
  )
  postgres_password = var.postgres_admin_password != "" ? var.postgres_admin_password : random_password.postgres_admin_password.result
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "random_password" "postgres_admin_password" {
  length           = 20
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}
