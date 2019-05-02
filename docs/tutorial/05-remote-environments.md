# PART II: Infrastructure

> TODO: If zone does not yet exist, see chapter...
> TODO: Project configs not ok if zone has not yet been created

## 5. Remote environments

TODO describe environments:

* **f-NAME:** feature
* **local:** local development
* **dev:** development
* **test:** testing
* **stag:** staging
* **canary:** canary (runs side-by-side with production)
* **prod:** production

TODO hotfix branches

TODO existing playground project -> destroy environments first.

### 5.1. Create dev environment

Create the dev environment:

```shell
( EDIT taito-config.sh )       # No need to edit (dev is already enabled)
taito env apply:dev            # Create the dev environment
git push                       # Push some changes to the dev branch
```

Make sure it works ok:

```shell
taito open builds              # Watch it build and deploy automatically
taito open status:dev          # Check status of dev environment
taito open client:dev          # Open application GUI
taito info:dev                 # Show details for logging in
taito db connect:dev           # Connect to database
taito open storage:dev         # Open storage bucket
taito open logs:dev            # Open logs
```

The first CI/CD build will take some time. Subsequent builds are faster as they use a previous build as cache.

### 5.2. Enable automatic integration and e2e tests for dev environment

1) Enable `ci_exec_test` for `dev` environment in `taito-config.sh`:

    ```bash
    # NOTE: enable tests once you have implemented some integration or e2e tests
    ci_exec_test=true
    ```

2) Push the change to dev branch: `git push`
3) See build and test execution with `taito open builds`

### 5.3. Run integration and e2e tests manually againts the dev environment

TODO some notes about docker-compose-test.yaml -> Taito CLI is used as proxy to access dev database.

```bash
taito test:dev
```

### 5.4. Create test environment

Create the test environment:

```shell
EDIT taito-config.sh           # Add 'test' to 'taito_environments'
taito env apply:test           # Create the test environment
taito env merge:dev test       # Merge changes from dev to test
```

Make sure it works:

```shell
taito open builds              # Watch it build and deploy automatically
taito open status:test         # Check status of test environment
taito open client:test         # Open application GUI
```

### 5.5. Create production environment

Create the environment:

```
( EDIT taito-config.sh )       # No need to edit (prod is already configured)
taito env apply:prod           # Create the prod environment
taito env merge:test prod      # Merge changes from test to prod
```

Make sure it works:

```
taito open builds              # Watch it build and deploy automatically
taito open status:prod         # Check status of prod environment
taito open client:prod         # Open application GUI
```

> At this point your production environment already exists. However, before releasing it to the real end-users you need to do some additional tasks that are explained in chapter [9. Production setup](#09-production-setup.md).

### 5.6. Create canary environment

Canary environment is a special environment that uses production environment resources: databases, storage buckets, secrets and external services. That is, if you deploy your application to the canary environment, your application will run side-by-side with the production version of the application, and it will also use all the same resources.

NOTE: Since canary environment uses production resources, you don't need to run `taito env apply:canary` when creating the environment.

Create the canary environment:

```shell
EDIT taito-config.sh             # Add 'canary' to 'taito_environments'
taito env merge:test canary      # Merge changes from test to canary
```

Make sure it works:

```shell
taito open builds                # Watch it build and deploy automatically
taito open status:canary         # Check status of canary environment
taito open client:canary         # Open canary application GUI
taito open client:prod           # Open production application GUI
** Create some posts in the production app **
** Resfresh the posts page in the canary app -> you'll see the new posts **
```

And how this works exactly? Well, the canary environment is mapped to production resources in `taito-config.sh` with these lines:

```
# Environment mappings (for canary releases and A/B testing)
taito_env="${taito_env/canary/prod}" # canary -> prod
```

### 5.7. Deploy changes through multiple environments (dev -> canary)

```
git push                         # Push some changes to the dev branch
taito env merge:dev canary       # Merge changes: dev -> test -> canary
taito open builds                # See them build and deploy
```

### 5.8. Create a feature environment

```
TODO
```

### 5.9. Delete the feature environment

```
TODO
```

### 5.10. Revert application to the previous revision

```
taito deployment revert:prod
```

### 5.11. Deploy a specific version of the application

```
taito deployment deploy:dev 1.1.0
```

### 5.12 Make a hotfix for production

```
TODO
```

### 5.13. Debugging

```
taito open logs:dev              # Open logs of dev environment
taito logs:server:dev            # Tail logs of a container named 'worker'
taito shell:server:dev           # Start shell on a container named 'server'
taito exec:server:dev echo foo   # Execute a command inside the server container
```

TODO link: Stackdriver log filtering instructions

### 5.14. Some additional deployment commands

```
taito deployment start:dev        # Start ci build for dev environment manually
taito deployment cancel:dev       # Cancel an ongoing dev environment build
taito deployment build:worker:dev # Build and deploy worker container to dev env directly from local env
```

### TODO Something about advanced deployment options?

> Some of the advanced operations might require admin credentials (e.g. staging/canary/production operations). If you don't have an admin account, ask devops personnel to execute the operation for you.

Advanced features (TODO not all implemented yet):

* **Quickly deploy settings**: If you are in a hurry, you can deploy Helm/Kubernetes changes directly to an environment with the `taito deployment deploy:ENV`.
* **Quickly deploy a container**: If you are in a hurry, you can build, push and deploy a single container directly to server with the `taito deployment build:TARGET:ENV` command e.g. `taito deployment build:client:dev`.
* **Copy production data to staging**: Often it's a good idea to copy production database to staging before merging changes to the stag branch: `taito db copy between:prod:stag`, `taito storage copy between:prod:stag`. If you are sure nobody is using the production database, you can alternatively use the quick copy (`taito db copyquick between:prod:stag`), but it disconnects all other users connected to the production database until copying is finished and also requires that both databases are located in the same database cluster.
* **Feature branch**: You can create an environment also for a feature branch: `taito env apply:f-NAME`. The feature should reside in a branch named `feature/NAME`.
* **Revert application**: Revert application to the previous revision by running `taito deployment revert:ENV`. If you need to revert to a specific revision, check current revision by running `taito deployment revisions:ENV` first and then revert to a specific revision by running `taito deployment revert:ENV REVISION`. You can also deploy a specific version with `taito deployment deploy:ENV IMAGE_TAG|SEMANTIC_VERSION`.
* **Debugging CI builds**: You can build and start production containers locally with the `taito start --clean --prod` command. You can also run any CI build steps defined in cloudbuild.yaml locally with Taito CLI.

---

**Next:** [6. Environment variables and secrets](06-env-variables-and-secrets.md)
