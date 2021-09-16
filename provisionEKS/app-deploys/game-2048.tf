resource "kubernetes_namespace" "game-2048" {
  metadata {
    name = "game-2048"
  }
}
resource "helm_release" "game-2048" {
  name         = "game-2048"
  chart        = "./charts/game-2048"
  namespace    = "game-2048"
  replace      = "true"
  force_update = "true"
  set {
    name  = "replace"
    value = "true"
  }

  timeout = 1200

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.network.outputs.cluster_name
  }

  set {
    name  = "ingress.enabled"
    value = true
  }
  depends_on = [helm_release.aws-load-balancer-controller, kubernetes_namespace.game-2048]
}
