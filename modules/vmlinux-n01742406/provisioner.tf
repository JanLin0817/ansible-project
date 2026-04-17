resource "null_resource" "display_hostnames" {
  for_each = var.vm_instances

  triggers = {
    vm_id = azurerm_linux_virtual_machine.vm[each.key].id
  }

  provisioner "local-exec" {
    command = "echo done"
  }
}
