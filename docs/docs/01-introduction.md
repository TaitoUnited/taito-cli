## 1. Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by shipping all required tools as a Docker container image, implementing the commands with plugins, and defining project specific settings in a configuration file. CI/CD scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Taito CLI is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito CLI executes all this for you with a single command.

The standardized command set and reusable project templates enable easy collaboration past team limits. Anyone can easily help each other out, whether they are working on the same project or not. It's also much easier to include external personnel to your team when required. And if some old implementation suddenly stops working in production, it's much easier for anyone to quickly investigate the problem and fix it.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since Taito CLI is shipped as a Docker container image, no tools need to be installed on the host operating system. All dependencies are shipped within the container image.

Taito CLI is a lightweight wrapper that reduces technology and vendor lock-in by providing a standard command set on top of various tools. However, there is no lock-in with Taito CLI. You can use all the tools and taito configuration files also directly without Taito CLI, and therefore you can stop using Taito CLI at any time, if you like.

---

**Next:** [2. Installation and upgrade](02-installation.md)
