output "context" {
  description = "All outputs of module"
  value       = module.eks
}
output "configmap" {
  value = module.eks.aws_auth_configmap_yaml
}