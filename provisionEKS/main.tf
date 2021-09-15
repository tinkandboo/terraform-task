module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.18.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    ng1 = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_types = ["m4.large"]
      k8s_labels = {
        Environment = "task"
      }
    }
  }

  workers_additional_policies = [aws_iam_policy.worker_policy.arn]
}

resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy-${var.cluster_name}"
  description = "Worker policy for AWS LB controller"

  policy = file("iam-policy.json")
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

