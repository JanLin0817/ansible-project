# Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
resource "azurerm_postgresql_flexible_server" "db" {
  # single instance is deprecated
  name                   = var.db_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  zone                   = "1"

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"

  tags = var.common_tags
}