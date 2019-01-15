## APPENDIX F: SSL/TLS certificates

Production environment uses a domain validated SSL/TLS certificate by default. It was acquired from Let's Encrypt when you deployed your application to the production environment the first time, and it will be renewed automatically every 3 months.

A domain validated (DV) certificate does not provide identity assurance and therefore it is not recommended for e-Commerce or online financial transactions. In addition, sites with an organization validated (OV) or an extended validation (EV) certificate may seem more trustworthy in the eyes of some users. Most users won't notice any difference if an OV certificate is used instead of a DV certificate. However, if an EV certificate is being used, the organization name and country are shown clearly on the address bar of the browser. Therefore many large organizations use EV certificates on their sites even though they are pricey and require extra effort.

#### 1. Create a certificate signing request (csr) and send it to CA

Add `tls.key:csrkey` secret for the production domain name in `taito-config.sh` file.

```
# OV certificate for production only
if [[ "${taito_env}" == "prod" ]]; then
  taito_secrets="
    ${taito_secrets}
    myapp-mydomain-com-1.tls.key:csrkey
  "
fi
```

> The `-1` suffix is a counter that can be used later to create a new secret if a new csr needs to be generated while the old certificate is still in use in production.

Create a private key and a certificate signing request with the following command. The private key will be stored to Kubernetes and the certificate signing request will be saved to your local disk.

```
taito env rotate:prod myapp-mydomain-com-1.tls.key
```

Send the `.csr` file to the Certificate Authority.

> TODO If someone just gave you the private key, you can store it by...

> TODO wildcard certificate naming --> x-myapp-comain-com

#### 2. Create a chained certificate file

You get a bunch of certificate files from the Certificate Authority. You should combine them in a correct order to get a chained certificate file that contains all of them. Some examples:

```
cat app_mydomain_com.crt TrustedSecureCertificateAuthority5.crt USERTrustRSAAddTrustCA.crt AddTrustExternalCARoot.crt > app_mydomain_com-chained.crt
```

https://medium.com/two-cents/certificate-chain-example-e37d68c3a3f0

#### 3. Save the chained certificate file to Kubernetes

Add `tls.crt:file` secret for the production domain name in `taito-config.sh` file.

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

Save the chained crt file to Kubernetes:

```
taito env rotate:prod myapp-mydomain-com-1.tls.crt
```

#### 4. Take the new certificate into use

Define `myapp-mydomain-com-1` secret for the production domain name in `helm-prod.yaml`:

```
acme-myapp:
  ingress:
    domains:
      - name: ${taito_domain}
        certSecret: myapp-mydomain-com-1
```

Either merge the change to master branch with `taito vc env merge: dev prod`, or deploy the configuration change directly to production:

```
taito deployment deploy:prod
```

#### 5. Renew the certificate

TODO

#### 6. Revert back to the default DV certificate

You can revert back to the default DV certificate just by removing the `certSecret` setting for the domain from `helm-prod.yaml`.
