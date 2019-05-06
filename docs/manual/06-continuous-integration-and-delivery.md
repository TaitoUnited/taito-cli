## 6. Continuous integration and delivery

In most cases your CI/CD tool needs only to execute a bunch of simple Taito CLI commands to get the job done. Everything is already configured in taito-config.sh, and Taito CLI provides support for various infrastructures by plugins. This means that you can also easily run any of the CI/CD steps manually from command line using *Taito CLI*. A typical CI/CD process would consist of the following steps. Run `taito -h` to see decription of the commands.

```
# Prepare build
taito build prepare:$BRANCH

# Prepare all artifacts for deployment (execute in parallel)
taito artifact prepare:client:$BRANCH $COMMIT_SHA
taito artifact prepare:server:$BRANCH $COMMIT_SHA

# Deploy the changes to target environment
(taito env apply:$BRANCH)
taito db deploy:$BRANCH
taito deployment deploy:$BRANCH $COMMIT_SHA

# Test and verify deployment
taito deployment wait:$BRANCH
taito test:$BRANCH
taito deployment verify:$BRANCH

# Release all artifacts (execute in parallel)
taito artifact release:client:$BRANCH $COMMIT_SHA
taito artifact release:server:$BRANCH $COMMIT_SHA

# Release build
taito build release:$BRANCH

# ON FAIL: Revert deployment on fail
taito deployment revert:$BITBUCKET_BRANCH $COMMIT_SHA
taito db revert:$BITBUCKET_BRANCH $COMMIT_SHA
```

If you want your CI/CD to do more that it currently does, try not to add more CI/CD steps. Instead, enable plugins or add custom commands that do additional operations within the current CI/CD steps. For example, if you want to do something extra at the end of the CI/CD script, just enable some plugin that executes the additional operation on `taito build release`, or add a custom command to your package.json (e.g. `"build-release": "echo 'Do something extra'"`).

### CI/CD without Taito CLI

If you for some reason cannot use Taito CLI in your CI/CD pipeline, you can easily implement the CI/CD steps yourself. First run each step manually with the verbose option (`taito -v`) to see the commands that Taito CLI executes under the hood. Then implement your CI/CD script based on those commands. You can also use `taito-config.sh` environment variables in your CI/CD script:

```
set -a
taito_target_env=${BRANCH/master/prod}
. taito-config.sh
set +a
```

Note that the CI/CD process may slightly differ depending on branch. On dev and feature branches the artifacts are usually tagged using `untested` suffix, and on master branch some additional steps are taken during `taito build release` to generate release notes, etc.

---

**Next:** [7. Infrastructure management](07-infrastructure-management.md)
