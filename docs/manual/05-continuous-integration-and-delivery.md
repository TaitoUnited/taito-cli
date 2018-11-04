## 5. Continuous integration and delivery

Taito-cli is designed so that in most cases your CI/CD tool needs only to execute a bunch of taito-cli commands without any arguments to get the job done. Everything is already configured in taito-config.sh, and taito-cli provides support for various infrastructures by plugins. You can also run any of the steps manually from command line using *taito-cli*. A typical CI/CD process would consist of the following steps, many of which can be run parallel.

> TODO: separate ci command for every step (even for otherwise existing commands --> avoid accidental overrides in package.json, ci mode, etc)

> TODO: command list is not up-to-date.

* `taito --auth`: Authenticate (in case the CI/CD tool does not handle authentication automatically).
* `taito deployment cancel`: Cancel old ongoing builds except this one (in case the CI/CD tool does not handle this automatically).
* `taito ci prepare`: Set ci flags by status check. The ci flags are used to control the following ci steps. For example if taitoflag_images_exist is set, many of the ci steps will be skipped since all images have already been built and tested by some previous CI build.
* `taito install`: Install required libraries.
* `taito secrets`: Fetch secrets that are required by the following CI/CD steps.
* `taito ci release pre`: Make some preparations for the release if required. Typically this step determines the new version number for the release by the type of commits (feature, fix, etc).
* `taito ci unit`: Run unit tests.
* `taito ci scan`: Lint code, scan for code smells and vulnerabilities, etc. (TODO ship code climate with taito container?)
* `taito ci docs`: Generate docs.
* `taito ci build`: Build containers, functions, etc (separate build step for each)
* `taito ci push`: Push containers, functions, etc to registry (separate build step for each)
* `taito start:local`: Start the local testing environment
* `taito ci wait:local`: Wait for local testing environemnt to start
* `taito ci test:local`: Run local api/e2e tests.
* `taito stop:local`: Stop the local testing environment
* `taito env apply`: Optional: Migrate environment to the latest configuration (e.g. by using terraform).
* `taito db deploy`: Deploy database changes.
* `taito ci deploy`: Deploy the application.
* `taito ci wait`: Optional: Wait for application to restart in the target environment.
* `taito ci test`: Optional: Run api/e2e tests for the target environment.
* `taito ci verify`: Optional: Verifies that api and e2e tests went ok for the target environment. If tests failed and autorevert is enabled for the target environment, executes `taito db revert` and `taito deployment revert`.
* `taito ci publish`: Publish all artifacts to a central location (e.g. container images, libraries, docs, test results, test coverage reports, code quality reports).
* `taito ci release post`: Typically generates release notes from git commits or issues, and tags the git repository with the new version number.

See [cloudbuild.yaml](https://github.com/TaitoUnited/server-template/blob/master/cloudbuild.yaml) of kubernetes-template as an example. TODO: add local testing env and reverts to the script.

---

**Next:** [6. Infrastructure management](06-infrastructure-management.md)
