# Templates

## Infrastructure templates

Taito-cli comes with some simple infrastucture templates that you can use to set up your infrastructure:

* [aws](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/aws): Kubernetes and database clusters running on AWS, and Jenkins for CI/CD.
* [azure](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/azure): Kubernetes and database clusters running on Azure, and Jenkins for CI/CD.
* [bare](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/bare): Kubernetes and database clusters running on virtual machines or dedicated servers, and Jenkins for CI/CD.
* [digital-ocean](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/digital-ocean): Kubernetes and database clusters running on Digital Ocean, and Jenkins for CI/CD.
* [gcloud](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/gcloud): Kubernetes and database clusters running on Google Cloud, and Google Cloud Build for CI/CD.

You can search for more infrastructure templates on [GitHub](TODO).

## Project templates

Officially recommended project templates are listed below. All of them include taito-cli configurations, Terraform scripts, and build scripts for various CI/CD systems. You may find more project templates preconfigured for taito-cli on [GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories).

* [kubernetes-template](https://github.com/TaitoUnited/kubernetes-template): Template for applications and APIs running on Kubernetes. Support for [Knative](https://pivotal.io/knative) and [Istio](https://istio.io/) will be added once they have matured enough. TODO rename the git repository.

* [kubernetes-template-alt](https://github.com/TaitoUnited/kubernetes-template-alt): Alternative stack components for the kubernetes-template. With these you can easily implement your application or API with any technology that fits your requirements. TODO rename the git repository.

* [serverless-platform-template](https://github.com/TaitoUnited/serverless-platform-template): Run serverless functions on any cloud provider using either the Serverless Framework or the full Serverless Platform. Support for [Istio](https://istio.io/) will be added later, making it possible to connect all your microservices together no matter where they are deployed.

* [website-template](https://github.com/TaitoUnited/website-template): Implement a website with a static site generator of your choice (e.g. Gatsby, Hugo or Jekyll). Deploy the website to Kubernetes, GitHub Pages, Netlify, AWS or Google Cloud, and setup an automated multistage publishing process for the website. You can easily run this template alongside with the [kubernetes-template](https://github.com/TaitoUnited/kubernetes-template) or the [serverless-platform-template](https://github.com/TaitoUnited/serverless-platform-template) to build dynamic functionality to your website.

* [wordpress-template](https://github.com/TaitoUnited/wordpress-template): Deploy WordPress on Kubernetes. You can easily run this template alongside with the [kubernetes-template](https://github.com/TaitoUnited/kubernetes-template) or the [serverless-platform-template](https://github.com/TaitoUnited/serverless-platform-template) to build dynamic non-PHP functionality to your website.

* TODO machine learning, kubeflow

* [react-native-template](https://github.com/TaitoUnited/react-native-template): Implement mobile applications with React Native. Continuously build, test, release, and monitor them using the Visual Studio App Center.

* [flutter-template](https://github.com/TaitoUnited/flutter-template): Implement mobile applications with Flutter.

* TODO desktop-app-template: electron, javafx, ...

* [npm-template](https://github.com/TaitoUnited/npm-template): Template for npm libraries.

* TODO tool-template

* [legacy-server-template](https://github.com/TaitoUnited/legacy-server-template): Template for applications and APIs running on server without docker or serverless based technologies. Use this template as an example when you configure taito-cli for your existing server application.
