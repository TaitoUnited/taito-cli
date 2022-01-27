# Release notes

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## 0.296.0

- Switch between arm64 and amd64 images on Apple Silicon (m1) mac by running
  `taito --amd64 upgrade` and `taito --arm64 upgrade`.

## 0.295.0

- Now aws-secrets plugin uses AWS Secrets Manager to store secrets. Use
  the aws-secrets-ssm plugin if you would like to save secrets to SSM parameter
  store.
- Store credentials on host (encrypted on admin mode).

## 0.294.0

- Use taito user by default on CI/CD images.
- Added taito_save_credentials_on_host setting for saving Kubernetes and cloud
  provider credentials on host.
- Added 'taito env init' and 'taito zone init' commands for updating Terraform
  lock files.

## 0.293.1

Fixes:

- Add git dependency back to taito-cli:cli image.

## 0.293.0

- Added taito-cli:ci-deploy and taito-cli:ci-dockerd docker images.
- Added possibility to alternatively save cloud provider and kube credentials
  on host.
- Improve info output for 'commit Taito CLI changes'.
- Test command execution on host during 'taito check'.
- Add 'crawl' to the list of Taito CLI command verbs.

## 0.292.0

- Moved Taito CLI docker images to GitHub container registry (ghcr.io)
- Added 'taito version' command.
