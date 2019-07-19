## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

- [Bash](<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>) (already included on Linux and macOS)
- [Git](https://git-scm.com/)
- [Docker](https://docs.docker.com/install/)

**Note for Windows:** [Git for Windows](https://gitforwindows.org/) includes both git and bash. [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/) is recommended, but you can also use the legacy [Docker Toolbox](https://docs.docker.com/toolbox/overview/) instead. If you are using Docker Toolbox, it is recommended to use the Docker Toolbox as your unix-like shell instead of Git Bash. **UPDATE:** Taito CLI does not fully work on Windows yet because of [docker-compose#6585](https://github.com/docker/compose/issues/6585) and [docker-for-win#1588](https://github.com/docker/for-win/issues/1588).

**Note for Linux:** See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

### Automatic installation

1. Install Taito CLI by running the following commands on your unix-like shell (e.g. bash):

    ```shell
    export TAITO_INSTALL_DIR=~/taito-cli
    export TAITO_GIT_CLONE_METHOD=https  # https or ssh
    curl -s https://raw.githubusercontent.com/TaitoUnited/taito-cli/master/install | bash
    ```

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/TaitoUnited/TODO/) or [Atom](https://atom.io/packages/atom-taito-cli) editor.

### Manual installation

1. See the [install](https://github.com/TaitoUnited/taito-cli/blob/master/install) script and execute the steps manually in any way you like.

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/TaitoUnited/TODO/) or [Atom](https://atom.io/packages/atom-taito-cli) editor.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](/docs/03-quick-start)
