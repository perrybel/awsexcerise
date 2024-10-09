variable "project_id" {
  description = "sodium-crane-436519-u1"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-custom-vpc"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}
