# kube-secrets

A secret manager that reads secrets from Kubernetes when required. The plugin does not store any secrets to Kubernetes because the kubectl plugin stores project specific secrets to Kubernetes anyway and other secrets can be stored manually.
