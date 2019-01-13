## 11. Production setup

### 11.1. Backups and GDPR

Bucket versioning on/off, etc.

### 11.2. Set resource limits and autoscaling

### 11.3. Performance testing

### 11.4. Security audit

### 11.5. Setup domain name

TODO: DV certificate automatically. For OV/EV certficate, see [Appendix F: SSL/TLS certificates](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/tutorial/f-certificates.md).

### 11.7. Disable basic auth

Basic authentication is enabled in all environments by default to keep the environment hidden. You can disable the basic auth by...

helm-prod.yaml:

```
acme-myapp:
  # Ingress
  ingress:
    basicAuth: false
```

### 11.8. Setup uptime monitoring

---

**Next:** [12. Running in production](12-running-in-production.md)
