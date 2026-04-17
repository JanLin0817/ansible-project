output "vm_hostnames" {
  value = values(azurerm_linux_virtual_machine.vm)[*].name
}

output "vm_fqdns" {
  value = values(azurerm_public_ip.pip)[*].fqdn
}

output "vm_private_ips" {
  value = values(azurerm_network_interface.nic)[*].private_ip_address
}

output "vm_public_ips" {
  value = values(azurerm_public_ip.pip)[*].ip_address
}

output "vm_nic_ids" {
  value = values(azurerm_network_interface.nic)[*].id
}

output "vm_ids" {
  value = values(azurerm_linux_virtual_machine.vm)[*].id
}