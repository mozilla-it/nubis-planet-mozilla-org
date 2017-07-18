variable "account" {
  default = ""
}

variable "region" {
  default = "us-west-2"
}

variable "environment" {
  default = "stage"
}

variable "service_name" {
  default = "planet"
}

variable "ami" {}

variable "root_storage_size" {
  default = "16"
}

variable "instance_type" {
  default = "t2.medium"
}
