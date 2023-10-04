resource "kubernetes_manifest" "serviceaccount_kube_system_fluentd" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "fluentd"
      "namespace" = "kube-system"
    }
  }
}

resource "kubernetes_manifest" "clusterrole_fluentd" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "fluentd"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "namespaces",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_fluentd" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "fluentd"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "fluentd"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "fluentd"
        "namespace" = "kube-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "daemonset_kube_system_fluentd" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "DaemonSet"
    "metadata" = {
      "labels" = {
        "k8s-app" = "fluentd-logging"
        "version" = "v1"
      }
      "name" = "fluentd"
      "namespace" = "kube-system"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "k8s-app" = "fluentd-logging"
          "version" = "v1"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "iam.amazonaws.com/role" = "us-east-1a.staging.kubernetes.ruist.io-service-role"
          }
          "labels" = {
            "k8s-app" = "fluentd-logging"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "K8S_NODE_NAME"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "spec.nodeName"
                    }
                  }
                },
                {
                  "name" = "LOG_GROUP_NAME"
                  "value" = "${var.namespace}-${var.environment}-log-group"
                },
                {
                  "name" = "AWS_REGION"
                  "value" = "us-east-1"
                },
                {
                  "name" = "FLUENT_CONTAINER_TAIL_PARSER_TYPE"
                  "value" = "cri"
                },
                {
                  "name" = "FLUENT_CONTAINER_TAIL_EXCLUDE_PATH"
                  "value" = "/var/log/containers/ebs-csi-*,/var/log/containers/aws-node-*,/var/log/containers/coredns-*,/var/log/containers/kube*,/var/log/containers/fluentd*,/var/log/containers/ingress*"
                },
                {
                  "name" = "RETENTION_DAYS"
                  "value" = "30"
                },
              ]
              "image" = "fluent/fluentd-kubernetes-daemonset:v1-debian-cloudwatch"
              "name" = "fluentd"
              "resources" = {
                "limits" = {
                  "memory" = "200Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "200Mi"
                }
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/var/log"
                  "name" = "varlog"
                },
                {
                  "mountPath" = "/var/log/pods"
                  "name" = "dockercontainerlogdirectory"
                  "readOnly" = true
                },
              ]
            },
          ]
          "serviceAccount" = "fluentd"
          "serviceAccountName" = "fluentd"
          "terminationGracePeriodSeconds" = 30
          "tolerations" = [
            {
              "effect" = "NoSchedule"
              "key" = "node-role.kubernetes.io/control-plane"
            },
            {
              "effect" = "NoSchedule"
              "key" = "node-role.kubernetes.io/master"
            },
          ]
          "volumes" = [
            {
              "hostPath" = {
                "path" = "/var/log"
              }
              "name" = "varlog"
            },
            {
              "hostPath" = {
                "path" = "/var/log/pods"
              }
              "name" = "dockercontainerlogdirectory"
            },
          ]
        }
      }
    }
  }
}
