# Azure plugin

Authentication, db proxy and db proxy hooks are the only mandatory commands that the azure plugin is required to implement. You can use the google container builder or jenkins for CI/CD builds, and google cloud for uptime monitoring, log analytics and DNS settings. And functions should be deployed using the serverless plugin, not by an Azure specific implementation.

Azure zone installation scripts are located at [taito-cli-zone](https://github.com/TaitoUnited/taito-cli-zone).
