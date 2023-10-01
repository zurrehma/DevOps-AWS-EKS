output "node_security_group_id" {
  description = "ID of worker security group to be used in worker instances."
  value       = module.eks.node_security_group_id
}
output "kubeconfig" {
  value = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_endpoint                 = module.eks.cluster_endpoint
    cluster_certificate_authority   = module.eks.cluster_certificate_authority[0].data
    cluster_token                   = module.eks.cluster_token
  })
}

output "context" {
  description = "All outputs of module"
  value       = module.eks
}