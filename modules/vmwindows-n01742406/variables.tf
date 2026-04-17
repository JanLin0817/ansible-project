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

variable "nb_count" {
  type    = number
  default = 1
}

variable "windows_name" {
  type    = string
  default = "n01742406-wvm"
}

variable "admin_username" {
  type    = string
  default = "n01742406"
}

variable "admin_password" {
  type    = string
  default = "@Aa12345678"
}