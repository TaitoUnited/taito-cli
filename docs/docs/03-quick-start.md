## 3. Quick start

### Setting up infrastructure

> IMPORTANT: Skip this step if your organization is already using Taito CLI. In such case you should use the existing infrastructure instead of creating a new zone. Ask for taito configuration settings from your colleagues and copy-paste the settings to your `~/.taito/taito-config.sh` file.

Create a new zone with the following steps:

1. Create new zone based on one of the infrastructure examples from [taito-infrastructure](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates) by running `taito zone create: TEMPLATE` and follow instructions.

2. Apply infrastructure configuration by running `taito zone apply` and follow instructions.

3. Display project template settings by running `taito project settings` and copy-paste the settings to your `~/.taito/taito-config.sh` file.

### Setting up a new project

#### Local development environment (local)

1. Create a new project based on a reusable template:

    ```shell
    taito project create: full-stack-template
    cd PROJECT
    ```

2. Clean start the local development environment and initialize database:

    ```shell
    taito kaboom
    ```

3. Open application web UI running on local environment:

    ```shell
    taito open client
    ```

> In case of trouble, run `taito trouble`. Sometimes `taito kaboom` might fail and hopefully `taito trouble` helps.

#### Apply project wide settings

1. Run `taito open conventions` to show organization specific conventions and follow instructions.

2. Apply project wide settings:

    ```shell
    taito project apply
    ```

#### Development environment (dev)

1. Make sure your authentication is in effect:

    ```shell
    taito auth:dev
    ```

2. Create dev environment:

    ```shell
    taito env apply:dev
    ```

3. Trigger build by committing and pushing changes to dev branch (you can do this with git tools also). Note that you should write your commit message according to [Conventional Commits](https://www.conventionalcommits.org):

    ```shell
    taito stage
    taito commit
    taito push
    ```

4. Show build status on browser:

    ```shell
    taito open builds:dev
    ```

5. Show status of dev environment:

    ```shell
    taito status:dev
    ```

6. Open application web UI running on dev environment:

    ```shell
    taito open client:dev
    ```

7. Show credentials for signing in (basic auth):

    ```shell
    taito info:dev
    ```

8. Tail logs of server container running on dev environment:

    ```shell
    taito logs:server:dev
    ```

9. Initialize dev environment database with some development data:

    ```shell
    taito init:dev
    ```

10. Connect to the dev environment database:

    ```shell
    taito db connect:dev
    ```

#### Production environment (prod)

1. Make sure your authentication is in effect:

    ```shell
    taito auth:prod
    ```

2. Create production environment:

    ```shell
    taito env apply:prod
    ```

3. Merge changes between environments: `dev -> ... -> prod` (you can do this with git tools also, but always use fast-forward when merging between environment branches):

    ```shell
    taito env merge:dev prod
    ```

4. Show production environment build status on browser:

    ```shell
    taito open builds:prod
    ```

5. Open application web UI running on prod environment:

    ```shell
    taito open client:prod
    ```

### Taito command reference

Run `taito -h` to show more taito commands that you can use, or see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt). Check also the DEVELOPMENT.md file located at your project root folder.

---

**Next:** [4. Usage](/docs/04-usage)
