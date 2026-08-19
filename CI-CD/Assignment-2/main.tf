terraform {
  required_version = ">= 1.0.0"
}

variable "environment" {
  type    = string
  default = "dev"
}

output "environment_name" {
  value = var.environment
}