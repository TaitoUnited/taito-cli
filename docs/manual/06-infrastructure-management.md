## 6. Infrastructure management

Taito-cli provides a lightweight abstraction on top of infrastructure and configuration management tools for managing a *zone*. A zone provides basic infrastructure that your projects can rely on. It usually consists of container orhestration and database clusters, logging and monitoring systems, etc. You usually have at least two taito zones: one for development and testing purposes, and another one for production usage.

You can manage your zone using the following commands:

    taito zone apply          # Apply infrastructure changes to the zone.
    taito zone status         # Show status summary of the zone.
    taito zone doctor         # Analyze and repair the zone.
    taito zone maintenance    # Execute supervised maintenance tasks interactively.
    taito zone destroy        # Destroy the zone.

Do not confuse taito zones with cloud provider regions and zones. Each taito zone may use multiple cloud provider regions and zones to achieve high availability and regional resiliency. Taito zones are created mainly based on maintainability and security concerns instead.

---

**Next:** [7. ChatOps](07-chatops.md)
