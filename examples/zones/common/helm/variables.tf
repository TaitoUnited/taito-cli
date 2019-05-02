/* Zone settings */

variable "taito_zone_devops_email" {
  type = "string"
}

/* Kubernetes settings */

variable "kubernetes_config_context" {
  type = "string"
  default = ""
}

variable "kubernetes_ingress_addresses" {
  type = "list"
  default = [""]
}

variable "kubernetes_pod_security_policy_enabled" {
  type = "string"
  default = "true"
}

/* Helm settings */

variable "helm_releases" {
  type = "list"
  default = []
}

variable "helm_nginx_ingress_replica_count" {
  type = "string"
  default = "1"
}
