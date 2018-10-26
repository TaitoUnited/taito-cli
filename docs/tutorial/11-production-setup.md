## 11. Production setup

### 11.1. Backups and GDPR

Bucket versioning on/off, etc.

### 11.2. Set resource limits and autoscaling

### 11.3. Performance testing

### 11.4. Security audit

### 11.5. Setup domain name

TODO now

### 11.6. Setup an organization validated (OV) or extended validation (EV) SSL certificate

Production environment uses a domain validated (DV) SSL certificate by default. It was acquired from Let's Encrypt when you deployed your application to the production environment the first time, and it will be renewed automatically every 3 months. However, a domain validated (DV) certificate does not provide identity assurance and therefore it is not recommended for e-Commerce or online financial transactions. In addition, sites with OV or EV certificate may seem more trustworthy in the eyes of some users, though most users won't notice any difference between a DV and OV certificate. In case of an EV certificate, however, the organization name and country is shown on the address bar of the browser. Therefore many large organizations use EV certificates on their sites even though they are pricey and require extra effort.

1.

```
# Custom certificate for production
if [[ "${taito_env}" == "prod" ]]; then
  taito_secrets="
    ${taito_secrets}
    ${taito_project}-${taito_env}-custom-ssl.tls.key:csrkey
  "
fi
```

```
taito env rotate:prod custom-ssl.tls.key
```

Send csr file

2.

https://medium.com/two-cents/certificate-chain-example-e37d68c3a3f0

cat app_mydomain_com.crt TrustedSecureCertificateAuthority5.crt USERTrustRSAAddTrustCA.crt AddTrustExternalCARoot.crt > app_mydomain_com-chained.crt

```
# Custom certificate for production
if [[ "${taito_env}" == "prod" ]]; then
  taito_secrets="
    ${taito_secrets}
    myapp-mydomain-com-1.tls.key:csrkey
    myapp-mydomain-com-1.tls.crt:file
  "
fi
```

IMPORTANT! CRT! NOT KEY!

```
taito env rotate:prod custom-ssl.tls.crt
```

helm-prod.yaml:

```
acme-myapp:
  # Ingress
  ingress:
    customCert: true
```

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
