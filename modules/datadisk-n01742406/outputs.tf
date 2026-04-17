output "disk_names" {
  value = azurerm_managed_disk.disk[*].name
}