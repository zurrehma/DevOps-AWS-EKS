apiVersion: v1
kind: Config
clusters:
- name: my-cluster
  cluster:
    server: ${cluster_endpoint}
    certificate-authority-data: ${cluster_certificate_authority}
contexts:
- name: my-cluster
  context:
    cluster: my-cluster
current-context: my-cluster
users:
- name: my-cluster

