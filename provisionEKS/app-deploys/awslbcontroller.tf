data "terraform_remote_state" "network" {
    backend = "s3"
    config = {
        bucket = "terraform-remote-state-bucket-for-my-task"
        key = "staging/terraform.tfstate"
        region = "eu-west-2"
    }
}
resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"

  wait    = true
  timeout = 1200


  set {
    name  = "clusterName"
    value = "${data.terraform_remote_state.network.outputs.cluster_name}"
  }

  set {
    name  = "ingress.enabled"
    value = false
  }

}
