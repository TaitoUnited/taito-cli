## 10. Production setup

### 10.1. Backups and GDPR

Automatically by terraform.

### 10.2. Set resource limits and autoscaling

### 10.3. Performance testing

### 10.4. Security audit

### 10.5. Setup domain name

TODO: DV certificate automatically. For OV/EV certficate, see [Appendix F: SSL/TLS certificates](f-certificates).

### 10.7. Disable basic auth

Basic authentication is enabled in all environments by default to keep the environment hidden. You can disable the basic auth by setting `taito_basic_auth_enabled=false` for prod environment.

### 10.8. Setup uptime monitoring

Automatically by terraform.

---

**Next:** [11. Running in production](/tutorial/11-running-in-production)
