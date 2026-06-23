terraform {
  required_version = ">= 1.15.6"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.78.0"
    }
  }
}

locals {
  organization = "my-organization"
}

provider "tfe" {}

data "tfe_organization" "org" {
  name = local.organization
}
