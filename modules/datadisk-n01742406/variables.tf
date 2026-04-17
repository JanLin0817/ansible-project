variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "virtual_machine_ids" {
  type    = list(string)
  default = []
}