# Docs:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension
resource "azurerm_availability_set" "avs" {
  name                         = "n01742406-avs"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                         = var.common_tags
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.vm_instances
  name                = "${each.value}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = each.value
  tags                = var.common_tags
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_instances
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.vm_instances
  name                  = each.value
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  availability_set_id   = azurerm_availability_set.avs.id

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  # Required for AzureMonitorLinuxAgent
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each = {}
  # for_each                   = var.vm_instances
  name                       = "NetworkWatcherAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each = {}
  # for_each                   = var.vm_instances
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.29"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}
