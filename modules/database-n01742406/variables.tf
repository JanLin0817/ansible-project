variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "db_name" {
  type    = string
  default = "n01742406-db-server"
}

variable "admin_username" {
  type    = string
  default = "n01742406"
}

variable "admin_password" {
  type    = string
  default = "P@ssw0rd1234!"
}