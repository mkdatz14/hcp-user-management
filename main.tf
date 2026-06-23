locals {
  organization = "my-organization"
}

provider "tfe" {}

data "tfe_organization" "org" {
  name = local.organization
}
