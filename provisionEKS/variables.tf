variable "availability_zones" {
  type = list(string)
  default = [
    "eu-west-2a",
  "eu-west-2b"]
  description = "AWS availability zones."
}

variable "region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  default     = "my-task-cluster"
  type        = string
}
