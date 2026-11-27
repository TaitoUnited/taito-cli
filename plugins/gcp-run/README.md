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

```sh
taito restart:server:dev
taito restart:server:pr-123
taito restart:dev
```

Restart creates a ready revision using the deployed image digest, without a build
or Terraform apply. It reserves `TAITO_RESTART_NONCE`; a later Terraform apply may
remove it. Only ready, single-container services with 100% untagged traffic
following latest are supported. Services restart sequentially and stop on failure.
Avoid concurrent deployments. Old requests may finish on the previous revision.

Secret environment references to `latest` refresh on startup; numbered versions
stay pinned. Mounted secrets refresh on reads, but applications may cache them.
Rerunning GitHub Actions only restarts the app if the workflow deploys or restarts it.
Restart requires Cloud Run deployment permissions, access to the image, and
permission to act as the runtime service account. The runtime account retains its
existing Secret Manager access; the CLI does not read secret values.

```sh
taito logs:server:dev
taito logs:server:pr-123
```

Logs follow the selected service until interrupted. Instance indexes are not
supported. This uses Google's beta log tail command and requires Logs Viewer
permissions and the `log-streaming` component (included in GCP-capable images).

```sh
taito shell:server:dev
taito shell:server:pr-123
```

Shell uses Google's preview SSH support. Configure a second-generation service,
enable SSH, and grant the required API/IAM access as described in
[Cloud Run SSH setup](https://docs.cloud.google.com/run/docs/troubleshooting/ssh).
Taito does not enable SSH or change permissions. Keep SSH settings in your
infrastructure configuration so Terraform does not undo them.
Only single-container services with one serving revision are supported; instance
indexes are unsupported. Google selects an instance and may start one if needed.
Exit the shell to disconnect; the instance may continue running.

`taito kill:server:dev` is unsupported and exits with an error. Use
`taito restart:server:dev` to replace the service revision instead.
