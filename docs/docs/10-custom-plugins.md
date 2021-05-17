## 10. Custom plugins

> Before implementing your own custom plugin, you should browse through existing [core plugins](https://github.com/TaitoUnited/taito-cli/tree/master/plugins) and [extensions](https://github.com/search?q=topic%3Ataito-extension&type=Repositories), as they already might provide what you are looking for.

### The basics

You can implement your plugin with almost any programming language. The only requirement is that your plugin provides taito command implementations as executable files. Bash is a good choice for a simple implementation that gets the job done by calling an existing command line tool. Python or JavaScript are preferred for more complex stuff, especially, if you need to implement complex interactions with a REST or GraphQL API.

> See [project-and-extension](https://github.com/TaitoUnited/taito-cli/tree/master/examples/project-and-extension) as an example. It is a project that uses a custom extension that is located in the project subdirectory. TODO: examples for Python and JavaScript.

This is how you implement your own custom plugin:

1. First create a directory that works as a Taito CLI extension. It is basically a collection of plugins:

   ```shell
   my-extension/
     my-plugin/
     another-plugin/
   ```

2. Add `package.json` and `taito-config.sh` files to the root directory of your extension (`my-extension`). Minimal `package.json` and `taito-config.sh` contents for supporting unit tests:

   ```shell
   {
     "scripts": {
       "unit": "taito -- find . -name \"*.bats\" -type f -prune -exec bats '{}' +"
     }
   }
   ```

   ```shell
   #!/bin/bash -e
   # shellcheck disable=SC2034
   taito_image="taitounited/taito-cli:cli"
   taito_plugins="npm"
   ```

3. Add some executable commands to one of the plugins as executable files. Include execution priority **(00-99)** at the end of each command filename. The execution priority defines the execution order of a command implementation between enabled plugins. The plugin directory may also contain additional libraries and resources in additional subdirectories as in the example (`lib/`, `resources/`). Optionally you can add also plugin documentation in help.txt, trouble.txt and README.md files. TODO: command name conventions.

   ```shell
   my-plugin/
     lib/
       my-lib.bash
     resources/
       my-script.sql
     my-command-50
     env-apply-00
     env-apply-99
     help.txt
     README.md
     trouble.txt
   ```

   > Always remember to call the next command of the command chain at some point during command execution (usually at the end) unless you want to stop the command chain execution: `taito::call_next "${@}"`. TODO: Example for Python and "any language".

   > Do not call another command implementation directly from another. It's error prone; you'll easily mess up the command chain execution, and also clarity of user friendly info messages. Place the common logic shared by multiple commands in a separate library instead.

4. Optionally you can also add pre and post hooks to your plugin. These will be called before and after any other commands despite the command name.

   ```
   my-plugin/
     hooks/
       pre-50
       post-50
   ```

5. Add the extension directory to your _taito_global_extensions_ or _taito_extensions_ definition and the plugin to your _taito_global_plugins_ or _taito_plugins_ definition. You can reference extension either by file path or git url.

   ```shell
   taito_extensions="https://github.com/JohnDoe/my-extension.git"
   taito_plugins="my-plugin"
   ```

6. Implement unit tests for your commands with [bats](https://github.com/bats-core/bats-core). See `.bats` files under `taito-cli/plugins` as an example. You can run your unit tests with the `taito unit` command.

7. Optionally provide autocomplete and descriptions support for you commands by adding `autocomplete` and `descriptions` to the root folder of your extension. See [autocomplete](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/autocomplete) and [descriptions](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/descriptions) as an example.

Now you should be able to call `taito my command`. And when you call `taito env apply`, your `env-apply-00` and `env-apply-99` commands will be called before and after all `env-apply` implementations defined by other enabled plugins. And if you defined also pre and post hooks, they will be called before and after any commands despite the command name.

Note that you can also add a project specific extension to your project subdirectory and reference it like this in _taito-config.sh_:

    taito_extensions="./scripts/my-extension"
    taito_plugins="my-plugin"

### Tips

- [Bash string manipulation cheatsheet](https://gist.github.com/magnetikonline/90d6fe30fc247ef110a1)

### Environment variables

#### Common variables

All settings defined in `taito-config.sh` are visible for plugins. See [configuration](05-configuration.md) chapter for more info. Additionally some environment variables are defined by Taito CLI. The following are the most important:

- **taito\_project\_path**: Path to project root directory.
- **taito\_plugin\_path**: Path to root directory of the current plugin.
- **taito\_cli\_path**: Path to Taito CLI root directory.
- **taito\_target**: Command target (e.g. admin, client, server, database, storage, ...)
- **taito\_target\_env**: The target environment (e.g. local, dev, test, uat, stag, canary, prod)
- **taito\_env**: The resource environment. Usually the same as **taito\_target\_env**, but may differ in some scenarios (e.g. `taito_target_env=canary` but `taito_env=prod`).

TODO: update the list of environment variables

### Output in verbose and debug mode

Values of the following environment variables are set depending on debug mode:

- **taito\_debug**: `true` or `false`
- **taito\_dout**: `/dev/tty` or `/dev/null`

Values of the following environment variables are set depending on verbose mode:

- **taito\_verbose**: `true` or `false`
- **taito\_vout**: `/dev/tty` or `/dev/null`

You can use these environment variables to provide additional output in verbose or debug mode. For example:

    echo "Additional debug output" > "${taito_dout}"
    echo "Additional verbose output" > "${taito_vout}"
    (taito::executing_start; kubectl get pods) # The command will printed in verbose mode

#### Standardized variable names

These variable names are meant for communication between plugins.

Secrets:

TODO: add documentation

#### Command chains and passing data with environment variables

When a given command name matches to multiple commands, all commands are chained in series by the execution priority so that each command calls the next. Passing data between commands implementations works simply by exporting environment variables. To avoid naming conflicts between plugins, use your plugin name as a prefix for your exported environment variables. Or if the purpose is to pass data between different plugins, try to come up with some good standardized variable names.

Here is an example how chaining could be used e.g. to implement secret rotation by integrating an external secret manager:

1. Pre-hook of a secret manager plugin gathers all secrets that need to be rotated (e.g. database passwords) and generates new secrets for them.
2. A database plugin deploys the new database passwords to database.
3. The kubectl plugin deploys the secrets to Kubernetes and executes a rolling restart for the pods that use them.
4. Post-hook of the secret manager plugin stores the new secrets to a secure location using some form of encryption, or just updates the secret timestamps if the secrets need not be stored.

### Taito CLI library

[Taito CLI library](https://github.com/TaitoUnited/taito-cli/tree/dev/lib) provides reusable functions for your plugin implementation. Some examples below.

> TODO: Examples for Python

#### User interaction

Display output:

    taito::print_plugin_title             # Use this in your pre and post hooks

    taito::print_title "This is a title"

    taito::print_note_start
    echo "NOTE: This is a multiline note."
    echo "Another line."
    taito::print_note_end

Confirm operation:

    if taito::confirm "Execute this operation" yes; then
      echo "Execute this"
    fi

Open url on web browser:

    taito::open_browser "https://mydomain.com/path"

#### Command execution flow

Call next item on the command execution chain:

    echo "Executed before next"
    taito::call_next "${@}"
    echo "Executed after next"

Skip execution if user does not confirm operation:

    taito::confirm "Execute this operation" no || taito::skip_to_next "${@}"
    echo "This is executed only if user confirms the execution"
    taito::call_next "${@}"

Skip execution if current target is not a **container** or **storage**:

    taito::skip_if_not "container storage" "${@}"
    echo "This is executed only for container or storage"
    taito::call_next "${@}"

Execute for all targets of type **database**:

    for db in ${taito_databases[@]}; do
      taito::export_database_config "${db}"
      if [[ ${database_type:-} == "pg" ]]; then
        taito::expose_db_user_credentials "${db}" # TODO: add support for param
        echo "PostgreSQL database:"
        echo "- Instance: ${database_instance}"
        echo "- Host: ${database_host}"
        echo "- Port: ${database_port}"
        echo "- Name: ${database_name}"
        echo "- Username: ${database_app_username}"
        echo "- Password: ${database_app_password}"
      fi
    done

#### Running commands on host

If your plugin needs to run some commands on host machine, execute `taito::execute_on_host COMMANDS` to run them immediately in the background. Alternatively you can use the `taito::execute_on_host_fg COMMANDS` to run the commands on foreground after the taito container has exited. Note that if some of the commands might require user input, you must run the commands on foreground.

Currently this mechanism is used e.g. for executing docker commands on host and launching browser.

#### Committing changes to the Taito CLI container image

If your plugin needs to save some data permanently on the container image, execute `taito::commit_changes`. This asks host to commit changes permanently on the container image. Currently this mechanism is used e.g. in authentication to save credentials on the image.

#### Overriding existing commands

If you need to alter default behaviour of an existing plugin in some way, you can override a single command implementation of a plugin without disabling the whole plugin:

- Create a plugin that provides an alternative implementation for the command
- Create a pre-hook that removes the original command implementation from command chain (TODO reusable Taito CLI function for this)

---

**Next:** [11. Custom project templates](11-custom-project-templates.md)
