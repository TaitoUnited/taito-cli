## 1. Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by shipping all required tools as a Docker container image, implementing the commands with plugins, and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Example:

```
taito zone apply                       # Setup your infrastructure based on some configuration files.
                                       # You can copy one of the examples located in examples/zones.
                                       # Change at least the zone name (taito_zone) to avoid naming conflicts.
...
taito project create: server-template  # Create a new project based on a reusable template
taito env apply                        # Create local development environment
taito start                            # Start the local development environment
taito init                             # Initialize the local database with database tables and development data
taito open client                      # Open application web UI running on local environment
taito info                             # Show user credentials required for signing in, or some other info
taito feat: posts                      # Switch to 'feature/posts' git branch (and create it, as it does not exist yet)
taito stage                            # Stage some changes
taito commit                           # Commit staged changes
taito feat merge                       # Rebase, merge and delete the 'feature/posts' branch, switch back to dev branch
taito env apply:dev                    # Create remote dev environment
...                                    # Push some changes to dev branch to trigger the dev environment build
taito open builds                      # Show build status on browser
taito status:dev                       # Show status of dev environment
taito open client:dev                  # Open application web UI running on dev environment
taito info:dev                         # Show user credentials required for signing in, or some other info
taito logs:server:dev                  # Tail logs of server container running on dev environment
taito db connect:dev                   # Connect to the dev environment database
taito env apply:prod                   # Create production environment
taito env merge:dev prod               # Merge changes between environments: dev -> ... -> prod
taito open builds:prod                 # Show production build status on browser
taito open client:prod                 # Open application web UI running on prod environment
taito open logs:prod                   # Open production environment logs on browser
taito hours add: 6.5                   # Add an work hour entry for today for the current project (to 1-N hour reporting systems)
```

For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/dev/help.txt) or run `taito -h`.

Taito-cli is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito-cli executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since taito-cli is shipped as a Docker container image, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

With the help of *taito-cli* and [taito templates](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/templates.md), infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and DevOps personnel. Person dependency is greatly reduced as all projects feel familiar no matter the underlying infrastucture, or who has set everything up originally.

---

**Next:** [2. Installation and upgrade](02-installation.md)
