# Private Repo Secret 
resource "kubernetes_manifest" "secret_argocd_private_repo" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Secret"
    "metadata" = {
      "labels" = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
      "name" = "private-repo"
      "namespace" = "argocd"
    }
    data = {
        name: "cHJpdmF0ZS1yZXBvCg=="
        project: "ZGVmYXVsdA=="
        sshPrivateKey: "LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFNd0FBQUF0emMyZ3RaVwpReU5UVXhPUUFBQUNEbnVBQ2x2VmxJaHlDY2krZ2prV0M1T0EvKzY4QTI0c2Qwb3RTZWFUdHdZUUFBQUpEMTVGMWQ5ZVJkClhRQUFBQXR6YzJndFpXUXlOVFV4T1FBQUFDRG51QUNsdlZsSWh5Q2NpK2dqa1dDNU9BLys2OEEyNHNkMG90U2VhVHR3WVEKQUFBRUJyUEY3MzVOZi9tNEhURTZXU0JSc3k0T1pWaVoxa1pzS1Z0Wndrd2ttcTR1ZTRBS1c5V1VpSElKeUw2Q09SWUxrNApELzdyd0RiaXgzU2kxSjVwTzNCaEFBQUFER2x1Wm5KaFFHRnlaMjlqWkFFPQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K"
        type: "Z2l0"
        url: "Z2l0QGdpdGh1Yi5jb206RWF0V2l0aEF2YS9kdmVsb3AtaW5mcmFzdHJ1Y3R1cmUuZ2l0"
    }
  }
}
# AWS Secret Operator Configmap
resource "kubernetes_manifest" "secret_argocd_aws_secret_operator" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "name" = "QVdTLVNlY3JldC1PcGVyYXRvcg=="
      "project" = "ZGVmYXVsdA=="
      "type" = "aGVsbQ=="
      "url" = "aHR0cHM6Ly9jaGF0d29yay5naXRodWIuaW8vY2hhcnRz"
    }
    "kind" = "Secret"
    "metadata" = {
      "labels" = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
      "name" = "aws-secret-operator"
      "namespace" = "argocd"
    }
  }
}
## AWS Secret Operator Develoyment
resource "kubernetes_manifest" "application_argocd_aws_secret_operator" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "aws-secret-operator"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "name" = ""
        "namespace" = "kube-system"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "chart" = "aws-secret-operator"
        "helm" = {
          "parameters" = [
            {
              "name" = "region"
              "value" = "us-east-1"
            },
          ]
        }
        "path" = ""
        "repoURL" = "https://chatwork.github.io/charts"
        "targetRevision" = "0.2.4"
      }
      "syncPolicy" = {
        "automated" = {
          "prune" = true
          "selfHeal" = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "application_argocd_ava_server" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "cluster-addons"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "name" = ""
        "namespace" = "ingress-nginx"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "directory" = {
          "recurse" = true
        }
        "path" = "./k8-resources/cluster-addons"
        "repoURL" = "git@github.com:EatWithAva/dvelop-infrastructure.git"
        "targetRevision" = "master"
      }
      "syncPolicy" = {
          "automated" = [
            "prune=true",
            "selfHeal=true"
          ]  
        "syncOptions" = [
          "CreateNamespace=true",
        ]
      }
    }
  }
}