# gcp-run plugin

Manage Cloud Run services. Enable `gcp-run:-local` alongside `gcp` in
`taito_plugins`, using `docker-compose:local` for local development.
Do not enable another runtime plugin for the same environment.

Services correspond to `taito_containers` and are named
`${taito_project}-${taito_target_env}-${target}`, matching the Google Terraform
project resources module. Project and region come from `taito_zone` and
`taito_provider_region`. The container list must match the deployed services.

```sh
taito status:dev
```

Status shows readiness and the latest ready revision for each configured service.
Authenticate with `taito auth:dev`; service inspection requires Cloud Run Viewer
permissions.
