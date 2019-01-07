# Templates

## Infrastructure templates

Taito-cli comes with some simple infrastucture templates that you can use as an example to set up your infrastructure. You may also find more infrastructure templates on [GitHub](TODO).

> NOTE: Only the Google Cloud example has currently been implemented. Contributions are welcome.

### Managed public cloud infrastructure

* [AWS](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/aws)
* [Azure](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/azure)
* [DigitalOcean](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/digital-ocean)
* [Google Cloud](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/gcloud)
* [Scaleway](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/scaleway)

### Self-managed infrastructure

The self-managed examples can be deployed anywhere, on-premise or public cloud. They include Kubernetes, PostgreSQL and Minio.

* [Kubeadm](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/kubeadm): Basic Kubernetes setup with Kubeadm and Ansible.

> [kubernetes.io: pick-right-solution](https://kubernetes.io/docs/setup/pick-right-solution/)

### CI/CD

3rd party services like [GitHub actions](https://github.com/features/actions), [GitLab CI/CD](https://about.gitlab.com/product/continuous-integration/) and [Google Cloud Build](https://cloud.google.com/cloud-build/) suffice for simple cases. If you have special requirements for your CI/CD pipeline, you may choose to install [Spinnaker](https://github.com/helm/charts/tree/master/stable/spinnaker) or [Jenkins](https://github.com/helm/charts/tree/master/stable/jenkins) to your Kubernetes cluster. For example, you might want to use 3rd party CI/CD services during development to build and test you containers, and Spinnaker/Jenkins to deploy them to production in a more secure and controlled manner.

## Project templates

Officially recommended project templates are listed below. All of them include taito configurations for taito-cli support, Terraform scripts for infrastucture management, and build scripts for CI/CD. You may also find more project templates preconfigured for taito-cli on [GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories).

* [kubernetes-template](https://github.com/TaitoUnited/server-template): Template for applications and APIs running on Kubernetes. Support for [Knative](https://pivotal.io/knative), [Istio](https://istio.io/) and [Telepresence](https://www.telepresence.io/) will be added once they have matured enough. TODO rename the git repository.

* [kubernetes-template-alt](https://github.com/TaitoUnited/server-template-alt): Alternative stack components for the kubernetes-template. With these you can easily implement your application or API with any technology that fits your requirements. TODO rename the git repository.

* [serverless-template](https://github.com/TaitoUnited/serverless-template): This is essentially the same as [kubernetes-template](https://github.com/TaitoUnited/server-template), but Kubernetes has been replaced with the [Serverless Framework](https://serverless.com/framework/). Using this template you can easily deploy serverless functions on any cloud provider. Support for [Istio](https://istio.io/) will likely be added later, making it possible to connect all your microservices together no matter where they have been deployed.

* [server-template](https://github.com/TaitoUnited/server-template): This is essentially the same as [kubernetes-template](https://github.com/TaitoUnited/server-template), but software is run directly on host instead of containers on remote environments. Docker Compose is, however, used for local development. You can use this template as an example when you need to configure taito-cli for your existing legacy server application.

* [website-template](https://github.com/TaitoUnited/website-template): Implement a website with a static site generator of your choice (e.g. Gatsby, Hugo or Jekyll). Deploy the website to Kubernetes, GitHub Pages, Netlify, or any S3-compatible object storage with CDN support (AWS, Azure, Google Cloud, DigitalOcean). Setup an automated multistage publishing process for the website. Optionally use the Netlify CMS to edit your site. You can easily run the [kubernetes-template](https://github.com/TaitoUnited/server-template) or the [serverless-platform-template](https://github.com/TaitoUnited/serverless-platform-template)
alongside with this template to implement dynamic functionality to your website.

* [wordpress-template](https://github.com/TaitoUnited/wordpress-template): Deploy WordPress on Kubernetes. You can easily run the [kubernetes-template](https://github.com/TaitoUnited/server-template) alongside with this template to implement dynamic non-PHP functionality to your website.

* TODO machine learning, kubeflow

* [react-native-template](https://github.com/TaitoUnited/react-native-template): Implement mobile applications with React Native. Continuously build, test, release, and monitor them using the Visual Studio App Center.

* [flutter-template](https://github.com/TaitoUnited/flutter-template): Implement mobile applications with Flutter.

* TODO desktop-app-template: electron, javafx, ...

* [npm-template](https://github.com/TaitoUnited/npm-template): Template for npm libraries. Includes monorepo support.

* TODO tool-template
