output "node_security_group_id" {
  description = "ID of worker security group to be used in worker instances."
  value       = module.eks.node_security_group_id
}

output "context" {
  description = "All outputs of module"
  value       = module.eks
}