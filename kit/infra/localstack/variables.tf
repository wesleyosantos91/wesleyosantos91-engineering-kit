variable "aws_region" {
  description = "Regiao AWS emulada no LocalStack."
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "Endpoint gateway do LocalStack."
  type        = string
  default     = "http://localhost:4566"
}
