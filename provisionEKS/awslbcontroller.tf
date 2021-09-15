resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"

  wait    = true
  timeout = 1200


  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "ingress.enabled"
    value = false
  }

}
