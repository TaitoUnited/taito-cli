# PART I: Basics

## 1. Starting a new project

### 1.1. Prerequisites

If you haven't installed Taito CLI yet, read the [introduction](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/01-introduction) and [installation](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation) chapters of the Taito CLI manual, and install Taito CLI according to the instructions.

If you don't have an existing infrastructure running, read the [setting up infrastructure](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation.md#setting-up-infrastructure) chapter of the Taito CLI manual and set up infrastucture according to the instructions.

### 1.2. Preliminary planning, design and validation

Normally you would start your project by doing some preliminary business modeling, project planning, and requirements engineering. However, these are out of scope for this technology oriented tutorial.

Based on requirements you choose your architecture and make some preliminary software design decisions. [APPENDIX B: Software design](b-software-design) and [APPENDIX C: Modern server infrastructure](c-modern-server-infrastructure) provide some useful information for doing this, but they are not requisite for this tutorial. Note that you should also validate your core architectural and design decisions at the beginning of the project. Questions like _"Progressive web app, hybrid app, or native app?"_ need to be answered before the implementation can fully begin. If you are unsure of some decisions, the validation may include also prototyping, and even performance testing, if it seems essential.

Since this is a tutorial, we can skip all preliminary planning and design, and jump right into the implementation. During implementation you iteratively and incrementally implement your application by defining detailed requirements for top priority features in your backlog, and by designing, implementing and testing each feature one by one.

### 1.3. Creating a new project based on a project template

> Instead of creating a new project, you can alternatively use an existing playground project provided by your organization. You can list all playground projects with `taito open playgrounds` or `taito -o ORGANIZATION open playgrounds`. Choose the one that has been created based on the [server-template](https://github.com/TaitoUnited/server-template) and seems to be up-to-date.

Create a new project based on the [server-template](https://github.com/TaitoUnited/server-template) by running one of the following commands (**a** or **b**). In most cases you should choose the option **a**. If, however, you work for multiple organizations, you can use the option **b** to define the organization in question.

**a) Create the project using your default settings**

```shell
taito project create: server-template
```

**b) Create the project using default settings of an organization**

```shell
# TODO: test if this works
taito -o ORGANIZATION project create: TaitoUnited/server-template
```

Follow the instructions provided by the command. Use **acme** as company name to differentiate it from real companies. You can choose the application name however you like, but if you are using a shared infrastucture, try to avoid naming conflicts with your colleagues. The example application should consist of a **web user interface**, **API**, **relational database** and a **object storage bucket**. The full-stack-template supports multiple technologies, but during these exercises it is recommended for you to use the default **React** + **Node.js** stack.

---

**Next:** [2. Local development](/tutorial/02-local-development)
