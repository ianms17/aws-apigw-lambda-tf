variable "project_name" {
  description = "Name of the project, used to tag resources"
  type        = string
}

variable "region" {
  description = "The region that you're VPC will be deployed into"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Size of the CIDR block for the private IPs of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "num_availability_zones" {
  description = "List of availability zones to use"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for the public subnet"
  type        = list(string)
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]
}

variable "private_compute_subnet_cidrs" {
  description = "List of CIDRs for the public subnet"
  type        = list(string)
  default = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]
}

variable "private_storage_subnet_cidrs" {
  description = "List of CIDRs for the public subnet"
  type        = list(string)
  default = [
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
}