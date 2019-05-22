## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

- [Bash](<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>) (or bash-like shell)
- [Git](https://git-scm.com/)
- [Docker](https://docs.docker.com/install/)

**Note for Linux:**

See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

**Note for Windows:**

Taito CLI has not been tested on Windows. It won't probably work yet.

### Automatic installation

1. Install Taito CLI to your home directory by running:

    ```shell
    curl -s https://raw.githubusercontent.com/TaitoUnited/taito-cli/master/install.sh | bash -
    ```

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli) or [Atom](https://github.com/keskiju/atom-taito-cli) editor.

### Manual installation

> With manual installation you can decide yourself where to install Taito CLI.

1. See the [install.sh](https://github.com/TaitoUnited/taito-cli/blob/master/install.sh) script and execute the steps manually in any way you like.

2. Optional: Install Taito CLI plugin for your [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli) or [Atom](https://github.com/keskiju/atom-taito-cli) editor.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](/docs/03-quick-start)
