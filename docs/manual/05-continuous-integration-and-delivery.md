## 5. Continuous integration and delivery

Taito-cli is designed so that in most cases your CI/CD tool needs only to execute a bunch of taito-cli commands without any arguments to get the job done. Everything is already configured in taito-config.sh, and taito-cli provides support for various infrastructures by plugins. You can also run any of the steps manually from command line using *taito-cli*. A typical CI/CD process would consist of the following steps, many of which can be run parallel.

* `taito auth`: Authenticate (in case the CI/CD tool does not handle authentication automatically).
* `taito deployment cancel`: Cancel old ongoing builds except this one (in case the CI/CD tool does not handle this automatically).
* `taito artifact prepare`: Make some preparations if required. Typically this step determines if the artifacts (e.g. container images) have already been built, and the new version number for the release by the type of commits (feature, fix, etc).
* `taito install`: Install required libraries.
* `taito scan`: Lint code, scan for code smells and vulnerabilities, etc. (TODO ship code climate with taito container?)
* `taito docs`: Generate docs.
* `taito artifact build:TARGET`: Run unit tests and build artifact (separate build step for each artifact)
* `taito artifact push:TARGET`: Push artifact to registry (separate build step for each artififact)
* `taito db deploy`: Deploy database changes.
* `taito deployment deploy`: Deploy the application.
* `taito deployment wait`: Wait for application to restart in the target environment.
* `taito test:` Run integration and e2e tests for the target environment.
* `taito deployment verify`: Verifies that integration and e2e tests tests went ok for the target environment. If tests failed and autorevert is enabled for the target environment, executes `taito db revert` and `taito deployment revert`.
* `taito artifact publish`: Publish all artifacts to a central location (e.g. container images, libraries, docs, test results, test coverage reports, code quality reports).
* `taito artifact release`: Typically generates release notes from git commits or issues, and tags the git repository with the new version number.

See [cloudbuild.yaml](https://github.com/TaitoUnited/server-template/blob/master/cloudbuild.yaml) of kubernetes-template as an example. TODO: add local testing env and reverts to the script.

---

**Next:** [6. Infrastructure management](06-infrastructure-management.md)
