## 1. Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by shipping all required tools as a Docker container image, implementing the commands with plugins, and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Taito CLI is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito CLI executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since Taito CLI is shipped as a Docker container image, no tools need to be installed on the host operating system. All dependencies are shipped within the container image.

With the help of *Taito CLI* and [taito templates](https://github.com/TaitoUnited/taito-cli/tree/master/docs/templates.md), infrastucture may freely evolve to a flexible multicloud or hybrid cloud without causing too much headache for developers and DevOps personnel. Person dependency is greatly reduced as all projects feel familiar no matter the underlying infrastucture, or who has set everything up originally.

---

**Next:** [2. Installation and upgrade](02-installation.md)
