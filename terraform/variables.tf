variable "instance_type" {
  description = "AWS EC2 instance type"
  default     = "t3.2xlarge"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "servers" {
  description = "Amount of servers to be created, reads value from stdin."
}
