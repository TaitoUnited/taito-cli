# Website development

This file has been copied from [website-template](https://github.com/TaitoUnited/website-template/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/website-template/blob/dev/DEVELOPMENT.md) instead. Project specific conventions are located in [README.md](README.md#conventions). See the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for more thorough development instructions. Note that Taito CLI is optional (see [usage without Taito CLI](#usage-without-taito-cli)).

Table of contents:

* [Prerequisites](#prerequisites)
* [Quick start](#quick-start)
* [Automated tests](#automated-tests)
* [Code structure](#code-structure)
* [Version control](#version-control)
* [Deployment](#deployment)
* [Usage without Taito CLI](#usage-without-taito-cli)

## Prerequisites

* [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Optional: [Taito CLI](https://github.com/TaitoUnited/taito-cli#readme)
* Optional: eslint and prettier plugins for your code editor

## Quick start

Install linters and some libraries on host for code autocompletion purposes (add `--clean` to make a clean reinstall):

    taito install

Start containers (add `--clean` to make a clean rebuild, and to discard all data and db tables):

    taito start

Open site in browser:

    taito open www

Show user accounts and other information that you can use to log in:

    taito info

Run tests:

    taito unit                              # run all unit tests
    taito unit:www post                     # run the 'post' unit test of www
    taito test                              # run all end-to-end tests

Open Cypress user interface:

    taito cypress                           # open cypress

> TIP: Testing personnel may run Cypress against any remote environment without Taito CLI or docker. See `www/test/README.md` for more instructions.

Start shell on a container:

    taito shell:www

Stop containers:

    taito stop

List all project related links and open one of them in browser:

    taito open -h
    taito open NAME

Check dependencies:

    taito check deps
    taito check deps:www
    taito check deps:www -u                 # update packages interactively
    taito check deps:www -y                 # update all packages (non-iteractive)

> NOTE: Many of the `devDependencies` and `~` references are actually in use even if reported unused. But all unused `dependencies` can usually be removed from package.json.

Cleaning:

    taito clean:www                         # Remove www container image
    taito clean:npm                         # Delete node_modules directories
    taito clean                             # Clean everything

The commands mentioned above work also for server environments (`f-NAME`, `dev`, `test`, `stag`, `canary`, `prod`). Some examples for dev environment:

    taito --auth:dev                        # Authenticate to dev
    taito open www:dev                      # Open site in browser
    taito info:dev                          # Show info
    taito status:dev                        # Show status of dev environment
    taito open builds                       # Show build status and logs
    taito test:dev                          # Run integration and e2e tests
    taito cypress:www:dev                   # Open cypress for www
    taito shell:www:dev                     # Start a shell on www container
    taito logs:www:dev                      # Tail logs of www container
    taito open logs:dev                     # Open logs on browser
    taito secrets:dev                       # Show secrets (e.g. database user credentials)

Run `taito -h` to get detailed instructions for all commands. Run `taito COMMAND -h` to show command help (e.g `taito vc -h`, `taito db -h`, `taito db import -h`). For troubleshooting run `taito --trouble`. See [README.md](README.md) for project specific conventions and documentation.

> If you run into authorization errors, authenticate with the `taito --auth:ENV` command.

> It's common that idle applications are run down to save resources on non-production environments. If your application seems to be down, you can start it by running `taito start:ENV`, or by pushing some changes to git.

## Automated tests

Once you have implemented your first integration or e2e test, enable the CI test execution by setting `ci_exec_test=true` at least for dev environment.

## Code structure

Project specific conventions are defined in [README.md](README.md#conventions).

## Version control

Development is done in `dev` and `feature/*` branches. Hotfixes are done in `hotfix/*` branches. You should not commit changes to any other branch.

All commit messages must be structured according to the [Angular git commit convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) (see also [Conventional Commits](http://conventionalcommits.org/)). This is because application version number and release notes are generated automatically for production release by the [semantic-release](https://github.com/semantic-release/semantic-release) library.

> You can also use `wip` type for such feature branch commits that will be squashed during rebase.

You can manage environment and feature branches using Taito CLI commands. Run `taito vc -h` for instructions. If you use git commands or git GUI tools instead, remember to follow the version control conventions defined by `taito vc conventions`. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

## Deployment

Container images are built for dev and feature branches only. Once built and tested successfully, the container images will be deployed to other environments on git branch merge:

* **f-NAME**: Push to the `feature/NAME` branch.
* **dev**: Push to the `dev` branch.
* **test**: Merge changes to the `test` branch using fast-forward.
* **stag**: Merge changes to the `stag` branch using fast-forward.
* **canary**: Merge changes to the `canary` branch using fast-forward. NOTE: Canary environment uses production resources (database, storage, 3rd party services) so be careful with database migrations.
* **prod**: Merge changes to the `master` branch using fast-forward. Version number and release notes are generated automatically by the CI/CD tool.

Simple projects require only two environments: **dev** and **prod**. You can list the environments with `taito vc env list`.

You can use the `taito vc` commands to manage branches, and the `taito deployment` commands to manage builds and deployments. Run `taito vc -h` and `taito deployment -h` for instructions. Run `taito open builds` to see the build logs. See [version control](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/03-version-control.md) chapter of the [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/README.md) for some additional information.

> Automatic deployment might be turned off for critical environments (`ci_exec_deploy` setting in `taito-config.sh`). In such case the deployment must be run manually with the `taito -a deployment deploy:prod VERSION` command using a personal admin account after the CI/CD process has ended successfully.

## Usage without Taito CLI

You can use this template also without Taito CLI.

**Local development:**

    npm install              # Install a minimal set of libraries on host
    npm run install-dev      # Install more libraries on host (for editor autocompletion/linting)
    docker-compose up        # Start the application
    -> http://localhost:9999 # Open the site on browser (the port is defined in docker-compose.yaml)

    npm run ...              # Use npm to run npm scripts ('npm run' shows all the scripts)
    docker-compose ...       # Use docker-compose to operate your application
    docker ...               # Use docker to operate your containers

**Testing:**

Testing personnel may run Cypress against any remote environment without Taito CLI or docker. See `www/test/README.md` for more instructions.

**Environments and CI/CD:**

Taito CLI supports various infrastructures and technologies out-of-the-box, and you can also extend it by writing custom plugins. If you for some reason want to setup the application environments or run CI/CD steps without Taito CLI, you can write the scripts yourself by using the environment variable values defined in `taito-config.sh`.

Creating an environment:

* Set Kubernetes secret values with `kubectl`. The secrets are defined by `taito_secrets` in `taito-config.sh`, and they are referenced in `scripts/helm*.yaml` files.

Deploying the application:

* Build all container images with [Docker](https://www.docker.com/) and push them to a Docker image registry.
* Deploy application to Kubernetes with [Helm](https://helm.sh/). Helm templates are located in `scripts/helm/` and environment specific values are located in `scripts/helm*.yaml`. Note that Helm does not support environment variables in value yaml files (this feature is implemented in the Taito CLI Helm plugin). Therefore you need to create a separate `scripts/heml-ENV.yaml` file for each environment and use hardcoded values in each.
* Optional: Run automatic tests
* Optional: Revert deployment if some of the tests fail.
* Optional: Make a production release with semantic-release (see `package.json`)

## Configuration

Configure static site generator of your choice with the following instructions. Currently instructions are provided only for Gatsby, Hugo and Jekyll, but with some extra work the website-template may easily be used with any static site generator.

Remove static site generators that you do not use from `www/install.sh`.

    EDIT www/install.sh

Start containers, and start a shell inside the www Docker container:

    taito install
    taito start
    taito shell:www

*FOR GATSBY ONLY:* Create a new Gatsby site based on one of the [starters](https://www.gatsbyjs.org/starters?v=2):

    npx gatsby new site STARTER-SOURCE-URL-OF-MY-CHOICE
    rm -rf site/.git
    exit

*FOR GATSBY ONLY:* Enable `/service/site/node_modules` mount in `docker-compose.yaml`:

    EDIT docker-compose.yaml

*FOR HUGO ONLY:* Create a new Hugo site (See [Hugo themes](https://themes.gohugo.io/) and [Hugo quick start](https://gohugo.io/getting-started/quick-start/) for more details):

    hugo new site site
    cd site
    git clone https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
    rm -rf themes/ananke/.git
    echo 'theme = "ananke"' >> config.toml
    hugo new posts/my-first-post.md
    exit

*FOR HUGO ONLY:* If you have some trouble with links, you might also need to enable relative urls by using the following settings in `www/site/config.toml`:

    baseURL = ""
    relativeURLs = true

*FOR JEKYLL ONLY:* Create a new site:

    bash
    jekyll new site
    exit
    exit

Restart containers and open the site on browser:

    taito stop
    taito start --clean
    taito open www

> NOTE: The docs folder is mounted inside the www container. Therefore you can access all markdown files of docs in your static generator implementation with `../docs`.
