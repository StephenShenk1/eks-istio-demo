variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-istio-demo"
}

variable "node_group_name" {
  type    = string
  default = "demo-ng"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}
