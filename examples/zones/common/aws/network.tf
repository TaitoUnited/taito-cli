/*
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${module.vpc.vpc_id}"
}
*/

module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  version             = "1.60.0"
  name                = "${var.taito_provider_project_id}-vpc"
  tags                = "${merge(local.tags, map("kubernetes.io/cluster/${var.kubernetes_name}", "shared"))}"

  cidr                = "10.10.0.0/16"
  azs                 = [
                        "${data.aws_availability_zones.available.names[0]}",
                        "${data.aws_availability_zones.available.names[1]}",
                        "${data.aws_availability_zones.available.names[2]}"
  ]

  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  # elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  # redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
  # intra_subnets       = ["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]

  # create_database_subnet_group     = false
  # enable_dns_hostnames             = true
  # enable_dns_support               = true
  # enable_vpn_gateway               = true

  enable_nat_gateway                 = true
  single_nat_gateway                 = true

  # enable_dhcp_options              = true
  # dhcp_options_domain_name         = "service.consul"
  # dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC endpoint for S3
  # enable_s3_endpoint = true

  # VPC endpoint for DynamoDB
  # enable_dynamodb_endpoint = true

  # VPC endpoint for SSM
  # enable_ssm_endpoint              = true
  # ssm_endpoint_private_dns_enabled = true
  # ssm_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]
  # ssm_endpoint_subnet_ids = ["..."]

  # VPC endpoint for SSMMESSAGES
  # enable_ssmmessages_endpoint              = true
  # ssmmessages_endpoint_private_dns_enabled = true
  # ssmmessages_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for EC2
  # enable_ec2_endpoint              = true
  # ec2_endpoint_private_dns_enabled = true
  # ec2_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for EC2MESSAGES
  # enable_ec2messages_endpoint              = true
  # ec2messages_endpoint_private_dns_enabled = true
  # ec2messages_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for ECR API
  # enable_ecr_api_endpoint              = true
  # ecr_api_endpoint_private_dns_enabled = true
  # ecr_api_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for ECR DKR
  # enable_ecr_dkr_endpoint              = true
  # ecr_dkr_endpoint_private_dns_enabled = true
  # ecr_dkr_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC endpoint for KMS
  # enable_kms_endpoint              = true
  # kms_endpoint_private_dns_enabled = true
  # kms_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # kms_endpoint_subnet_ids = ["..."]
}

resource "aws_security_group" "postgres" {
  name_prefix = "postgres"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"
    ]
  }
}

resource "aws_security_group" "mysql" {
  name_prefix = "postgres"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      /*
      "172.16.0.0/12",
      "192.168.0.0/16",
      */
    ]
  }
}

/* TODO enable worker_groups_launch_template?
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  description = "SG to be applied to all *nix machines"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}
*/

/* TODO enable worker_groups_launch_template?
resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "worker_group_mgmt_two"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}
*/
