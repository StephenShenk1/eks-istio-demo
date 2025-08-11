# Simple EKS using terraform-aws-modules/eks/aws
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"
  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["eu-west-2a","eu-west-2b"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]
  enable_nat_gateway = true
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.26"
  subnets         = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  vpc_id          = module.vpc.vpc_id
  node_groups = {
    demo = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = [var.node_instance_type]
    }
  }
  tags = {
    "Project" = "eks-istio-demo"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
