# Taito CLI website

Implement with Gatsby v2. Layout should probably be something between [reactjs.org](https://reactjs.org/) and [gatsbyjs.org](https://gatsbyjs.org/). Use [Taito United](http://taitounited.fi/) brand for appearance. Site content already exists in the docs folder as markdown files.

See [website configuration](../WEBSITE.md#configuration) on how to create and configure the site.

## Content

All content can already be found from `docs` folder as markdown files.

### Tabs on top of the page

* [Docs](https://github.com/TaitoUnited/taito-cli/tree/master/docs/manual/README.md)
* [Tutorial](https://github.com/TaitoUnited/taito-cli/tree/master/docs/tutorial/README.md)
* [Plugins](https://github.com/TaitoUnited/taito-cli/tree/master/docs/plugins.md)
* [Templates](https://github.com/TaitoUnited/taito-cli/tree/master/docs/templates.md)
* [Extensions](https://github.com/TaitoUnited/taito-cli/tree/master/docs/extensions.md)
* Search (optional)
* [GitHub](https://github.com/TaitoUnited/taito-cli)

### Center area of the landing page

Big title: **Taito CLI**

Subtitle: An extensible toolkit for DevOps and NoOps.

Links/buttons: [Get started](https://github.com/TaitoUnited/taito-cli/tree/master/docs/manual/README.md) or [see the tutorial](https://github.com/TaitoUnited/taito-cli/tree/master/docs/tutorial/README.md).

### Slogans at the bottom of the landing page

#### Standard command set

Use the same simple command set from project to project no matter the technology or infrastructure. Easily manage your containers, functions, databases, object storages, and legacy applications wherever they are deployed. Just add a taito configuration file to your project, and you're good to go.

```
taito deployment deploy:test
taito status:test
taito open client:test
taito db copy:dev test
```

See the [command reference](https://github.com/TaitoUnited/taito-cli/blob/dev/help.txt).

#### Preconfigured templates

Use preconfigured templates to set up your infrastructure and to deploy new projects on top of it. Everything works out-of-the-box with minimal configuration.

```
taito zone create: gcloud
taito zone apply

taito project create: full-stack
taito env apply:dev
taito env apply:canary
taito env apply:prod
```

#### Simple to use

To connect to the test database, you write this:

```
taito db connect:test
```

Instead of this:

```
cloud_sql_proxy -instances=acme-zone:europe-west1:acme-postgres=tcp:0.0.0.0:5001
psql -h 127.0.0.1 -p 5001 -d acme_chat_test -U acme_chat_test
Password: ****************
```

#### Modern CI/CD

Taito CLI is shipped as a Docker container, and it is a good fit with modern container-based CI/CD pipelines.

```
taito build prepare:dev
taito artifact prepare:client:dev
taito artifact prepare:server:dev
taito db deploy:dev
taito deployment deploy:dev
taito test:dev
taito artifact release:client:dev
taito artifact release:server:dev
taito build release:dev
```

#### All tools included

Working with modern multicloud and hybrid cloud environments requires lots of tools. Taito CLI Docker container image contains all the tools you need, and you can upgrade it anytime by running `taito upgrade`. And if you need something special, it is very easy to customize the Taito CLI image with your own requirements.

```
taito -- terraform apply
taito -- kubectl get pods --namespace acme-chat-dev
taito -- gcloud dns managed-zones list
taito -- aws ec2 describe-instances
```

#### No lock-in

Taito CLI is a lightweight wrapper that reduces technology and vendor lock-in by providing a standard command set on top of various tools. However, you can use those tools also directly without Taito CLI, and therefore you can stop using Taito CLI at any time, if you like.

```
taito --verbose status:dev

+ kubectl config use-context acme-chat-dev
+ kubectl get cronjobs
+ kubectl get pods
+ kubectl top pod
+ helm list --namespace acme-chat-dev
```

#### Extensible

Add Taito CLI support for any technology by implementing a Taito CLI plugin. Create custom commands and share them with your colleagues as Taito CLI extensions. Implement project specific Taito CLI commands with npm or make.

```
taito order pizza: quattro stagioni
taito hours add: 6.5
```

#### Uniform conventions

Maintain good and uniform conventions by providing reusable infrastructure and project templates. Customize your workflows with custom Taito CLI plugins, if necessary.
