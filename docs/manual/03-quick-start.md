## 3. Quick start

### Setting up infrastructure

You can skip this step, if you are using Taito CLI with an existing infrastructure and you have received `template_default_*` settings for your `~/.taito/taito-config.sh` file from elsewhere.

1. Copy one of the infrastructure examples from [examples/zones](https://github.com/TaitoUnited/taito-cli/tree/dev/examples/zones):

    ```
    cp -r ~/projects/taito-cli/examples/zones/EXAMPLE my-zone
    cd my-zone
    ```

2. Edit the `taito-config.sh` from located in my-zone folder. Change at least the following settings, if such settings exist in the file:

    - taito_organization
    - taito_organization_abbr
    - taito_zone
    - taito_provider_org_id
    - taito_provider_billing_account_id
    - taito_zone_owners
    - taito_zone_devops_email
    - taito_zone_authorized_network

3. Create the infrastructure by running `taito zone apply` and follow instructions.

4. Display project template settings by running `taito project settings`. Copy-paste these settings to your `~/.taito/taito-config.sh` file.

### Setting up a new project

#### Local development environment

1. Create a new project based on a reusable template:

    ```
    taito project create: server-template
    ```

2. Clean start the local development environment:

    ```
    taito kaboom
    ```

3. Open application web UI running on local environment:

    ```
    taito open client
    ```

#### Remote dev environment

1. Create remote dev environment:

    ```
    taito env apply:dev
    ```

2. Trigger build by committing and pushing changes to dev branch (you can also use normal git commands instead):

    ```
    taito stage
    taito commit
    taito push
    ```

3. Show build status on browser:

    ```
    taito open builds:dev
    ```

4. Show status of dev environment:

    ```
    taito status:dev
    ```

5. Open application web UI running on dev environment:

    ```
    taito open client:dev
    ```

6. Show credentials for signing in (basic auth):

    ```
    taito info:dev
    ```

7. Tail logs of server container running on dev environment:

    ```
    taito logs:server:dev
    ```

8. Connect to the dev environment database:

    ```
    taito db connect:dev
    ```

9. Initialize dev environment database with some development data:

    ```
    taito init:dev
    ```

#### Production environment

1. Create production environment:

    ```
    taito env apply:prod
    ```

2. Merge changes between environments: dev -> ... -> prod:

    ```
    taito env merge:dev prod
    ```

3. Show production environment build status on browser

    ```
    taito open builds:prod
    ```

4. Open application web UI running on prod environment:

    ```
    taito open client:prod
    ```

---

**Next:** [4. Usage](04-usage.md)
