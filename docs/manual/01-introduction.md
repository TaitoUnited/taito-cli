## 1. Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a predefined set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure.

```
TODO few examples
```

This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Taito-cli is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito-cli executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since taito-cli is shipped as a Docker container image, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

```
TODO few examples
```

With the help of *taito-cli* and [taito templates](https://github.com/search?q=topic%3Ataito-template&type=Repositories), infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and devops personnel. Person dependency of projects is greatly reduced as all projects feel familiar no matter the underlying infrastucture or who has set everything up originally.

TODO command reference (help.txt)

---

**Next:** [2. Installation and upgrade](02-installation.md)
