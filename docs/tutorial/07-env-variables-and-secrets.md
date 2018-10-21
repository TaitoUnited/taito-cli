## 7. Environment variables and secrets

TODO describe docker-compose.yaml, helm.yaml and helm-ENV.yaml

### 7.1. Define an environment variable: same value for all environments

Add the variable to docker-compose.yaml for local development:

```
environment:
  MY_VARIABLE: my_value
```

Add the variable to scripts/helm.yaml:

```
env:
  MY_VARIABLE: my_value
```

### 7.2. Define an environment variable: different value for each environment

Add the variable to docker-compose.yaml for local development:

```
environment:
  MY_VARIABLE: my_value
```

Add default value for the variable to scripts/helm.yaml:

```
env:
  MY_VARIABLE: my_value
```

Add environment specific value to `scripts/helm-ENV.yaml` file for such environments that do not use the default value:

```
env:
  MY_VARIABLE: my_value
```

### 7.3. Deploy a configuration changes without rebuilding

First make the configuration changes and push them to dev branch. Then deploy the configuration changes directly to different environments:

```
taito deployment deploy:stag
taito deployment deploy:prod
```

### 7.4. Define a secret

taito-config.sh:

```
export taito_secrets="
  ${taito_project}-${taito_env}-my-secret.key:manual
"
```

helm.yaml:

```
secrets:
  MY_SECRET_KEY: ${taito_project}-${taito_env}-my-secret.key
```

docker-compose.yaml:

```
environment:
  MY_SECRET_KEY: ${acme-myproject-dev-my-secret-key}
```

Create the secret for each environment:

```
taito env rotate:dev my-secret
taito env rotate:test my-secret
taito env rotate:prod my-secret
```

> TODO: How to use the same secret value for local and dev environment without committing it to git.

---

**Next:** [8. Databases and files](08-databases-and-files.md)