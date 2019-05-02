provider "helm" {
  install_tiller = false
  max_history = 20

  kubernetes {
    config_context = "${var.kubernetes_config_context}"
  }
}

resource "helm_release" "nginx_ingress" {
  count = "${contains(var.helm_releases, "nginx-ingress") ? 1 : 0}"

  name       = "nginx-ingress"
  namespace  = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "nginx-ingress"
  version    = "1.6.0"
  wait       = false

  set {
    name  = "podSecurityPolicy.enabled"
    value = "${var.kubernetes_pod_security_policy_enabled}"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.replicaCount"
    value = "${var.helm_nginx_ingress_replica_count}"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = "${element(var.kubernetes_ingress_addresses, count.index)}"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  /* TODO
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.stats.enabled"
    value = "true"
  }
  */

  # TODO: use the default instead? (nginx.ingress.kubernetes.io)
  set {
    name  = "controller.extraArgs.annotations-prefix"
    value = "ingress.kubernetes.io"
  }

  # For AWS: Use network load balancer instead of classic load balancer
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}

resource "helm_release" "cert_manager_crd" {
  count = "${contains(var.helm_releases, "cert-manager") ? 1 : 0}"

  name       = "cert-manager-crd"
  namespace  = "cert-manager-crd"
  chart      = "${path.module}/cert-manager-crd"
}

resource "helm_release" "cert_manager" {
  depends_on = ["helm_release.cert_manager_crd"]
  count = "${contains(var.helm_releases, "cert-manager") ? 1 : 0}"

  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io/"
  chart      = "cert-manager"
  version    = "0.7.0"

  set {
    name  = "global.rbac.create"
    value = "true"
  }

  set {
    name  = "securityContext.enabled"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  /* TODO: https://docs.cert-manager.io/en/latest/getting-started/webhook.html#running-on-private-gke-clusters set {
    name  = "webhook.enabled"
    value = "false"
  }
  */

}

resource "helm_release" "letsencrypt_issuer" {
  depends_on = ["helm_release.cert_manager"]
  count = "${contains(var.helm_releases, "letsencrypt-issuer") ? 1 : 0}"

  name       = "letsencrypt-issuer"
  namespace  = "cert-manager"
  chart      = "${path.module}/letsencrypt-issuer"

  set {
    name  = "email"
    value = "${var.taito_zone_devops_email}"
  }

}

resource "helm_release" "tcp_proxy" {
  count = "${contains(var.helm_releases, "tcp-proxy") ? 1 : 0}"

  name       = "tcp-proxy"
  namespace  = "tcp-proxy"
  chart      = "${path.module}/tcp-proxy"

  values = [
    "${file("tcp-proxy.yaml")}"
  ]

}
