output "context" {
  description = "All outputs of module"
  value       = module.eks
}

output "role" {
  value = module.eks.eks_managed_node_groups
}