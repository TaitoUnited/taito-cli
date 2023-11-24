## 3. Quick start

### Setting up infrastructure

> You should skip setting up infrastructure in the following situations:
>
> - You want to run your projects only locally for now.
> - Your organization is already using Taito CLI. In such case you should use the existing infrastructure, and ask for taito configuration settings from your colleagues and copy-paste the settings to your `~/.taito/taito-config.sh` file.
> - You already have an existing infrastructure, but no Taito CLI configurations for it. In such case, you should execute the following steps, but skip the step 2.

You can create a new zone with the following steps:

1. Create a new zone configuration based on one of the [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates). For example:

   ```shell
   cd devops # New or existing git repository for infrastructure configurations
   taito zone create gcp
   cd my-zone
   EDIT taito-config.sh
   EDIT *.yaml
   ```

2. Apply infrastructure configuration by running the following command, and follow instructions. This creates you a zone; typically consisting of a Kubernetes cluster, database clusters, object storage buckets, container registry, virtual private network, and some settings related to logging, monitoring, and IAM.

   ```shell
   taito auth
   taito zone apply
   ```

   > TIP: If you encounter an error while running Terrafom, just try to run `taito zone apply` again.

3. View the created resources on your cloud provider dashboard:

   ```shell
   taito open dashboard
   ```

   > RECOMMENDATION: Use the dashboard for viewing only. If you need to make changes to the infrastructure, make changes to the zone configuration files, and run `taito zone apply` to apply the changes. This way you can keep all your infrastructure configurations in version history (infrastructure as code).

4. Commit your zone configuration files to some git repository.

   > RECOMMENDATION: Create one git repository for all of your zones, and give write permission for DevOps personnel only.

5. Display project template settings with `taito project settings` and copy-paste the settings to your `~/.taito/taito-config.sh` file. You'll need these settings when you create a new project for the zone.

   ```shell
   taito -q project settings >> ~/.taito/taito-config.sh
   ```

   > TIP: Your default configuration is located in `~/.taito/taito-config.sh`. You can also have additional configurations, e.g. `~/.taito/taito-config-company-x.sh`.

### Setting up a new project

#### Local development environment (local)

1. Create a new project based on one of the [project templates](https://taitounited.github.io/taito-cli/templates#project-templates). For example:

   ```shell
   taito project create full-stack-template
   cd acme-myproject
   ```

   > TIP: You can choose some other than default configuration with `-o`, for example: `taito -o company-x project create full-stack-template`.

2. Clean start the local development environment with the following command. This typically initializes your local secrets, installs some libraries, builds and starts containers, and initializes your database with tables and some data. Secret default values are typically copied from dev environment, if available.

   ```shell
   taito develop
   ```

   > In case of trouble, run `taito trouble`. Sometimes `taito develop` might fail and hopefully `taito trouble` helps.

3. Open application web UI on your browser:

   ```shell
   taito open client
   ```

4. Connect to the database:

   ```shell
   taito db connect
   ```

#### Apply project wide settings

> If you skipped the _setting up infrastructure_ part before, now is the right time to create the zone, and to update your project with the correct settings by running `taito project upgrade`.

1. View organization specific conventions, and follow instructions:

   ```shell
   taito open conventions
   ```

2. Apply project wide settings:

   ```shell
   taito project apply
   ```

#### Development environment (dev)

1. Make sure your authentication is in effect:

   ```shell
   taito auth:dev
   ```

2. Create dev environment with the following command. This typically creates a database and some cloud resources (e.g. storage buckets), initializes secrets, and sets up the CI/CD pipeline. Note that if you are not the one who created the infrastructure, you might not have enough permissions to create new environments in it, unless you were given such permissions separately.

   ```shell
   taito env apply:dev
   ```

3. Trigger the first CI/CD deployment by committing and pushing changes to dev branch (you can do this with git tools also). Note that you should write your commit message according to [Conventional Commits](https://www.conventionalcommits.org):

   ```shell
   taito stage                   # Or just: git add .
   taito commit                  # Or just: git commit -m 'chore: configuration'
   taito push                    # Or just: git push
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

6. Show release notes for the first production release you just made:

   ```shell
   taito open releases
   ```

   > Semantic-release library requires version control personal access token (GitHub/GitLab/BitBucket) for accessing the version control API. Release notes will be generated only if you configured the token during the zone creation, or you configured VC_TOKEN environment variable for your CI/CD pipeline.

### Taito command reference

Run `taito -h` to show more taito commands that you can use, or see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt). Check also the DEVELOPMENT.md file located at your project root folder.

---

**Next:** [4. Usage](04-usage.md)
