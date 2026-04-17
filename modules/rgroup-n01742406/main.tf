# Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg" {
  name     = "n01742406-RG"
  location = var.location
  tags     = var.common_tags
}