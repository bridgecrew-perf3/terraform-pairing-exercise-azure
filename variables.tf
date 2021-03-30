variable "resource_group_name" {
  description = "Name of rg to hold resources"
}

variable "location" {
  description = "Location to deploy resources"
  default = "North Europe"
}

variable "kv_name" {
  default = "testkvexpertthinking"
}