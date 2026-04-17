module "rgroup" {
  source      = "./modules/rgroup-n01742406"
  location    = var.location
  common_tags = var.common_tags
}

module "network" {
  source              = "./modules/network-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  depends_on          = [module.rgroup]
}

module "common" {
  source              = "./modules/common-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  depends_on          = [module.rgroup]
}

module "vmlinux" {
  source              = "./modules/vmlinux-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  subnet_id           = module.network.subnet_id
  storage_account_uri = module.common.sa_primary_blob_endpoint
  depends_on          = [module.network, module.common]
}

module "vmwindows" {
  source              = "./modules/vmwindows-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  subnet_id           = module.network.subnet_id
  storage_account_uri = module.common.sa_primary_blob_endpoint
  depends_on          = [module.network, module.common]
}

module "loadbalancer" {
  source              = "./modules/loadbalancer-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  linux_nic_ids       = module.vmlinux.vm_nic_ids
  depends_on          = [module.vmlinux]
}

# Skipped: Azure PostgreSQL Flexible Server hit InternalServerError during apply; not required by project rubric.
# module "database" {
#   source              = "./modules/database-n01742406"
#   resource_group_name = module.rgroup.resource_group_name
#   location            = var.location
#   common_tags         = var.common_tags
#   depends_on          = [module.rgroup]
# }

module "datadisk" {
  source              = "./modules/datadisk-n01742406"
  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  common_tags         = var.common_tags
  virtual_machine_ids = concat(module.vmlinux.vm_ids, module.vmwindows.vm_ids)
  depends_on          = [module.vmlinux, module.vmwindows]
}
# Root-level Ansible provisioner:
# must run AFTER both vmlinux (VMs + SSH bootstrap + inventory) and
# datadisk (data disks attached) are done — otherwise the datadisk role
# can't find /dev/disk/azure/scsi1/lun*.
resource "null_resource" "ansible_provisioner" {
  triggers = {
    vm_ids       = jsonencode(module.vmlinux.vm_ids)
    disk_names   = jsonencode(module.datadisk.disk_names)
    playbook_md5 = filemd5("${path.root}/ansible/n01742406-playbook.yml")
    roles_md5 = sha1(join("", [
      for f in fileset("${path.root}/ansible/roles", "**/*.yml") :
      filemd5("${path.root}/ansible/roles/${f}")
    ]))
  }

  provisioner "local-exec" {
    working_dir = "${path.root}/ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_FORCE_COLOR       = "True"
    }
    command = "ansible-playbook -i inventory n01742406-playbook.yml"
  }

  depends_on = [module.vmlinux, module.datadisk]
}
