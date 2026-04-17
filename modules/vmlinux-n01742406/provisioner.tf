# Module-local half of the Phase I integration:
#   1. Wait for SSH on every Linux VM
#   2. Bootstrap python3.9 + fix EOL repos via bootstrap-python.sh
#   3. Render the Ansible inventory file from Terraform state
#
# The ansible-playbook call lives in the ROOT module so it can depend on
# module.datadisk (otherwise data disks aren't attached when Ansible tries
# to partition them).

locals {
  vm_keys_sorted = sort(keys(var.vm_instances))

  linux_hosts = [
    for i, k in local.vm_keys_sorted :
    {
      index     = i + 1
      key       = k
      name      = azurerm_linux_virtual_machine.vm[k].name
      public_ip = azurerm_public_ip.pip[k].ip_address
      fqdn      = azurerm_public_ip.pip[k].fqdn
    }
  ]

  ansible_dir    = "${path.root}/ansible"
  inventory_path = "${local.ansible_dir}/inventory"
}

resource "null_resource" "wait_for_ssh" {
  for_each = var.vm_instances

  triggers = {
    vm_id             = azurerm_linux_virtual_machine.vm[each.key].id
    bootstrap_version = "1"
  }

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip[each.key].ip_address
    user        = var.admin_username
    private_key = file(var.private_key_path)
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    script = "${path.root}/ansible/bootstrap-python.sh"
  }
}

resource "local_file" "ansible_inventory" {
  filename        = local.inventory_path
  file_permission = "0644"

  content = templatefile("${local.ansible_dir}/inventory.tmpl", {
    hosts            = local.linux_hosts
    ssh_user         = var.admin_username
    private_key_path = var.private_key_path
  })

  depends_on = [null_resource.wait_for_ssh]
}