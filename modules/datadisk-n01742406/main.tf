# Docs:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment
resource "azurerm_managed_disk" "disk" {
  count                = length(var.virtual_machine_ids)
  name                 = "datadisk-vm-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachment" {
  count              = length(var.virtual_machine_ids)
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = var.virtual_machine_ids[count.index]
  lun                = count.index
  caching            = "ReadWrite"
}