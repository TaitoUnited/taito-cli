## 3. Usage

Only a small subset of taito commands are enabled if you are located outside a project directory. However, you don't need to be located at project root when you run a taito-cli command since taito-cli determines project root by the location of the `taito-config.sh` file.

Run `taito -h` to show a list of all predefined commands of taito-cli and additional custom commands provided by currently enabled plugins. Run `taito COMMAND -h` to search for a command help; try for example `taito db -h`, `taito clean -h` or `taito test -h`. Write `taito ` and hit tab, and you'll get autocompletion for predefined commands.

[Exercises](https://github.com/TaitoUnited/taito-cli/tree/master/exercises) provide you with common scenarios that taito-cli commands are useful for. They also guide you through on setting up your infrastructure if you don't have one already.

Some of the plugins require authentication. If you encounter a connection or authorization error, run `taito --auth:ENV` inside a project directory to authenticate in the context of the project. Note that your credentials are saved on the container image, as you don't need them lying on your host file system anymore.

See the [README.md](https://github.com/TaitoUnited/server-template#readme) of the [server-template](https://github.com/TaitoUnited/server-template) project as an example on how to use taito-cli with your project. For a quickstart guide, see the [examples](https://github.com/TaitoUnited/taito-cli/tree/master/examples) directory. You can also [search GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories) for more taito-cli project templates. If you want to make your own, use **taito-template** as a label.

> *But is it fun to use? Oh, yes! Enable the **fun** plugin, run `taito fun starwars` and grab a cup of coffee ;) TIP: To close telnet, press <kbd>ctrl</kbd>+<kbd>]</kbd> (or <kbd>ctrl</kbd>+<kbd>å</kbd> for us scandinavians) and type `close`.*

### Troubleshooting

See `trouble.txt` or run `taito --trouble`.

### Advanced usage

If you work for multiple organizations, you may define organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. You can use these setting with the `-o` option when you execute a command outside a project directory, for example `taito -o ORGANIZATION open intra`. The `-o` option is most useful combined with the `project create` command as it will tell taito-cli to initialize the new project using the organization specific default settings, for example: `taito -o ORGANIZATION project create: server-template`.

You can execute project specific commands outside the project directory with the `-p` option, for example `taito -p my-project open app:dev`. This works only if you have configured `git_organization` setting in you personal `taito-config.sh` file.

You can easily run any shell command inside the taito-cli container, for example: `taito -- kubectl get pods --namespace my-project-dev`. You can also start an interactive shell inside the container: `taito --shell`. Thus, you never need to install any infrastructure specific tools on your own operating system. If you need some tools that taito-cli container doesn't provide by default, use docker hub to build a custom image that is dependent on *taitounited/taito-cli*, or make a request for adding the tool to the original taito-cli image.

With the `-v` or `--verbose` flag you can see the commands that plugins run during command execution. If you want to see even more output, use the `--debug` flag.

### Admin credentials

Many tools require you to authenticate only once and then you can run any command without supplying your password again. For this reason taito-cli supports a separate admin account for accessing critical resources.

With the `--admin` (or `-a`) option you specify that you would like to run the given command as admin. For example, you can authenticate as admin by running `taito -a --auth:prod` and then execute a command as admin by running `taito -a status:prod`. Your admin credentials are stored in taito-cli container image using `aes-256-cbc` encryption and you need to enter the decryption key everytime you execute a command as admin. Keep the decryption key in a safe place (use a password manager for example).

TODO support for U2F/YubiKey?

---

**Next:** [4. Configuration](04-configuration.md)
