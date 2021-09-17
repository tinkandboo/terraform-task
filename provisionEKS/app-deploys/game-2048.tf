resource "kubernetes_namespace" "game-2048" {
  metadata {
    name = "game-2048"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on       = [kubernetes_namespace.game-2048, helm_release.aws-load-balancer-controller]
  destroy_duration = "30s"
}

# This resource will create (potentially immediately) after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds, kubernetes_namespace.game-2048, helm_release.aws-load-balancer-controller]
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
  depends_on = [helm_release.aws-load-balancer-controller]
}
