# Virtual machines example zone (TODO)

An example for running projects directly on a virtual machine for hobby purposes. For a small amount of simple hobby projects it is more cost effective to run them on a virtual machine instead of using Kubernetes and database clusters as a service.

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
* `taito project settings`: Show project template settings for this zone.

## projects.json

TODO: instructions

## TODO

1) Add ansible script examples for setting up one or more virtual machines: firewall, ssh key login, no root login, no password login, start service (e.g. docker-compose) on boot, etc.
2) Add taito-cli ansible plugin that runs ansible scripts on `taito zone apply` and `taito zone destroy`.
3) On server-template add support for `vm` provider:
   - On `taito deployment deploy:ENV`, run a custom shell script on the virtual machine (e.g. `git pull && service restart`).
   - Use ssh plugin as a database proxy, for example:
     ```
       taito_plugins="ssh:-local"

       # ssh plugin settings
       . "${taito_util_path}/read-database-config.sh" "${taito_target}"
       ssh_db_proxy="-L 0.0.0.0:${database_proxy_port}:${database_instance}:${database_port} username@${database_proxy_host}"
       ssh_forward_for_db="${ssh_db_proxy}"
     ```
