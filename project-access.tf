resource "tfe_project" "demo" {
  name         = var.project_name
  organization = local.organization
}

resource "tfe_team_project_access" "managed_access" {
  for_each = local.terraform_managed_teams

  team_id    = tfe_team.managed_teams[each.key].id
  project_id = tfe_project.demo.id
  access     = each.value.access_level

  dynamic "project_access" {
    for_each = each.value.access_level == "custom" ? [lookup(each.value, "project_access", {})] : []
    content {
      settings      = lookup(project_access.value, "settings", "read")
      teams         = lookup(project_access.value, "teams", "none")
      variable_sets = lookup(project_access.value, "variable_sets", "none")
    }
  }

  dynamic "workspace_access" {
    for_each = each.value.access_level == "custom" ? [lookup(each.value, "workspace_access", {})] : []
    content {
      runs           = lookup(workspace_access.value, "runs", "read")
      sentinel_mocks = lookup(workspace_access.value, "sentinel_mocks", "none")
      state_versions = lookup(workspace_access.value, "state_versions", "none")
      variables      = lookup(workspace_access.value, "variables", "none")
      create         = lookup(workspace_access.value, "create", false)
      locking        = lookup(workspace_access.value, "locking", false)
      delete         = lookup(workspace_access.value, "delete", false)
      move           = lookup(workspace_access.value, "move", false)
      run_tasks      = lookup(workspace_access.value, "run_tasks", false)
    }
  }
}
