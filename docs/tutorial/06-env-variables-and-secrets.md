## 6. Environment variables and secrets

TODO describe:

- docker-compose.yaml
- scripts/helm.yaml
- scripts/helm-ENV.yaml

### 6.1. Define an environment variable: same value for all environments

Add the variable to docker-compose.yaml for local development:

```shell
environment:
  MY_VARIABLE: my_value
```

Add the variable to scripts/helm.yaml:

```shell
env:
  MY_VARIABLE: my_value
```

### 6.2. Define an environment variable: different value for each environment

Add the variable to docker-compose.yaml for local development:

```shell
environment:
  MY_VARIABLE: my_value
```

Add default value for the variable to scripts/helm.yaml:

```shell
env:
  MY_VARIABLE: my_value
```

Add environment specific value to `scripts/helm-ENV.yaml` file for such environments that do not use the default value:

```shell
env:
  MY_VARIABLE: my_value
```

### 6.3. Deploy a configuration changes without rebuilding

Make configuration changes to `scripts/helm*.yaml` files on your local disk, and then deploy the changes directly to different environments with the following commands:

```shell
taito deployment deploy:dev
taito deployment deploy:test
taito deployment deploy:prod
```

### 6.4. Define a secret

Add secret definition to `taito-project-config.sh`. Avoid undescores in secret names as they are not valid in Kubernetes:

```shell
taito_secrets="
  ${taito_project}-${taito_env}-my-secret.key:manual
"
```

You can use the following types in your secret definition:

- `random`: Randomly generated string.
- `manual`: Manually entered string.
- `file`: File. The file path is entered manually.
- `htpasswd`: htpasswd file that contains 1-N user credentials. User credentials are entered manually.
- `htpasswd-plain`: htpasswd file that contains 1-N user credentials. Passwords are stored in plain text. User credentials are entered manually.
- `csrkey`: Secret key generated for certificate signing request (CSR).

Add secret reference for Kubernetes in `helm.yaml`:

```shell
    secrets:
      MY_SECRET_KEY: ${taito_project}-${taito_env}-my-secret.key
```

Add secret reference for Docker Compose in `docker-compose.yaml`:

```shell
    secrets:
      - MY_SECRET_KEY
...
...
secrets:
  MY_SECRET_KEY:
    file: ./secrets/${taito_env}/${taito_project}-${taito_env}-my-secret.key

```

Set secret value for each environment:

```shell
taito env rotate my-secret
taito env rotate:dev my-secret
taito env rotate:test my-secret
taito env rotate:prod my-secret
```

### 6.5. User specific variables

`taito-user-config.sh`

---

**Next:** [7. Databases and files](07-databases-and-files.md)
