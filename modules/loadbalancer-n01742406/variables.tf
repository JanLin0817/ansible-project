variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "linux_nic_ids" {
  type = list(string)
}

variable "lb_name" {
  type    = string
  default = "n01742406-lb"
}