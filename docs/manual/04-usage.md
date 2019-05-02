## 4. Usage

### Setting up a project

TODO: A separate quick spin chapter: Quick infrastructure setup and commands example (list of commands). Also tutorial reference.

If you are not working with an existing Taito CLI project, see the first chapters of [Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/README.md) on how to create a new project, and [chapter 15. Creating a zone](https://github.com/TaitoUnited/taito-cli/blob/master/docs/tutorial/15-creating-a-zone.md) for instructions on how to setup your infrastructure.

If you would rather add Taito CLI support for an existing project, see the [configuration](04-configuration.md) chapter. Note that some of the [project templates](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/templates.md##project-templates) provide instructions on how to migrate an existing project to use the template.

### The basics

Taito CLI is configured with a `taito-config.sh` file placed at your project root directory. You can execute taito commands anywhere in the project directory hierarchy, that is, at the project root directory or any of its subdirectories. When you are not located inside a project directory, only global Taito CLI plugins are enabled and therefore only a small subset of taito commands are enabled.

Run `taito -h` to show a list of all predefined commands of Taito CLI and additional custom commands provided by currently enabled plugins. Run `taito COMMAND -h` to search for a command help; try for example `taito db -h`, `taito feat -h` or `taito env -h`. Write `taito ` and hit tab, and you'll get autocompletion for taito commands, if you have installed the autocompletion support.

Some of the plugins require authentication. If you encounter a connection or authorization error, run `taito auth:ENV` inside a project directory to authenticate in the context of a project environment (for example `taito auth:dev`). Note that your credentials are saved on the Taito CLI container image, as you don't need them lying on your host file system anymore.

[Taito CLI tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/README.md) guides you through common software development scenarios in a chronological order, including creating your first taito-cli project and setting up your own infrastructure. You may consider it as a chronological Taito CLI manual.

See the [DEVELOPMENT.md](https://github.com/TaitoUnited/server-template/blob/master/DEVELOPMENT.md) of the [kubernetes-template](https://github.com/TaitoUnited/server-template) as an example on how to use Taito CLI with your project.

### Troubleshooting

Run `taito --trouble`.

With the `-v` or `--verbose` flag you can see the commands that plugins run during command execution. If you want to see even more output, use the `--debug` flag.

### Advanced usage

#### Multiple organizations

If you work for multiple organizations, you may define organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. You can use these setting with the `-o` option when you execute a command outside a project directory, for example `taito -o ORGANIZATION open intra`. The `-o` option is most useful combined with the `project create` command as it will tell Taito CLI to initialize the new project using the organization specific default settings, for example: `taito -o ORGANIZATION project create: kubernetes-template`.

#### Project references

You can execute project specific commands also outside the project directory with the `-p` option, for example `taito -p my-project open logs:prod`. The command reads the `taito-config.sh` file directly from remote git repository, and therefore the git repository need not be cloned to your local disk. The `-p` options works only if you have configured `git_organization` setting in you personal or organizational `taito-config.sh` file.

#### Running shell commands

You can easily run any shell command inside the Taito CLI container, for example: `taito -- kubectl get pods --namespace my-project-dev`. You can also start an interactive shell inside the container: `taito shell`. Thus, you never need to install any infrastructure specific tools on your own operating system. If you need some tools that Taito CLI container doesn't provide by default, see [customizing Taito CLI](#customizing-taito-cli).

#### Setting current context for shell commands

Running `taito auth:ENV` also sets the default context for currently enabled plugins. For example, if the kubectl plugin is enabled, you can run `taito auth:ENV` to set the default context for kubectl (Kubernetes cluster and namespace). After that you can execute a bunch of kubectl commands, and all of them will execute in the default context previously set by the auth command. For example: `taito -- kubectl get secrets`, `taito -- kubectl get secret my-secret -o yaml`.

#### Installing additional tools to local Taito CLI image

You can install additional tools to you local Taito CLI image like this:

```
taito -r shell                             # Start shell as root user
apt-get update                             # Retrieve new lists of packages
apt-get install PACKAGE [PACKAGE ...]      # Install some packages
taito util-commit                          # Commit changes to the Taito CLI image
exit                                       # Exit Taito CLI shell
```

These changes are in effect until the next time you run `taito upgrade`. If you want to make permanent changes, put your additional installation scripts in `~/.taito/install.sh`. It will be run as root user during `taito upgrade`. Note that `/install` directory of Taito CLI image contains some reusable install scripts that you can also use in your `install.sh`.

> TODO: Implement install.sh support.

#### Building and distributing a customized Taito CLI image

You can use Docker Hub or some other registry to build and distribute a custom Taito CLI image that is dependent on one of the official Taito CLI images. This way you can make a customized Taito CLI image for your organization, or for your CI/CD pipeline.

#### Admin credentials

Many tools require you to authenticate only once and then you can run any command without supplying your password again. For this reason Taito CLI supports a separate admin account for accessing critical resources.

With the `-a, --admin` option you specify that you would like to run the given command as admin. For example, you can authenticate as admin by running `taito -a auth:prod` and then execute a command as admin by running `taito -a status:prod`. Your admin credentials are stored in Taito CLI container image using `aes-256-cbc` encryption and you need to enter the decryption key everytime you execute a command as admin. Keep the decryption key in a safe place.

TODO support for U2F/YubiKey?

---

**Next:** [5. Configuration](05-configuration.md)
