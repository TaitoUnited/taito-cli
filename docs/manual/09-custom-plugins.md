## 9. Custom plugins

> Before implementing your own custom plugin, you should browse through existing [extensions](https://github.com/search?q=topic%3Ataito-extension&type=Repositories), as they already might provide what you are looking for.

### The basics

You can implement your plugin with almost any programming language. The only requirement is that your plugin provides taito command implementations as executable files. Bash is a good choice for a simple implementation that gets the job done by calling an existing command line tool. Python or JavaScript are preferred for more complex stuff, especially if you need to interract with a REST/JSON API.

> See [project-and-extension](https://github.com/TaitoUnited/taito-cli/tree/dev/examples/project-and-extension) as an example. It is a project that uses a custom extension that is located in the project subdirectory. TODO examples for Python and JavaScript.

This is how you implement your own custom plugin:

1. First create a directory that works as a taito-cli extension. It is basically a collection of plugins:

    ```
    my-extension/
      my-plugin/
      another-plugin/
    ```

2. Add `package.json` and `taito-config.sh` files to the root directory of your extension  (`my-extension`). Minimal `package.json` and `taito-config.sh` contents for supporting unit tests:

    ```
    {
      "scripts": {
        "unit": "taito -- find . -name \"*.bats\" -type f -prune -exec bats '{}' +"
      }
    }
    ```

    ```
    #!/bin/sh
    # shellcheck disable=SC2034
    taito_image="taitounited/taito-cli:latest"
    taito_plugins="npm"
    ```

3. Add some executable commands to one of the plugins as `.sh`, `.py`, `.js` or `.x` files). Optionally add also documentation in help.txt, trouble.txt and README.md files. With the #pre and #post prefixes you can define that your command should be run in pre or post phase instead of the normal execute phase (more on that later).

    ```
    my-plugin/
      resources/
        my-script.sql
      util/
        my-util.sh
      my-command.bats
      my-command.sh
      env-apply#post.bats
      env-apply#post.sh
      env-apply#pre.bats
      env-apply#pre.sh
      help.txt
      README.md
      trouble.txt
    ```

4. Optionally you can also add pre and post hooks to your plugin. These will be called before and after any other commands despite the command name. Exit with code 0 if execution should be continued, code 1 if handler encountered an error and code 2 if everything went ok, but execution should not be continued nevertheless. See npm plugin as an example.

    ```
    my-plugin/
      hooks/
        pre.sh
        post.sh
    ```

5. Add the extension directory to your *taito_global_extensions* or *taito_extensions* definition and the plugin to your *taito_global_plugins* or *taito_plugins* definition. You can reference extension either by file path or git url.

    ```
    taito_extensions="git@github.com:JohnDoe/my-extension.git"
    taito_plugins="my-plugin"
    ```

6. Implement unit tests for your commands with [bats](https://github.com/bats-core/bats-core). See `.bats` files under `taito-cli/plugins` as an example. You can run your unit tests with the `taito unit` command.

7. Optionally provide autocomplete and descriptions support for you commands by adding `autocomplete.sh` and `descriptions.sh` to the root folder of your extension. See [autocomplete.sh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/autocomplete.sh) and [descriptions.sh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/descriptions.sh) as an example.

Now you should be able to call `taito my command`. And when you call `taito env apply`, your `env-apply#pre` and `env-apply#post` commands will be called before and after all `env-apply` commands defined by other enabled plugins. And if you defined also pre and post hooks, they will be called before and after any commands despite the command name.

Note that you can also add a project specific extension to your project subdirectory and reference it like this in *taito-config.sh*:

    taito_extensions="./scripts/my-extension"
    taito_plugins="my-plugin"

NOTE: Always remember to call the next command of the command chain at some point during command execution (usually at the end) unless you want to stop the command chain execution:

    "${taito_cli_path}/util/call-next.sh" "${@}"

NOTE: Do not call another command directly from another. It's error prone; you'll easily mess up the command chain execution, and also clarity of user friendly info messages. Place the common logic shared by multiple commands in a separate util instead.

### Output in verbose and debug mode

Values of the following environment variables are set depending on debug mode:

* **taito_debug**: `true` or `false`
* **taito_dout**: `/dev/stdout` or `/dev/null`

Values of the following environment variables are set depending on verbose mode:

* **taito_verbose**: `true` or `false`
* **taito_vout**: `/dev/stdout` or `/dev/null`
* **taito_setv**: `set -x` or `:`

You can use these environment variables to provide additional output in verbose or debug mode. For example:

    echo "Additional debug output" > ${taito_dout}
    echo "Additional verbose output" > ${taito_vout}
    (${taito_setv}; kubectl get pods) # The command will printed in verbose mode

### Running commands on host

If your plugin needs to run some commands on host machine, execute `"${taito_cli_path}/util/execute-on-host.sh" COMMANDS` to run them immediately in the background. Alternatively you can use the `"${taito_cli_path}/util/execute-on-host-fg.sh" COMMANDS` to run the commands on foreground after the taito container has exited. Note that if some of the commands might require user input, you must run the commands on foreground.

Currently this mechanism is used  e.g. for executing docker commands on host and launching browser.

### Committing changes to the taito-cli container image

If your plugin needs to save some data permanently on the container image, execute `"${taito_cli_path}/util/docker-commit.sh"`. This asks host to commit changes permanently on the container image. Currently this mechanism is used e.g. in authentication to save credentials on the image.

### Command chains and passing data

When a given command name matches to multiple commands, all commands are chained in series so that each command calls the next. Command execution is ordered primarily by the execution phase (pre, command, post) and secondarily by the order of the plugins in *taito-config.sh*.

Passing data between commands/phases works simply by exporting environment variables. To avoid naming conflicts between plugins, use your plugin name as a prefix for your exported environment variables. Or if the purpose is to pass data between different plugins, try to come up with some good standardized variable names and describe them in the [environment variables](#environment-variables) chapter.

Here is an example how chaining could be used e.g. to implement secret rotation by integrating an external secret manager:

1. Pre-hook of a secret manager plugin gathers all secrets that need to be rotated (e.g. database passwords) and generates new secrets for them.
2. A database plugin deploys the new database passwords to database.
3. The kubectl plugin deploys the secrets to Kubernetes and executes a rolling restart for the pods that use them.
4. Post-hook of the secret manager plugin stores the new secrets to a secure location using some form of encryption, or just updates the secret timestamps if the secrets need not be stored.

### Overriding existing commands

If you need to alter default behaviour of a plugin in some way, you can override a single command of a plugin without disabling the whole plugin:

* Create a plugin that provides an alternative implementation for the command
* Create a pre command that removes the original command from command chain (TODO reusable script for this)
* Make sure that your plugin is given first in the `taito_plugins` setting of your `taito-config.sh` file in project root directory.

### Environment variables

#### Common variables

All settings defined in `taito-config.sh` are visible for plugins. See [configuration](04-configuration.md) chapter for more info. Additionally the following environment variables are defined by taito-cli:

* **taito_env**: The selected environment (e.g. local, feat-NAME, dev, test, stag, canary, prod)
* **taito_target_env**: TODO ....
* **taito_target**: Command target (e.g. admin, client, server, worker, ...)
* **taito_command**: The user given command without the target and environment suffix.
* **taito_enabled_extensions**: List of all enabled extensions.
* **taito_enabled_plugins**: List of all enabled plugins.
* **taito_skip_override**: True if command overrides should be skipped.
* **taito_cli_path**: Path to taito-cli root directory.
* **taito_plugin_path**: Path to root directory of the current plugin.
* **taito_project_path**: Path to project root directory.
* **taito_command_chain**: Chain of commands to be executed next.
* **taito_verbose**: `true` in verbose mode, otherwise `false`.
* **taito_setv**: `set -x` in verbose mode, otherwise `:`.
* **taito_vout**: `/dev/stdout` in verbose mode, otherwise `/dev/null`.

TODO update the list of environment variables

#### Standardized variable names

These variable names are meant for communication between plugins.

Secrets:

TODO add documentation

### Tips

* [Bash string manipulation cheatsheet](https://gist.github.com/magnetikonline/90d6fe30fc247ef110a1)

---

**Next:** [10. Custom project templates](10-custom-project-templates.md)
