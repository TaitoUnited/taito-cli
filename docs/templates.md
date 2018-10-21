# Templates

## Infrastructure templates

Taito-cli comes with some simple infrastucture templates that you can use to set up your infrastructure:

* [aws](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/aws): Kubernetes and database clusters running on AWS. Use Jenkins for CI/CD.
* [azure](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/azure): Kubernetes and database clusters running on Azure. Use Jenkins for CI/CD.
* [bare](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/bare): Kubernetes and database clusters running on virtual machines or dedicated servers. Use Jenkins for CI/CD.
* [digital-ocean](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/digital-ocean): Kubernetes and database clusters running on Digital Ocean. Use Jenkins for CI/CD.
* [gcloud](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones/gcloud): Kubernetes and database clusters running on Google Cloud. Use Google Cloud Build for CI/CD.

You can search for more infrastructure templates on [GitHub](TODO).

## Project templates

Officially recommended project templates are listed below. All of them include taito-cli configurations and CI/CD setups out-of-the-box, but you can use them also without taito-cli. You can find more project templates preconfigured for taito-cli on [GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories).

* [kubernetes-template](https://github.com/TaitoUnited/kubernetes-template): Template for applications and APIs running on Kubernetes. Support for [Knative](https://pivotal.io/knative) and [Istio](https://istio.io/) will be added once they have matured enough. TODO rename the git repository.

* [kubernetes-template-alt](https://github.com/TaitoUnited/kubernetes-template-alt): Alternative stack components for the kubernetes-template. With these you can easily implement your application or API with any technology that fits your requirements. TODO rename the git repository.

* [serverless-platform-template](https://github.com/TaitoUnited/serverless-platform-template): Run serverless functions on any cloud provider using either the Serverless Framework or the full Serverless Platform. Support for [Istio](https://istio.io/) will be added later, making it possible to connect all your microservices together no matter where they are deployed.

* [gatsby-template](https://github.com/TaitoUnited/gatsby-template): Implement static websites with Gatsby and deploy them to Kubernetes, GitHub Pages, Netlify, AWS or Google Cloud. If your system consists of static pages, dynamic UI snippets and backend services, you can easily run the [gatsby-template](https://github.com/TaitoUnited/gatsby-template) alongside with the [kubernetes-template](https://github.com/TaitoUnited/kubernetes-template).

* [wordpress-template](https://github.com/TaitoUnited/wordpress-template): Deploy WordPress on Kubernetes.

* [react-native-template](https://github.com/TaitoUnited/react-native-template): Implement mobile applications with React Native. Continuously build, test, release, and monitor them using the Visual Studio App Center.

* [flutter-template](https://github.com/TaitoUnited/flutter-template): Implement mobile applications with Flutter.

* [npm-template](https://github.com/TaitoUnited/npm-template): Template for npm libraries.

* [legacy-kubernetes-template](https://github.com/TaitoUnited/legacy-kubernetes-template): Template for applications and APIs running on server without docker or serverless based technologies. Use this template as an example when you configure taito-cli for your existing server application.
