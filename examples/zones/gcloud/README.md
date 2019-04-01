# gcloud example zone

TODO:
* Configure devops project
* Wait for terraform 0.12 https://releases.hashicorp.com/terraform/ (for each -> taito_zone_authorized_networks)
* Not supported yet: vertical_pod_autoscaling, kms secrets
https://github.com/terraform-providers/terraform-provider-google/issues/3315

Example for a taito zone located in Google Cloud. Configure settings in `taito-config.sh` and then create the zone by running `taito zone apply`.

## Links

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Interactive operations:

* `taito zone apply`: Apply infrastructure changes to the zone.
* `taito zone status`: Show status summary of the zone.
* `taito zone doctor`: Analyze and repair the zone.
* `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
* `taito zone destroy`: Destroy the zone.

## projects.json

TODO: instructions
