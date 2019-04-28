## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install taito-cli.

* [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) (or bash-like shell)
* [Git](https://git-scm.com/)
* [Docker](https://docs.docker.com/install/)

**Note for Linux:**

See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

**Note for Windows:**

> WARNING: taito-cli has not been tested on Windows yet.

You can install bash-like shell on Windows either by installing [cygwin](https://www.cygwin.com/) or the [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about). Cygwin is probably the better option of the two since Docker cannot use the Linux file system effectively on Windows. Configure your system in that way you can call `git`, `docker` and `docker-compose` commands directly from shell. Also make sure that `pkill` command is available. You can install it on cygwin by running `apt-cyg install procps-ng`.

TODO existing problems with cygwin:

1. Required before git clone: `git config --global core.autocrlf input`
2. Because of `docker -it`, docker command should be prefixed with `winpty`, but it does not exist in `cygwin`
3. taito cannot find any `taito-config.sh` files --> some problems with mount directory paths?
4. /taito-cli/util/execute-on-host.sh: line 16: /home/taito/.taito/tmp/taito-cli.RAESzA: No such file or directory

TODO would Git BASH suffice? winpty works with it, but there are issues with windows paths and the symlink does not work.

### Installation for Linux / macOS / Windows with bash-like shell

1. Install [prerequisites](#prerequisites)

2. Clone taito-cli git repository and checkout the master branch:

    ```
    git clone git@github.com:TaitoUnited/taito-cli.git
    # Or with HTTPS: git clone https://github.com/TaitoUnited/taito-cli.git
    cd taito-cli
    git checkout master
    ```

3. Symlink the file named **taito** to your PATH. It's a bash script that runs taito-cli as a Docker container. For example:

    ```
    sudo ln -s /home/myname/projects/taito-cli/taito /usr/local/bin/taito
    ```

    > TODO: move taito executables to taito-cli/bin directory so that the whole directory can be added to PATH.

4. Configure your personal settings in `~/.taito/taito-config.sh` (see the example below). If you work for an organization that uses taito-cli, they will provide you the correct settings. See [Advanced Usage](03-usage.md#advanced-usage) if you need to configure settings for multiple organizations.
    ```
    #!/bin/bash
    # shellcheck disable=SC2034

    # taito-cli
    taito_global_plugins="docker-global fun-global
      google-global gcloud-global links-global template-global"

    # default zone
    taito_zone=my-zone

    # git
    git_organization=git@github.com:MyOrganization

    # google (personal settings)
    google_authuser=

    # toggl (personal settings)
    toggl_projects="myproject:12345678 someproject:87654321"

    # docker (personal settings)
    # NOTE: set to true if you get networking errors when running 'taito db' commands
    docker_legacy_networking=false

    # links
    link_global_urls="
      * home=https://www.myorganization.com
      * intra=https://intra.myorganization.com Intranet
      * conventions=https://intra.myorganization.com/conventions Software development conventions
      * hours=https://hours.myorganization.com Hour reporting
      * playgrounds=https://github.com/search?q=topic%3Ataito-playground+org%3AMyOrganization&type=Repositories Playground projects
    "

    # Template: Taito CLI image
    # TIP: Pull taito image from private registry to keep CI/CD fast.
    template_default_taito_image=taitounited/taito-cli:latest
    template_default_taito_image_username=
    template_default_taito_image_password=
    template_default_taito_image_email=

    # Template: Labeling
    template_default_zone=my-zone
    template_default_organization=myorganization
    template_default_organization_abbr=myorg

    # Template: Domains
    template_default_domain=dev.myorganization.com

    # Template: Project defaults
    template_default_environments="dev prod"

    # Template: Cloud provider
    template_default_provider=gcloud
    template_default_provider_org_id=0123456789
    template_default_provider_region=europe-west1
    template_default_provider_zone=europe-west1-c

    # Template: Git provider
    template_default_git_provider=github.com
    template_default_git_organization=myorganization
    template_default_git_url=github.com/myorganization
    template_default_source_git=git@github.com:TaitoUnited
    template_default_dest_git=github.com/myorganization

    # Template: CI/CD provider
    template_default_ci_provider=gcloud
    template_default_ci_deploy_with_spinnaker=false
    template_default_registry=eu.gcr.io

    # Template: Misc providers
    template_default_sentry_organization=myorganization
    template_default_appcenter_organization=myorganization

    # Template: Kubernetes
    template_default_kubernetes=my-kube

    # Template: Databases
    template_default_postgres=my-postgres
    template_default_mysql=my-mysql

    # Template: Storage
    template_default_storage_class=REGIONAL
    template_default_storage_location=europe-west1
    template_default_storage_days=60

    # Template: Backups
    template_default_backup_location=
    template_default_backup_days=

    # Template: Production zone
    # TIP: If you want to deploy staging, canary, and production environments
    # to a different zone than feature, development, and testing environments,
    # configure alternative prod zone settings here.
    template_default_zone_prod=my-zone
    template_default_domain_prod=myorganization.com
    template_default_provider_org_id_prod=0123456789
    template_default_provider_region_prod=europe-west1
    template_default_provider_zone_prod=europe-west1-c
    template_default_storage_class_prod=REGIONAL
    template_default_storage_location_prod=europe-west1
    template_default_storage_days_prod=60
    template_default_backup_location_prod=europe-west1
    template_default_backup_days_prod=60
    template_default_monitoring_uptime_channels_prod=
    ```

5. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor (TODO: not implemented yet): [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

6. Try it:

   * Run `taito -h` to show taito help.

### Installation for Windows Subsystem for Linux

> Docker cannot use the Linux file system effectively on Windows. Therefore all your software projects and taito-cli settings should be located on the Windows file system.

1. Install [prerequisites](#prerequisites)

2. Mount your windows drive to `/c` instead of the default `/mnt/c`. This way the same file paths work both on Windows and on Linux. NOTE: If your software projects are located on some other drive than `c:`, mount also that drive.

3. Clone the [taito-cli](https://github.com/TaitoUnited/taito-cli) git repository on the Linux file system:

    ```
    git clone https://github.com/TaitoUnited/taito-cli.git
    cd taito-cli
    git checkout master
    ```

4. Symlink the file named **taito** to your PATH. It's a bash script that runs taito-cli as a Docker container. For example:

   ```
   sudo ln -s /home/myname/projects/taito-cli/taito /usr/local/bin/taito
   ```

   > TODO: move taito executables to taito-cli/bin directory so that the whole directory can be added to PATH.

5. Choose a folder from Windows drive that will act as your home directory when running taito-cli. Set `TAITO_HOME` environment variable for your linux shell, for example:

    ```
    export TAITO_HOME="/c/users/myusername"
    ```

6. Configure your personal settings in `${TAITO_HOME}/.taito/taito-config.sh`. See the previous chapter for an example.

7. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

8. Try it:

   * Run `taito -h` to show taito help.

### Upgrade

You can upgrade taito-cli and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Usage](03-usage.md)
