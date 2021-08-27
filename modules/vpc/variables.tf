variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "name" {
  type    = string
  default = "sn-pulsar-vpc"
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}
