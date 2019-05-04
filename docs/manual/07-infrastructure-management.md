## 7. Infrastructure management

Taito CLI provides a lightweight abstraction on top of infrastructure and configuration management tools for managing a *zone*. A zone provides basic infrastructure that your projects can rely on. It usually consists of container orchestration, database clusters, monitoring systems, etc. You usually have at least two taito zones: one for development and testing purposes, and another one for production usage.

You can manage your zone using the following commands:

    taito zone apply          # Apply infrastructure changes to the zone.
    taito zone status         # Show status summary of the zone.
    taito zone doctor         # Analyze and repair the zone.
    taito zone maintenance    # Execute supervised maintenance tasks interactively.
    taito zone destroy        # Destroy the zone.
    taito project settings    # Show project template settings for the zone.

Do not confuse taito zones with cloud provider regions and zones. Each taito zone may use multiple cloud provider regions and zones to achieve high availability and regional resiliency. Taito zones are created mainly based on maintainability and security concerns instead.

You can use one of the examples located in [examples/zones](https://github.com/TaitoUnited/taito-cli/tree/master/examples/zones) as a starting point for your infrastructure, and customize it according to your own requirements. For security critical needs you should also consider some additional steps, for example:

- Backup all data to another cloud provider.
- Setup a secure bastion host for accessing critical resources and leave audit trail of all connections.
- Limit egress traffic in addition to ingress traffic, and monitor suspicious connection attempts.
- Limit Kubernetes network traffic with Kubernetes networking rules.
- Limit Kubernetes namespace access with RBAC.
- Use personal accounts for accessing databases to leave a clear audit trail.
- Reserve a separate IP address and load balancer for each domain or subdomain.
- Prepare for high usage spikes with autoscaling and CDN.
- Prepare for DDoS attacks with services like Cloudflare.
- Use scanners to detect vulnerabilities.
- Use intrusion detection systems, anomaly detection tools, and honeypots for detecting and blocking hacking attempts.

---

**Next:** [8. ChatOps](08-chatops.md)
