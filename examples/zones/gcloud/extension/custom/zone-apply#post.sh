#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "This example provides a basic setup that serves as a starting point."
echo "Depending on your requirements you should consider some additional"
echo "security measures at least for production environments. Some tips:"
echo
echo "- Backup all data to another cloud provider. See examples/backups"
echo "  directory for some example scripts that may be useful."
echo "- Limit egress traffic with network firewall rules and monitor suspicious"
echo "  connection attempts. This may be a bit challenging if you use a lot of"
echo "  external services."
echo "- Limit network traffic with Kubernetes networking rules. Note that this"
echo "  requires more processing power from your Kubernetes nodes."
echo "- Limit Kubernetes namespace access with RBAC."
echo "- Use personal accounts for accessing databases to leave a clear audit"
echo "  trail."
echo "- Reserve a separate IP address and load balancer for each domain name."
echo "- Prepare for high usage spikes with autoscaling and CDN."
echo "- Prepare for DDoS attacks with services like Cloudflare."
echo "- Use monitoring and anomaly detection tools for detecting hacking"
echo "  attempts."
echo "https://cloud.google.com/blog/products/networking/bringing-enterprise-network-security-controls-to-your-kubernetes-clusters-on-gke"
echo

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
