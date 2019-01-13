# PART I: Basics

## 1. Creating a project

> Instead of creating a new project, you can alternatively use an existing playground project provided by your organization. You can list all playground projects with `taito open playgrounds` or `taito -o ORGANIZATION open playgrounds`. Choose the one that has been created based on the [server-template](https://github.com/TaitoUnited/server-template) and seems to be up-to-date.

First make sure that your taito-cli is up-to-date by running `taito --upgrade`. If you haven't installed taito-cli yet, read [introduction](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/01-introduction.md) and [installation](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation.md) chapters of the taito-cli manual, and install taito-cli according to the instructions.

Create a new project based on the [server-template](https://github.com/TaitoUnited/server-template) by running one of the following commands:

```shell
# a) Create the project using your default settings
taito project create: server-template
```

```shell
# b) Create the project using default settings of an organization:
# TODO: test if this works
taito -o ORGANIZATION project create: TaitoUnited/server-template
```

Follow the instructions provided by the command. Use **acme** as company name to differentiate it from real customers. You can choose the application name however you like, but if you are using a shared infrastucture, try to avoid naming conflicts with your colleagues. The example application should consist of **web user interface**, **API**, **relational database** and a **object storage bucket**. The kubernetes-template supports multiple technologies, but during these exercises it is recommended for you to use the default **React** + **Node.js** stack.

---

**Next:** [2. Local development](02-local-development.md)
