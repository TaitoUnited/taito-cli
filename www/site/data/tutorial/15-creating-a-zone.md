# PART IV: Zones

## 15. Creating a zone

> WARNING: Instructions not up-to-date.

1. Create a user account to one of the cloud service platforms. For now, you should choose Google Cloud because Taito CLI support for other cloud providers is still work-in-progress. As a new Google Cloud user you get €300 worth of cloud services for free, so trying will cost you nothing. Go to [Google Cloud console](https://console.cloud.google.com) and log in with your Google user account.

2. Register a domain name, and get a DNS service for configuring IP addresses for the domain. If you don't have these already, you can buy an affordable domain name from [namecheap](https://www.namecheap.com/). Namecheap provides also [DNS](https://www.namecheap.com/domains/freedns/), but since you already have a Google Cloud account, you can also use the [Google Cloud DNS](https://cloud.google.com/dns/docs/) with your domain name.

3. Create a taito zone based on the Google Cloud example with the following commands. Replace `EDIT` with your favorite editor. (TODO: zone create: TEMPLATE)

   ```shell
   cp -r taito-cli/examples/zones/gcloud my-zone
   cd my-zone
   EDIT taito-config.sh
   taito zone apply
   ```

A **taito zone** provides an infrastructure that your projects are deployed on. The Google Cloud example creates you Kubernetes and PostgreSQL clusters among other things. You usually have at least two **taito zones**: one for development and testing purposes, and an another one for production usage. In these exercises, however, you require only one **taito zone**.

Do not confuse taito zones with cloud provider regions and zones. One **taito zone** may use multiple cloud provider regions and zones to achieve high availability and regional resiliency.

If you want to know more, see [Appendix C: Modern server infrastructure](c-modern-server-infrastructure).

TODO:

- use some text from the old example.
- optional: setup remote state for Terraform

---

**Next:** [16. Zone maintenance](/tutorial/16-zone-maintenance)
