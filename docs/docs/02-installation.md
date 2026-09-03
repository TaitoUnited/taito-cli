## 2. Installation and upgrade

### Prerequisites

The following software needs to be installed on your computer before you can install Taito CLI.

- [Bash](<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>) (already included on Linux and macOS)
- [Git](https://git-scm.com/)
- [Docker](https://docs.docker.com/install/)

#### Additional details

**Linux:** See [Docker Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).

**Windows:** It is recommended to use [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/). Make sure you follow the best practices mentioned in the docker installation instructions. That is, source code should be located on Linux disk. You can use [Visual Studio Code Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) to modify the source code remotely from Windows. If you are using some other editor than VS Code, you can use some other sync mechanism to copy changed files from Windows to Linux (e.g. [Cygwin rsync](https://cygwin.com/packages/summary/rsync.html), [cwRsync](https://www.itefix.net/cwrsync))

> If you cannot use [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/) on Windows, you can try some bash emulation instead (e.g. [Git Bash](https://gitforwindows.org/)). However, [docker-for-win#1588](https://github.com/docker/for-win/issues/1588) may cause you some trouble. You can also try to run Docker inside a Linux virtual machine.

### Automatic installation

1. Install Taito CLI by running the following command on your unix-like shell (e.g. bash or zsh). The git clone method is either `https` or `ssh`:

   ```shell
   export TAITO_INSTALL_DIR=~/.taito-cli && \
   export TAITO_GIT_CLONE_METHOD=ssh && \
   curl -fsSL https://raw.githubusercontent.com/TaitoUnited/taito-cli/master/install.sh | bash
   ```

2. The install script adds Taito CLI on your `PATH` by modifying your shell startup files (`~/.bashrc`, `~/.bash_profile`, `~/.zshrc`). Restart your shell or open a new terminal so that the `taito` command becomes available.

3. Execute the final installation steps:

   ```shell
   taito upgrade
   ```

4. Check the installation:

   ```shell
   taito check
   ```

5. Show the available taito commands:

   ```shell
   taito -h
   ```

> If you have problems, run `taito trouble` to display troubleshooting. You can read the troubleshooting instructions also at [GitHub](https://github.com/TaitoUnited/taito-cli/blob/master/trouble.txt).

### Manual installation

See the [install.sh](https://github.com/TaitoUnited/taito-cli/blob/master/install.sh) script and execute the steps manually in any way you like.

### Upgrade

You can upgrade Taito CLI and its extensions anytime by running `taito upgrade`.

---

**Next:** [3. Quick start](03-quick-start.md)
