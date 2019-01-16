## 10. Production setup

### 10.1. Backups and GDPR

Bucket versioning on/off, etc.

### 10.2. Set resource limits and autoscaling

### 10.3. Performance testing

### 10.4. Security audit

### 10.5. Setup domain name

TODO: DV certificate automatically. For OV/EV certficate, see [Appendix F: SSL/TLS certificates](f-certificates.md).

### 10.7. Disable basic auth

Basic authentication is enabled in all environments by default to keep the environment hidden. You can disable the basic auth by...

helm-prod.yaml:

```
acme-myapp:
  # Ingress
  ingress:
    basicAuth: false
```

### 10.8. Setup uptime monitoring

---

**Next:** [11. Running in production](11-running-in-production.md)
