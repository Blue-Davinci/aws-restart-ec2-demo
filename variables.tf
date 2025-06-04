variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "ami" {
    description = "linux ami"
    type = string
    default = "ami-0c02fb55956c7d316"
}