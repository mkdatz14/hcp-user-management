locals {
  terraform_managed_teams = {
    developers = {
      access_level = "write"
      organization_access = {
        manage_workspaces = true
      }
      members = [
        "adam@example.com",
        "bob@example.com"
      ]
    }
    security = {
      access_level = "admin"
      organization_access = {
        manage_policies         = true
        manage_policy_overrides = true
      }
      members = [
        "carol@example.com",
        "dave@example.com"
      ]
    }
    readers = {
      access_level        = "read"
      organization_access = {}
      members = [
        "eve@example.com",
        "frank@example.com"
      ]
    }
  }

  all_member_emails = toset(flatten([
    for _, team in local.terraform_managed_teams : team.members
  ]))

  team_memberships = merge([
    for team_name, team in local.terraform_managed_teams : {
      for member_email in team.members :
      "${team_name}:${lower(member_email)}" => {
        team_name = team_name
        email     = lower(member_email)
      }
    }
  ]...)
}

resource "tfe_team" "managed_teams" {
  for_each = local.terraform_managed_teams

  name         = each.key
  organization = local.organization

  organization_access {
    manage_workspaces       = lookup(each.value.organization_access, "manage_workspaces", false)
    manage_policies         = lookup(each.value.organization_access, "manage_policies", false)
    manage_policy_overrides = lookup(each.value.organization_access, "manage_policy_overrides", false)
  }
}

resource "tfe_organization_membership" "managed_users" {
  for_each = local.all_member_emails

  organization = local.organization
  email        = each.value
}

resource "tfe_team_organization_member" "managed_team_memberships" {
  for_each = local.team_memberships

  team_id                    = tfe_team.managed_teams[each.value.team_name].id
  organization_membership_id = tfe_organization_membership.managed_users[each.value.email].id
}
