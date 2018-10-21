# Taito-cli

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a predefined set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure.

```
TODO few examples
```

This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

To get started see the [manual](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/manual/README.md) or the [tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/README.md).

## Development

Install taito-cli using the installation instructions provided by the taito-cli manual. You can run taito-cli commands in development mode by using the `-d, --dev` flag (e.g. `taito -d env apply:dev`). In the development mode your local taito-cli directory is mounted on the container. If you are working with your own fork, update your taito symlink so that it points to your forked version (you originally created the symlink during taito-cli installation).

1. Fork taito-cli repository (or create a new feature branch if you have write permissions to taito-cli repository).
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.
4. TODO autocompletion
5. Add description of your implementation in your plugin README.md. Concentrate on explaining how your plugin is designed to work with other plugins, e.g. which environent variables it expects and which it exports for others to use.
6. If you did not implement any of the predefined commands, add your command usage description in plugin help.txt file.
7. Make a pull request.

## Contributing

TODO something about taito-cli vs external extensions.

## License

Taito-cli is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
