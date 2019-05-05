locals {
  worker_groups = [
    {
      name                 = "default_worker_group"
      instance_type        = "${var.kubernetes_machine_type}"
      subnets              = "${join(",", module.vpc.private_subnets)}"
      asg_desired_capacity = "${var.kubernetes_min_node_count}"
      asg_min_size         = "${var.kubernetes_min_node_count}"
      asg_max_size         = "${var.kubernetes_max_node_count}"
    },
  ]

  /* TODO enable worker_groups_launch_template?
  worker_groups_launch_template = [
    {
      instance_type                            = "${var.kubernetes_machine_type}"
      subnets                                  = "${join(",", module.vpc.private_subnets)}"
      additional_security_group_ids            = "${aws_security_group.worker_group_mgmt_one.id},${aws_security_group.worker_group_mgmt_two.id}"
      override_instance_type                   = "${var.kubernetes_machine_type_override}"
      asg_desired_capacity                     = "${var.kubernetes_min_node_count}"
      asg_min_size                             = "${var.kubernetes_min_node_count}"
      asg_max_size                             = "${var.kubernetes_max_node_count}"
      spot_instance_pools                      = 10
      on_demand_percentage_above_base_capacity = "0"
    },
  ]
  */

  workers_group_defaults = {
    root_volume_size = "${var.kubernetes_disk_size_gb}"
    root_volume_type = "gp2"
  }

}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "3.0.0"
  cluster_name                         = "${var.kubernetes_name}"
  subnets                              = ["${module.vpc.private_subnets}"]
  tags                                 = "${local.tags}"
  vpc_id                               = "${module.vpc.vpc_id}"
  worker_groups                        = "${local.worker_groups}"
  worker_group_count                   = "1"
  worker_additional_security_group_ids = [ "${aws_security_group.all_worker_mgmt.id}" ]
  workers_group_defaults               = "${local.workers_group_defaults}"

  /* TODO enable worker_groups_launch_template?
  worker_groups_launch_template        = "${local.worker_groups_launch_template}"
  worker_group_launch_template_count   = "1"
  */

  map_roles                            = "${var.map_roles}"
  map_roles_count                      = "${var.map_roles_count}"
  map_users                            = "${var.map_users}"
  map_users_count                      = "${var.map_users_count}"
  map_accounts                         = "${var.map_accounts}"
  map_accounts_count                   = "${var.map_accounts_count}"

  cluster_enabled_log_types = [
    "api","audit","authenticator","controllerManager","scheduler"
  ]

  write_kubeconfig                     = false
  write_aws_auth_config                = false

  kubeconfig_aws_authenticator_env_variables = {
    AWS_PROFILE = "${coalesce(var.taito_provider_user_profile, var.taito_organization)}"
  }
}
