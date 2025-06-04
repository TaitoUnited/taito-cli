# Taito CLI

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by shipping all required tools as a Docker container image, implementing the commands with plugins, and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

To get started see the [website](https://taitounited.github.io/taito-cli/). For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt) or run `taito -h`. For troubleshooting, see [trouble.txt](https://github.com/TaitoUnited/taito-cli/blob/master/trouble.txt) or run `taito trouble`.

## Container images

Taito CLI [container repository](https://github.com/TaitoUnited/taito-cli/pkgs/container/taito-cli) provides the following stable image optimized for local command line usage:

- `cli`: Taito CLI image to be used locally on command line. This is the default Docker image for Taito CLI. It includes tools for all major cloud providers.

Stable images optimized for CI/CD:

- `ci`: CI/CD image for building and testing.
- `ci-dockerd`: CI/CD image for building and testing. Includes also dockerd that is required in some CI/CD environments.
- `ci-deploy`: CI/CD image for deployment without any cloud provider specific tools.
- `ci-aws`: CI/CD image for deployment on **Amazon Web Services**.
- `ci-azure`: CI/CD image for deployment on **Microsoft Azure**.
- `ci-gcp`: CI/CD image for deployment on **Google Cloud Platform**.
- `ci-do`: CI/CD image for deployment on **Digital Ocean**.
- `ci-openshift`: CI/CD image for deployment on **OpenShift**.
- `ci-all`: CI/CD image that includes tools for all cloud providers.

> TIP: If your CI/CD pulls the whole Docker image on each build, optimize the image pull by setting up caching on your CI/CD, or by using your own Docker registry as a mirror. You can also create a custom Docker image that includes only the tools you actually need.

> TIP: Read [this](https://taitounited.github.io/taito-cli/docs/06-continuous-integration-and-delivery#cicd-without-taito-cli) if you cannot use Taito CLI on your CI/CD or you want to avoid pulling a Taito CLI docker container image on each build.

Special purpose Docker images:

- `all`: Taito CLI image that contains all tools required either locally or on CI/CD. It is used for running the Taito CLI [integration test suite](https://github.com/TaitoUnited/taito-cli-test).

Alternative versions for each image:

- `*-canary`: Canary version includes all the latest implemented features.
- `*-dev`: Development version includes the latest changes made during Taito CLI development.
- `*-N.N.N`: Docker image tagged with Taito CLI version number in case you need an older version of Taito CLI. Note that it is recommended to always use the latest stable Taito CLI release available instead of a tagged version.

## Contributing

TODO: Something about Taito CLI vs external extensions.

## Development

### Website development

For website development, see the [www/README.md](www/README.md).

### Taito CLI development

Install Taito CLI normally using the [installation instructions](https://taitounited.github.io/taito-cli/docs/02-installation/). The installation clones this github repository to your local disk and you can run a taito command in development mode by using the `-d, --dev` flag (e.g. `taito -d status`). In the development mode your local taito-cli directory is mounted in the Taito CLI container. If you are unsure of the installation location, you can check it with `which taito`.

How to implement a command:

1. Either fork the taito-cli repository or just create a new branch for your changes, if you have permissions to do so. Note that if you are working with your own fork, you need to update your PATH or taito symlink so that it points to your forked version of the Taito CLI.
2. Add a new bash(.sh), ~python(.py)~ or ~javascript(.js)~ file to one of the plugin folders and make it executable with `chmod +x FILE`. Try to implement one of the Taito CLI prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. ~Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.~
4. Make sure that the plugin description written in plugin README.md is up-to-date.
5. Documentation:
   - If you introduced new commands for the Taito CLI standard command set, add the new commands to the `help.txt`, `plugins/autocomplete`, and `plugins/descriptions` files.
   - If you introduced plugin specific commands, add the new commands to the `plugins/myplugin/README.md`, `plugins/autocomplete`, and `plugins/descriptions` files. Note that plugin specific commands should be avoided, as it's best to use the same standard command set on all plugins.
6. Add the plugin to [plugins.md](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md) file if it is not there already.
7. Make a pull request.

How to run a command in a feature branch:

1. Check out your local `.taito-cli` repository to the feature branch.
2. Make sure the new commands are executable (check step 2. in "How to implement a command").
3. Add the plugin with the new command to the projects' taito-cli config by adding the plugin name to taito_plugins in `<project-root>/scripts/taito/project.sh`.
4. Run the command with the `-d` flag.

Links:

- [Example](https://github.com/TaitoUnited/taito-cli/tree/master/examples/project-and-extension/extension): Example extension with simple command examples.
- [Taito CLI library](https://taitounited.github.io/taito-cli/docs/10-custom-plugins#taito-cli-library): Most common reusable functions.
- [Taito CLI docs](https://taitounited.github.io/taito-cli/docs)
- [Taito CLI tutorial](https://taitounited.github.io/taito-cli/tutorial)

## License

Taito CLI is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE) and maintained by [Taito United](https://www.taitounited.fi/).
