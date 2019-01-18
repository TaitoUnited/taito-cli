# PART I: Basics

## 1. Starting a new project

### 1.1. Planning and design

Normally you would start your project by doing some preliminary project planning, requirements engineering and UX design. However, these are out of scope for this technology oriented tutorial.

Based on requirements you choose your architecture and make some preliminary software design decisions.
[APPENDIX C: Modern server infrastructure](c-modern-server-infrastructure.md) and [APPENDIX B: Software design](b-software-design.md) may help you with this. In addition, you should also validate your core architectural and design decisions at the beginning of the project. Questions like "Progressive web app, hybrid app, or native app?" need to be answered before the implementation can fully begin. If you are unsure of some of your decisions, the validation may include also prototyping and even performance testing, if required.

But since this is a tutorial, we can jump right into the implementation.

### 1.2. Creating a new project based on a project template

First make sure that your taito-cli is up-to-date by running `taito --upgrade`. You should also make sure that [Node.js](https://nodejs.org/) and [Docker Compose](https://docs.docker.com/compose/install/) have been installed, and are up-to-date. If you haven't installed taito-cli yet, read [introduction](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/01-introduction.md) and [installation](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation.md) chapters of the taito-cli manual, and install taito-cli according to the instructions.

Create a new project based on the [server-template](https://github.com/TaitoUnited/server-template) by running one of the following commands (`a)` or `b)`). In most cases you should choose the option `a)`. If, however, you work for multiple organizations, you can use the option `b)` to define the organization in question.

> Instead of creating a new project, you can alternatively use an existing playground project provided by your organization. You can list all playground projects with `taito open playgrounds` or `taito -o ORGANIZATION open playgrounds`. Choose the one that has been created based on the [server-template](https://github.com/TaitoUnited/server-template) and seems to be up-to-date.

**a) Create the project using your default settings**

```shell
taito project create: server-template
```

**b) Create the project using default settings of an organization:**

```shell
# TODO: test if this works
taito -o ORGANIZATION project create: TaitoUnited/server-template
```

Follow the instructions provided by the command. Use **acme** as company name to differentiate it from real customers. You can choose the application name however you like, but if you are using a shared infrastucture, try to avoid naming conflicts with your colleagues. The example application should consist of a **web user interface**, **API**, **relational database** and a **object storage bucket**. The kubernetes-template supports multiple technologies, but during these exercises it is recommended for you to use the default **React** + **Node.js** stack.

---

**Next:** [2. Local development](02-local-development.md)
