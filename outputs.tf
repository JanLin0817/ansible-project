output "resource_group_name" {
  value = module.rgroup.resource_group_name
}

output "virtual_network_name" {
  value = module.network.virtual_network_name
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "log_analytics_workspace_name" {
  value = module.common.log_analytics_workspace_name
}

# output "recovery_services_vault_name" {
#   value = module.common.recovery_services_vault_name
# }

output "storage_account_name" {
  value = module.common.storage_account_name
}

output "vm_hostnames" {
  value = module.vmlinux.vm_hostnames
}

output "vm_fqdns" {
  value = module.vmlinux.vm_fqdns
}

output "vm_private_ips" {
  value = module.vmlinux.vm_private_ips
}

output "vm_public_ips" {
  value = module.vmlinux.vm_public_ips
}

output "vmwindows_hostname" {
  value = module.vmwindows.vm_hostname
}

output "vmwindows_fqdn" {
  value = module.vmwindows.vm_fqdn
}

output "vmwindows_private_ip" {
  value = module.vmwindows.vm_private_ip
}

output "vmwindows_public_ip" {
  value = module.vmwindows.vm_public_ip
}

output "load_balancer_name" {
  value = module.loadbalancer.lb_name
}

output "load_balancer_public_ip" {
  value = module.loadbalancer.lb_public_ip
}

output "load_balancer_fqdn" {
  value = module.loadbalancer.lb_fqdn
}

# output "database_name" {
#   value = module.database.db_name
# }

output "data_disk_names" {
  value = module.datadisk.disk_names
}