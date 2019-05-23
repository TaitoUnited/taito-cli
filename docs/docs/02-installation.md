## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

- [Bash](<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>)
- [Git](https://git-scm.com/)
- [Docker](https://docs.docker.com/install/)

**Note for Windows:**

[Git for Windows](https://gitforwindows.org/) includes Git BASH. You can use it to execute Taito CLI commands. The legacy [Docker Toolbox](https://docs.docker.com/toolbox/overview/) also includes bash, in case you use it instead of the [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/).

**Note for Linux:**

See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

### Automatic installation

1. Install Taito CLI by running:

    ```shell
    export TAITO_INSTALL_DIR=~/taito-cli
    export TAITO_GIT_CLONE_METHOD=https  # https or ssh
    curl -s https://raw.githubusercontent.com/TaitoUnited/taito-cli/master/install.sh | bash
    ```

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli) or [Atom](https://github.com/keskiju/atom-taito-cli) editor.

### Manual installation

1. See the [install.sh](https://github.com/TaitoUnited/taito-cli/blob/master/install.sh) script and execute the steps manually in any way you like.

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli) or [Atom](https://github.com/keskiju/atom-taito-cli) editor.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](/docs/03-quick-start)
