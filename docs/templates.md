# Templates

## Project templates

Officially recommended project templates are listed below. All of them include taito configurations for Taito CLI, Terraform scripts for infrastucture management, and build scripts for CI/CD. You may also find more project templates preconfigured for Taito CLI on [GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories).

> Run `taito [-o ORG] project create: TEMPLATE` to create a project (e.g `taito project create: full-stack-template`).

* [full-stack-template](https://github.com/TaitoUnited/server-template): Template for applications and APIs running on Kubernetes, Docker Compose, serverless functions, or virtual machine. You can choose the stack during project creation. Support for event-driven microservices (Kafka) and Istio service mesh coming soon.

* [website-template](https://github.com/TaitoUnited/website-template): Template for websites generated with a static site generator (e.g. Gatsby, Hugo or Jekyll), and running on CDN, Kubernetes, Docker Compose, or virtual machine. Supports an automated multistage publishing process. Netlify CMS support also coming soon. You can easily run the [full-stack-template](https://github.com/TaitoUnited/server-template) alongside with this template to implement dynamic functionality to your website.

* [wordpress-template](https://github.com/TaitoUnited/wordpress-template): Template for WordPress sites running on Kubernetes, Docker Compose, or virtual machine. You can easily run the [full-stack-template](https://github.com/TaitoUnited/server-template) alongside with this template to implement dynamic non-PHP functionality to your website.

* [react-native-template](https://github.com/TaitoUnited/react-native-template): Template for react-native applications. Visual Studio App Center for CI/CD and monitoring.

* [npm-template](https://github.com/TaitoUnited/npm-template): Template for npm libraries. Includes monorepo support.

* TODO flutter

* TODO machine learning, kubeflow

* TODO data warehouse, analytics

* TODO desktop: electron, javafx, ...

* TODO tool-template

## Infrastructure templates

You can use these infrastructure templates as a starting point for your infrastructure. You may also find more infrastructure templates on [GitHub](TODO).

> Run `taito [-o ORG] zone create: TEMPLATE` to create a zone (e.g `taito zone create: gcp`).

### Serverless (FaaS) on any platform

Use one of the **Kubernetes as a service** infrastructure templates, but do not install Kubernetes if you don't need one. You can create new projects based on the [full-stack-template](https://github.com/TaitoUnited/server-template/) which supports both containers and functions.

### Kubernetes, database, and object storage as a service

* [aws](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/aws): Amazon Web Services
* [azure](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/azure): Microsoft Azure (Coming soon)
* [digitalocean](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/digitalocean): Digital Ocean (Coming soon)
* [gcp](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/gcp): Google Cloud Platform
* [scaleway](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/scaleway): Scaleway (TODO)
* [vmware](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/vmware): VMWare Cloud (Coming soon)

### Kubernetes distributions for cloud and on-premises

* [kontena](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/kontena): Kontena Pharos (TODO)
* [openshift](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/openshift): OpenShift (TODO)

[kubernetes.io: pick-right-solution](https://kubernetes.io/docs/setup/pick-right-solution/)

### Linux

Infrastructure based on Linux virtual machines or dedicated servers.

* [linux](https://github.com/TaitoUnited/taito-infrastructure/tree/master/templates/linux): Any Linux servers (Coming soon)

### Additional security steps

For critical security needs you should consider some additional security steps, for example:

- Backup all data to another cloud provider.
- Setup a secure bastion host for accessing critical resources and leave audit trail for all connections.
- Limit egress traffic in addition to ingress traffic, and monitor suspicious outbound connection attempts.
- Limit Kubernetes network traffic with Kubernetes networking rules.
- Limit Kubernetes namespace access with RBAC.
- Use personal accounts for accessing databases to leave audit trail.
- Reserve a separate IP address and load balancer for each domain or subdomain.
- Prepare for high usage spikes with autoscaling and CDN.
- Prepare for DDoS attacks with services like Cloudflare.
- Use scanners to detect vulnerabilities.
- Use intrusion detection systems, anomaly detection tools, and honeypots for detecting and blocking hacking attempts.

TODO: Improve examples with additional security features.
