## 2. Installation and upgrade

### Prerequisites

* Docker
* Git
* Bash

### Linux / macOS / Windows with cygwin

> For Windows: Taito-cli requires [cygwin](https://www.cygwin.com/) with the procps-ng package installed: `apt-cyg install procps-ng`. Configure cygwin in that way you can call `git`, `docker` and `docker-compose` commands from cygwin shell. If you would rather use [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about), see the next chapter.

1. Clone this git repository and checkout the master branch.

2. Symlink the file named `taito` to your path (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`). It's a bash script that runs taito-cli as a Docker container.

3. Configure your personal settings in `~/.taito/taito-config.sh` (see the example below). If you work for an organization that uses taito-cli, they will provide you with the correct settings. See [Advanced Usage](https://github.com/TaitoUnited/taito-cli#advanced-usage) if you work for multiple organizations.
    ```
    #!/bin/bash
    # shellcheck disable=SC2034

    # NOTE: These are example settings! Replace them with your personal
    # settings or with the settings defined by your organization.

    taito_image="taitounited/taito-cli:latest"
    taito_global_plugins="docker-global fun-global \
      google-global gcloud-global links-global template-global"

    # git settings
    git_organization="git@github.com:MyOrganization"

    # google settings
    google_authuser="1"

    # template plugin default settings
    template_default_taito_image="taitounited/taito-cli:latest"
    template_default_organization="myorganization"
    template_default_domain="mydevdomain.com"
    template_default_domain_prod="mydomain.com"
    template_default_zone="my-zone"
    template_default_zone_prod="my-prod-zone"
    template_default_provider="gcloud"
    template_default_provider_billing_account="123456-123456-123456"
    template_default_provider_org_id="123456789"
    template_default_provider_region="europe-west1"
    template_default_provider_zone="europe-west1-b"
    template_default_provider_org_id_prod="123456789"
    template_default_provider_region_prod="europe-west2"
    template_default_provider_zone_prod="europe-west2-a"
    template_default_registry="eu.gcr.io"
    template_default_source_git="git@github.com:TaitoUnited"
    template_default_dest_git="git@github.com:MyOrganization"
    template_default_kubernetes="my-kubernetes"
    template_default_postgres="my-postgres"
    template_default_mysql="my-mysql"

    # links
    link_global_urls="\
      * home=https://www.mydomain.com \
      * intra=https://intra.mydomain.com Intranet \
      * conventions=https://intra.mydomain.com/conventions Software development conventions \
      * hours=https://hours.mydomain.com Hour reporting \
      * playgrounds=https://github.com/search?q=topic%3Ataito-playground+org%3AMyOrganization&type=Repositories Playground projects \
      "
    ```

4. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

> Once you have installed taito-cli, you can upgrade it and its extensions anytime by running `taito --upgrade`.

### Windows Subsystem for Linux

> Docker cannot use the Linux file system effectively on Windows. Therefore all your software projects and taito-cli settings should be located on the Windows file system.

1. Configure [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about) in that way you can call `git`, `docker` and `docker-compose` commands from linux shell.

2. Mount your windows drive to `/c` instead of the default `/mnt/c`. This way the same file paths work both on Windows and on Linux. NOTE: If your software projects are located on some other drive than `c:`, mount also that drive.

3. Clone the [taito-cli](https://github.com/TaitoUnited/taito-cli) git repository on the Linux file system.

4. Symlink the file named `taito` to your shell path (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`). It's a bash script that runs taito-cli as a Docker container.

5. Choose a folder from Windows drive that will act as your home directory when running taito-cli. Set `TAITO_HOME` environment variable for your linux shell, for example: `export TAITO_HOME="/c/users/myusername"`.

6. Configure your personal settings in `${TAITO_HOME}/.taito/taito-config.sh`. See previous chapter for an example.

7. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

> Once you have installed taito-cli, you can upgrade it and its extensions anytime by running `taito --upgrade`.

---

**Next:** [3. Usage](03-usage.md)
