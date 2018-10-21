## 6. Remote environments

TODO describe each environment
TODO also staging

### 6.1. Create dev environment

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
taito open app:dev             # Open application GUI
taito info:dev                 # Show details for logging in
taito db connect:dev           # Connect to database
taito open storage:dev         # Open storage bucket
taito open logs:dev            # Open logs
```

> The first CI/CD build will take some time. Subsequent builds are faster as they use the previous build as cache.

### 6.2. Enable automatic integration and e2e tests for dev environment

1) Enable `ci_exec_test` for `dev` environment in `taito-config.sh`:

```bash
# NOTE: enable tests once you have implemented some integration or e2e tests
export ci_exec_test=true
```

2) Push the change to dev branch: `git push`
3) See build and test execution with `taito open builds`

### 6.3. Run integration and e2e tests manually againts the dev environment

TODO some notes about docker-compose-test.yaml -> taito-cli is used as proxy to access dev database.

```bash
taito test:dev
```

### 6.4. Create test environment

Create the test environment:

```shell
EDIT taito-config.sh           # Add 'test' to 'taito_environments'
taito env apply:test           # Create the test environment
taito vc env merge: dev test   # Merge changes from dev to test
```

Make sure it works:

```shell
taito open builds              # Watch it build and deploy automatically
taito open status:test         # Check status of test environment
taito open app:test            # Open application GUI
```

### 6.5. Create production environment

Create the environment:

```
( EDIT taito-config.sh )       # No need to edit (prod is already configured)
taito env apply:prod           # Create the prod environment
taito vc env merge: test prod  # Merge changes from test to prod
```

Make sure it works:

```
taito open builds              # Watch it build and deploy automatically
taito open status:prod         # Check status of prod environment
taito open app:prod            # Open application GUI
```

> At this point your production environment already exists. However, before releasing it to the real end-users you need to do some additional tasks that are explained in chapter [9. Production setup](#09-production-setup.md).

### 6.6. Create canary environment

Canary environment is a special environment that uses production environment resources: databases, storage buckets, secrets and external services. That is, if you deploy your application to the canary environment, your application will run side-by-side with the production version of the application, and it will also use all the same resources.

NOTE: Since canary environment uses production resources, you don't need to run `taito env apply:canary` when creating the environment.

Create the canary environment:

```shell
EDIT taito-config.sh             # Add 'canary' to 'taito_environments'
taito vc env merge: test canary  # Merge changes from test to canary
```

Make sure it works:

```shell
taito open builds                # Watch it build and deploy automatically
taito open status:canary         # Check status of canary environment
taito open app:canary            # Open canary application GUI
taito open app:prod              # Open production application GUI
** Create some posts in the production app **
** Resfresh the posts page in the canary app -> you'll see the new posts **
```

And how this works exactly? Well, the canary environment is mapped to production resources in `taito-config.sh` with these lines:

```
# Environment mappings (for canary releases and A/B testing)
export taito_env="${taito_env/canary/prod}" # canary -> prod
```

### 6.7. Deploy changes through multiple environments (dev -> canary)

```
git push                         # Push some changes to the dev branch
taito vc env merge: dev canary   # Merge changes: dev -> test -> canary
taito open builds                # See them build and deploy
```

### 6.8. Create a feature environment

```
TODO
```

### 6.9. Delete the feature environment

```
TODO
```

### 6.10. Revert application to the previous revision

```
taito deployment revert:prod
```

### 6.11. Deploy a specific version of the application

```
taito deployment deploy:dev 1.1.0
```

### 6.12 Make a hotfix for production

```
TODO
```

### 6.13. Debugging

taito open logs:dev              # Open logs of dev environment
taito logs:server:dev            # Tail logs of a container named 'worker'
taito shell:server:dev           # Start shell on a container named 'server'
taito exec:server:dev echo foo   # Execute a command inside the server container

TODO link: Stackdriver log filtering instructions

### 6.14. Some additional deployment commands

taito deployment trigger:dev      # Trigger ci build for dev environment
taito deployment cancel:dev       # Cancel an ongoing dev environment build
taito deployment build:worker:dev # Build and deploy worker container to dev env directly from local env

---

**Next:** [7. Environment variables and secrets](07-env-variables-and-secrets.md)
