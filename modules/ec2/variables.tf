variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "EC2 instanceのSubnet ID"
  type        = string
}

variable "user_data" {
  type        = string
}
