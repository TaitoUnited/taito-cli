# Taito-cli

[taito-cli website](https://github.com/TaitoUnited/taito-cli/blob/dev/www/README.md)

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. Some examples:

```
TODO
```

This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

To get started see the [manual](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/manual/README.md) or the [tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/README.md).

For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/dev/help.txt)

## Images

TODO: To speed up builds, use own image repository. Use the smaller images.

* aws
* azure
* gcloud
* appcenter
* all

## Contributing

TODO something about taito-cli vs external extensions.

## Development

Install taito-cli using the installation instructions provided by the taito-cli manual. You can run taito-cli commands in development mode by using the `-d, --dev` flag (e.g. `taito -d env apply:dev`). In the development mode your local taito-cli directory is mounted in the container. If you are working with your own fork, update your taito symlink so that it points to your forked version (you originally created the symlink during taito-cli installation).

How to implement a command:

1. Fork taito-cli repository (or create a new feature branch if you have write permissions to taito-cli repository).
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.
4. Make sure that the plugin description written in plugin README.md is up-to-date.
5. If you implemented some new plugin specific commands, add the command descriptions to the help.txt file of your plugin. Also, add the plugin specific commands to `autocomplete.sh` and `descriptions.sh` files located in root of plugins directory.
6. Add the plugin to [plugins.md](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md) file if it is not there already.
7. Make a pull request.

For detailed instructions, see plugin development instructions on the [manual](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/manual/09-custom-plugins.md) and on the [tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/16-creating-a-plugin.md).

## License

Taito-cli is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
