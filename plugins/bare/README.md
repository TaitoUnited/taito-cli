# Bare-metal plugin

Authentication, db proxy and db proxy hooks are the only mandatory commands that the bare-metal plugin is required to implement. You can use the google container builder or jenkins for CI/CD builds, and google cloud for uptime monitoring, log analytics and DNS settings. EFK is also an option for log analytics. And functions are deployed on Kubernetes using Fission.

Bare-metal-zone installation scripts are located at [taito-cli-zone](https://github.com/TaitoUnited/taito-cli-zone).
