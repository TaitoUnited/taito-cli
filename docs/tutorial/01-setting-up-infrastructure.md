## 1. Setting up infrastructure

### 1.1. Install or upgrade taito-cli

See the [installation instructions](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation.md) of the taito-cli manual. If you have already installed taito-cli, you can upgrade it with `taito --upgrade`.

### 1.2. Set up cloud environment, Kubernetes, database cluster and CI/CD pipeline

Taito-cli is designed to be infrastructure agnostic. That is, the same taito-cli commands can be used in any project no matter the technology or infrastructure. These exercises, however, are based on a project template that requires Kubernetes, PostgreSQL, S3 compatible storage bucket and a CI/CD pipeline that is supported by one of the taito-cli plugins. If you don't have an existing infrastructure that provides these already, you can easily set them up by creating a new **taito zone** based on examples that are located in [taito-cli/examples/zones](https://github.com/TaitoUnited/taito-cli/tree/master/examples).

TODO:

* Register a domain name
* Get a Google Cloud account, and authenticate with taito-cli
* OPTIONAL: setup remote state for terraform

You can create a taito zone based on the Google Cloud example with the following commands. Replace `EDIT` with your favorite editor.

```shell
cp -r taito-cli/examples/zones/gcloud my-zone
cd my-zone
EDIT taito-config.sh
taito zone apply
```

A **taito zone** provides an infrastructure that your projects are deployed on (for example Kubernetes clusters, database clusters and cloud services). You usually have at least two taito zones: one for development and testing purposes, and an another one for production usage. In these exercises, however, you require only one taito zone.

Do not confuse taito zones with cloud provider regions and zones. Each taito zone may use multiple cloud provider regions and zones to achieve high availability and regional resiliency. Taito zones are created mainly based on maintainability and security concerns instead.

TODO: use some text from the old example.

---

**Next:** [2. Creating a project](02-creating-a-project.md)
