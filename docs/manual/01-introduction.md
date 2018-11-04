## 1. Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Some examples:

```
taito vc feat list              # List all feature branches
taito vc feat: orders           # Switch to feature/orders branch (or create it)
taito start                     # Start the local development environment
taito init                      # Initialize local db with database tables and development data
taito open app                  # Open application web UI running on local environment
taito info                      # Show user credentials required for signing in
taito vc feat merge             # Rebase, merge and delete the feature branch, switch to dev branch.
taito open builds               # Show build status on browser
taito status:dev                # Show status of dev environment
taito open app:dev              # Open application web UI running on dev environment
taito logs:worker:dev           # Tail logs of worker container running on dev environment
taito db connect:dev            # Connect to the dev environment database
taito vc env merge: dev canary  # Merge changes between multiple environments: dev -> ... -> canary
taito open logs:canary          # Open canary environment logs on browser
taito hours add: 6.5            # Add an work hour entry for current project (to multiple systems)
```

For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/dev/help.txt) or run `taito -h`.

Taito-cli is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito-cli executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since taito-cli is shipped as a Docker container image, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

With the help of *taito-cli* and [taito templates](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/templates.md), infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and DevOps personnel. Person dependency is greatly reduced as all projects feel familiar no matter the underlying infrastucture, or who has set everything up originally.

---

**Next:** [2. Installation and upgrade](02-installation.md)
