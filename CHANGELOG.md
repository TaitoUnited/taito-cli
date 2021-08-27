# Release notes

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
