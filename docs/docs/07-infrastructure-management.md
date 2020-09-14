## 7. Infrastructure management

Taito CLI provides a lightweight abstraction on top of infrastructure and configuration management tools for managing a _zone_. A zone provides basic infrastructure that your projects can rely on. It usually consists of container orchestration, database clusters, monitoring systems, etc. You usually have at least two taito zones: one for development and testing purposes, and another one for production usage.

You can manage your zone using the following commands:

    taito zone create TEMPLATE   # Create a new zone based on a infrastructure template.
    taito zone apply              # Apply infrastructure changes to the zone.
    taito zone status             # Show status summary of the zone.
    taito zone doctor             # Analyze and repair the zone.
    taito zone maintenance        # Execute supervised maintenance tasks interactively.
    taito zone destroy            # Destroy the zone.
    taito project settings        # Show project template settings for the zone.

Do not confuse taito zones with cloud provider regions and zones. Each taito zone may use multiple cloud provider regions and zones to achieve high availability and regional resiliency. Taito zones are created mainly based on maintainability and security concerns instead.

## Creating a zone

You can create a new zone configuration based on one of the [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) as explained in the [3. Quick start](03-quick-start.md) chapter.

You can also use your own infrastructure templates. Just change the infrastructure templates location in your `~/.taito/taito-config.sh` file:

```
template_default_zone_source_git=git@github.com:MyOrg/taito-templates//infrastructure
```

---

**Next:** [8. ChatOps](08-chatops.md)
