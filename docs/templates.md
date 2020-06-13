# Templates

## Project templates

Officially recommended project templates are listed below. All of them include taito configurations for Taito CLI, Terraform scripts for multiple platforms, and build scripts for multiple CI/CD tools. You may also find more project templates preconfigured for Taito CLI on [GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories).

> Run `taito [-o ORG] project create: TEMPLATE` to create a project (e.g `taito project create: full-stack-template`).

* [full-stack-template](https://github.com/TaitoUnited/full-stack-template): Template for cloud-native applications and microservices running on Kubernetes, Docker Compose, serverless (FaaS), or virtual machine. You can choose the stack during project creation.

* [website-template](https://github.com/TaitoUnited/website-template): Template for websites generated with a static site generator (e.g. Gatsby, Hugo or Jekyll), and running on CDN, Kubernetes, Docker Compose, or virtual machine. Supports an automated multistage publishing process. Netlify CMS support also coming soon. You can easily run the [full-stack-template](https://github.com/TaitoUnited/full-stack-template) alongside with this template to implement dynamic functionality for your website. TODO: Combine full-stack-template and website-template

* [wordpress-template](https://github.com/TaitoUnited/wordpress-template): Template for WordPress sites running on Kubernetes, Docker Compose, or virtual machine. You can easily run the [full-stack-template](https://github.com/TaitoUnited/full-stack-template) alongside with this template to implement dynamic non-PHP functionality for your website.

* [react-native-template](https://github.com/TaitoUnited/react-native-template): Template for React Native applications. Visual Studio App Center for CI/CD and monitoring.

* [minimal-template](https://github.com/TaitoUnited/minimal-template): Minimal project template for Taito CLI. It includes support for version control, code quality checking, links, and npm. It also provides CI/CD templates for multiple providers, and some documentation templates.

* [npm-template](https://github.com/TaitoUnited/npm-template): Template for npm libraries. Includes monorepo support.

* TODO: Data warehouse, analytics, machine learning

## Infrastructure templates

You can use these infrastructure templates as a starting point for your infrastructure. You may also find more infrastructure templates on [GitHub](TODO).

> Run `taito [-o ORG] zone create: TEMPLATE` to create a zone (e.g `taito zone create: gcp`).

### Serverless (FaaS) on any platform

Use one of the **Kubernetes as a service** infrastructure templates, but do not install Kubernetes if you don't need one. You can create new projects based on the [full-stack-template](https://github.com/TaitoUnited/full-stack-template/) which supports both containers and functions.

### Kubernetes, database, and object storage as a service

* [alibaba](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/alibaba): Alibaba Cloud (TODO)
* [aws](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/aws): Amazon Web Services
* [azure](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/azure): Microsoft Azure
* [do](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/do): Digital Ocean
* [gcp](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/gcp): Google Cloud Platform
* [openshift](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/openshift): OpenShift (TODO)
* [scaleway](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/scaleway): Scaleway (TODO)
* [vmware](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/vmware): VMWare Cloud (TODO)

### Kubernetes distributions for cloud and on-premises

* [kubespray](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/kubespray): Kubespray (TODO)

[kubernetes.io: pick-right-solution](https://kubernetes.io/docs/setup/pick-right-solution/)

### Linux

Infrastructure based on Linux virtual machines or dedicated servers.

* [linux](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/linux): Any Linux servers

### Additional security steps

For critical security needs you should consider some additional security steps that might not be provided out-of-the-box by the infrastructure template you selected. For example:

- Backup all data to another cloud provider.
- Setup a secure bastion host or virtual network interconnectivity for accessing critical resources, and leave audit trail for all connections.
- Limit egress traffic in addition to ingress traffic, and monitor suspicious outbound connection attempts.
- Limit Kubernetes network traffic with Kubernetes networking rules.
- Limit Kubernetes namespace access with RBAC.
- Require container images to be signed by trusted authorities.
- Use personal accounts for accessing databases to leave audit trail.
- Reserve a separate IP address and load balancer for each domain or subdomain.
- Prepare for high usage spikes with autoscaling and CDN.
- Prepare for DDoS attacks with services like Cloudflare.
- Use scanners to detect vulnerabilities.
- Use intrusion detection systems, anomaly detection tools, and honeypots for detecting and blocking hacking attempts.

TODO: Improve infrastructure templates with additional security features.
