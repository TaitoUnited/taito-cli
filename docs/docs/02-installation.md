## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

- [Bash](<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>) (already included on Linux and macOS)
- [Git](https://git-scm.com/)
- [Docker](https://docs.docker.com/install/)

#### Additional details

**Linux:** See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

**Docker Desktop for Windows:** Install [Git for Windows](https://gitforwindows.org/). It provides both Git and Bash. Use Git Bash as your shell. However, issue [docker-for-win#1588](https://github.com/docker/for-win/issues/1588) may cause you some trouble with MinTTY terminal emulation. You can try some of the workarounds mentioned in the issue comment section. Especially [this comment](https://github.com/docker/for-win/issues/1588#issuecomment-594938988) seems promising (not tested yet).

**Docker Toolbox for Windows:** Install [Git for Windows](https://gitforwindows.org/). Use Docker Toolbox as your shell instead of Git Bash. Note that Docker Compose secret mounts might not work properly on Docker Toolbox (issue [docker-compose#6585](https://github.com/docker/compose/issues/6585)). If this is a problem, you can ditch the Docker Toolbox and run a Linux virtual machine with VirtualBox as you normally would.

### Automatic installation

1. Install Taito CLI by running the following commands on your unix-like shell (e.g. bash):

    ```shell
    export TAITO_INSTALL_DIR=~/taito-cli
    export TAITO_GIT_CLONE_METHOD=https  # https or ssh
    curl -s https://raw.githubusercontent.com/TaitoUnited/taito-cli/master/install.sh | bash
    ```

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/TaitoUnited/vscode-taito-cli) or [Atom](https://atom.io/packages/atom-taito-cli) editor.

### Manual installation

1. See the [install.sh](https://github.com/TaitoUnited/taito-cli/blob/master/install.sh) script and execute the steps manually in any way you like.

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/TaitoUnited/vscode-taito-cli) or [Atom](https://atom.io/packages/atom-taito-cli) editor.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](03-quick-start.md)
