output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_id" {
  value = module.vpc.vpc_id
}

output "game_endpoint_address" {
  value = module.vpc.vpc_id
}
