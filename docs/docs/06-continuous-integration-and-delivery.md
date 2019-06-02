## 6. Continuous integration and delivery

In most cases your CI/CD tool needs only to execute a bunch of simple Taito CLI commands to get the job done. Everything is already configured in taito-config.sh, and Taito CLI provides support for various infrastructures by plugins. This means that you can also easily run any of the CI/CD steps manually from command line using _Taito CLI_. A typical CI/CD process would consist of the following steps. Run `taito -h` to see decription of the commands.

```shell
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

If you want your CI/CD to do more that it currently does, try not to add more CI/CD steps. Instead, enable plugins or add custom commands that do additional operations within the current CI/CD steps. This way CI/CD scripts remain reusable and CI/CD pipeline consists of standard steps that can be easily run either automatically or manually. For example, if you want to do something extra at the end of the CI/CD script, just enable some plugin that executes the additional operation on `taito build release`, or add a custom command to your package.json (e.g. `"build-release": "echo 'Do something extra'"`).

### Deployment to multiple platforms

You can deploy the same application to multiple platforms. For example, your development and testing environments may reside on Google Cloud Platform to enable easy access for external personnel. 	Furthermore, your staging, canary, and production environments may reside on-premises to fulfill extra security requirements. Deployment settings are configured in the project specific `taito-config.sh` file.

You may even deploy the same git branch simultaneously to multiple platforms. Just define path to a configuration overrides file in your CI/CD script with the `TAITO_CONFIG_OVERRIDE` environment variable, and it will be included in the `taito-config.sh` file just before `taito-provider-config.sh`. The file may be either local file (e.g. `./my-overrides.sh`) or remote (e.g. `https://mydomain.com/configs/my-overrides.sh`).

### CI/CD without Taito CLI

If you for some reason cannot use Taito CLI in your CI/CD pipeline, you can easily implement the CI/CD steps yourself. First run each step manually with the verbose option (`taito -v`) to see the commands that Taito CLI executes under the hood. Then implement your CI/CD script based on those commands. You can also use `taito-config.sh` environment variables in your CI/CD script:

```shell
export taito_target_env=${BRANCH/master/prod}
. taito-config.sh
```

Note that the CI/CD process may slightly differ depending on environment. On dev and feature environments the artifacts are usually tagged using `untested` suffix, and on prod environment some additional steps are taken during `taito build release` to generate release notes, etc.

---

**Next:** [7. Infrastructure management](/docs/07-infrastructure-management)
