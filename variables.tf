variable "common_tags" {
  type = map(string)
  default = {
    Project        = "CCGC 5502 Automation Project"
    Name           = "chunI.lin"
    ExpirationDate = "2024-12-31"
    Environment    = "Project"
  }
}

variable "location" {
  type    = string
  default = "Canada Central"
}