/* Provider */

provider "aws" {
  region = "${var.taito_provider_region}"
  profile = "${coalesce(var.taito_provider_user_profile, var.taito_organization)}"
  shared_credentials_file = "/home/taito/.aws/credentials"
}

/* Common data */

locals {
  tags = {
    project = "${var.taito_provider_project_id}"
    workspace = "${terraform.workspace}"
  }
}

data "aws_availability_zones" "available" {}

/* Resource group for all resources */

/* TODO: how to use terraform variable inside a JSON block?
resource "aws_resourcegroups_group" "taito_zone" {
  name = "${var.taito_provider_project_id}"

  resource_query {
    query = <<JSON
{
  "TagFilters": [
    {
      "Key": "project",
      "Values": ["${var.taito_provider_project_id}"]
    }
  ]
}
JSON
  }

  lifecycle {
    prevent_destroy = true
  }
}
*/
