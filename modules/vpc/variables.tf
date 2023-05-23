variable "availability_zones" {
  description = "Subnetのアベイラビリティゾーン"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "Public SubnetのCIDRブロック"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "Private SubnetのCIDRブロック"
  type        = list(string)
}

