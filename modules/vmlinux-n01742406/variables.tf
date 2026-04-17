variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "subnet_id" {
  type = string
}

variable "storage_account_uri" {
  type = string
}

variable "vm_instances" {
  type = map(string)
  default = {
    "vm1" = "n01742406-vm1"
    "vm2" = "n01742406-vm2"
    "vm3" = "n01742406-vm3"
  }
}

variable "admin_username" {
  type    = string
  default = "n01742406"
}

variable "public_key_path" {
  # default = "/Users/n01742406/.ssh/id_rsa.pub"
  default = "/Users/n01742406/.ssh/id_rsa_azure.pub"
}

variable "private_key_path" {
  # default = "/Users/n01742406/.ssh/id_rsa"
  default = "/Users/n01742406/.ssh/id_rsa_azure"
}

variable "ansible_playbook_name" {
  type    = string
  default = "n01742406-playbook.yml"
}