output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_id" {
  value = module.vpc.vpc_id
}


output "cluster_name" {
 value = var.cluster_name
}

output "cluster_auth" {
 value = data.aws_eks_cluster.cluster.certificate_authority.0.data
}

output "cluster_token" {
 value = data.aws_eks_cluster_auth.cluster.token
 sensitive = true
}

output "cluster_endpoint" {
 value = data.aws_eks_cluster.cluster.endpoint
}
