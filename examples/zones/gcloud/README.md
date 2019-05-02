# Google Cloud example zone

## Links

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Interactive operations

* `taito zone apply`: Apply infrastructure changes to the zone.
* `taito zone status`: Show status summary of the zone.
* `taito zone doctor`: Analyze and repair the zone.
* `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
* `taito zone destroy`: Destroy the zone.

## projects.json

TODO: instructions

## TODO

* Add stackdriver slack channel with terraform?
* taito_zone_authorized_networks: for each in terraform 0.12 https://releases.hashicorp.com/terraform/ (
* Might cause problems on Kubernetes 1.12: https://github.com/terraform-providers/terraform-provider-google/issues/3369
* vertical_pod_autoscaling and kms secrets not supported yet by Terraform provider:
  - https://github.com/terraform-providers/terraform-provider-google/issues/3315
  - https://github.com/terraform-providers/terraform-provider-google/issues/3400
