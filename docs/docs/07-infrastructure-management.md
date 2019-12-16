## 7. Infrastructure management

Taito CLI provides a lightweight abstraction on top of infrastructure and configuration management tools for managing a _zone_. A zone provides basic infrastructure that your projects can rely on. It usually consists of container orchestration, database clusters, monitoring systems, etc. You usually have at least two taito zones: one for development and testing purposes, and another one for production usage.

You can manage your zone using the following commands:

    taito zone create: TEMPLATE   # Create a new zone based on a infrastructure template.
    taito zone apply              # Apply infrastructure changes to the zone.
    taito zone status             # Show status summary of the zone.
    taito zone doctor             # Analyze and repair the zone.
    taito zone maintenance        # Execute supervised maintenance tasks interactively.
    taito zone destroy            # Destroy the zone.
    taito project settings        # Show project template settings for the zone.

Do not confuse taito zones with cloud provider regions and zones. Each taito zone may use multiple cloud provider regions and zones to achieve high availability and regional resiliency. Taito zones are created mainly based on maintainability and security concerns instead.

## Creating a zone

You can use one of the templates located in [taito-templates](https://github.com/TaitoUnited/taito-templates/README.md) as a starting point for your infrastructure, and customize it according to your own requirements:

Set infrastructure template default path in `~/.taito/taito-config.sh` (or `~/.taito/taito-config-ORG.sh`):

```shell
template_default_zone_source_git=git@github.com:TaitoUnited/taito-templates//infrastructure
```

Create a new zone:

```shell
taito [-o ORG] zone create: TEMPLATE
```

---

**Next:** [8. ChatOps](08-chatops.md)
