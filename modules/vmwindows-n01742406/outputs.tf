output "vm_hostname" {
  value = azurerm_windows_virtual_machine.vm[*].name
}

output "vm_fqdn" {
  value = azurerm_public_ip.pip[*].fqdn
}

output "vm_private_ip" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "vm_ids" {
  value = azurerm_windows_virtual_machine.vm[*].id
}