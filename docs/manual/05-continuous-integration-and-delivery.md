## 5. Continuous integration and delivery

Taito-cli is designed so that in most cases your CI/CD tool needs only to execute a bunch of taito-cli commands without any arguments to get the job done. Everything is already configured in taito-config.sh, and taito-cli provides support for various infrastructures by plugins. You can also run any of the steps manually from command line using *Taito CLI*. A typical CI/CD process would consist of the following steps:

```
# Prepare build
taito build prepare:$BRANCH

# Prepare artifacts for deployment in parallel
parallel:
- taito artifact prepare:client:$BRANCH $COMMIT_SHA
- taito artifact prepare:server:$BRANCH $COMMIT_SHA

# Deploy the changes to target environment
(taito env apply:$BRANCH)
taito db deploy:$BRANCH
taito deployment deploy:$BRANCH $COMMIT_SHA

# Test and verify deployment
taito deployment wait:$BRANCH
taito test:$BRANCH
taito deployment verify:$BRANCH

# Release artifacts in parallel
parallel:
- taito artifact release:client:$BRANCH $COMMIT_SHA
- taito artifact release:server:$BRANCH $COMMIT_SHA

# Release build
taito build release:$BRANCH

# Revert deployment on fail
fail:
- taito deployment revert:$BITBUCKET_BRANCH $COMMIT_SHA
- taito db revert:$BITBUCKET_BRANCH $COMMIT_SHA
```

Run `taito -h` to see decription of the commands.

If you for some reason cannot use Taito CLI on your CI/CD pipeline, you can easily implement CI/CD steps yourself. First run each step manually with the verbose option (`-v`) the see the commands that Taito CLI executes, and then implement your CI/CD script based on those commands. You can also use `taito-config.sh` as environment variables in your CI/CD script:

```
set -a
taito_target_env=${BRANCH/master/prod}
. taito-config.sh
set +a
```

---

**Next:** [6. Infrastructure management](06-infrastructure-management.md)
