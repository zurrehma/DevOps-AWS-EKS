resource "null_resource" "extract_kubeconfig" {
  provisioner "local-exec" {
    command = "kubectl config view --minify --flatten > cluster.yaml"
  }
}
resource "null_resource" "set_kubeconfig_env" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=cluster.yaml"
  }
}

