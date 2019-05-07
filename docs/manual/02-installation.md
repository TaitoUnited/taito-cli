## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

* [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) (or bash-like shell)
* [Git](https://git-scm.com/)
* [Docker](https://docs.docker.com/install/)

**Note for Linux:**

See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

**Note for Windows:**

Taito CLI has not been tested on Windows. It won't probably work yet.

### Installation

1. Clone taito-cli git repository and checkout the master branch:

    ```
    git clone git@github.com:TaitoUnited/taito-cli.git
    # Or with HTTPS: git clone https://github.com/TaitoUnited/taito-cli.git

    cd taito-cli
    git checkout master
    ```

2. Symlink the file named **taito** to your PATH. It's a bash script that runs Taito CLI as a Docker container. For example:

    ```
    sudo ln -s /home/myname/projects/taito-cli/taito /usr/local/bin/taito
    ```

3. Configure your personal settings in `~/.taito/taito-config.sh` (see the example below). If you work for an organization that uses Taito CLI, they will provide you the correct settings. See [Advanced Usage](03-usage.md#advanced-usage) if you need to configure settings for multiple organizations.
    ```
    #!/bin/bash
    # shellcheck disable=SC2034

    # Taito CLI
    taito_global_plugins="git-global docker-global google-global gcloud-global
      links-global template-global"

    # Docker
    # NOTE: set to true if you get networking errors when running 'taito db' commands
    docker_legacy_networking=false

    # Links
    link_global_urls="
      * home=https://www.myorganization.com
      * intra=https://intra.myorganization.com Intranet
      * conventions=https://intra.myorganization.com/conventions Software development conventions
      * hours=https://hours.myorganization.com Hour reporting
      * playgrounds=https://github.com/search?q=topic%3Ataito-playground+org%3AMyOrganization&type=Repositories Playground projects
    "

    # --- infrastructure template settings ---
    template_default_zone_source_git=git@github.com:TaitoUnited/taito-infrastructure//templates

    # --- Project template settings ---
    # Define default settings for newly created projects here
    ```

4. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install Taito CLI plugin for your editor (TODO: not implemented yet): [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

5. Try it:

   * Run `taito -h` to show taito help.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](03-quick-start.md)
