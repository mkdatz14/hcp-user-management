# hcp-user-management

Terraform configuration to manage HCP Terraform teams, user memberships, and project access.

## What This Repo Manages

- Creates teams in an HCP Terraform organization.
- Sets organization-level team permissions.
- Creates organization memberships for users by email.
- Adds organization members to teams.
- Grants team-level access to a project.

## Files

- `main.tf`: provider and shared configuration.
- `team-management.tf`: teams, org memberships, and team memberships.
- `project-access.tf`: project and team project access.

## Prerequisites

- Terraform 1.5+
- HCP Terraform user or team token with permissions to manage teams and memberships.

Export your token before running:

```bash
export TFE_TOKEN="<your-hcp-terraform-token>"
```

Optionally set hostname if using Terraform Enterprise:

```bash
export TFE_HOSTNAME="tfe.example.com"
```

## Usage

Initialize and validate:

```bash
terraform init
terraform validate
```

Review changes:

```bash
terraform plan
```

Apply when ready:

```bash
terraform apply
```

## Customization

- Set the organization with `var.organization`.
- Set the target project name with `var.project_name`.
- Edit `local.terraform_managed_teams` in `team-management.tf` to define:
	- `access_level`: `admin`, `maintain`, `write`, `read`, or `custom`
	- `organization_access`: org-level team permissions
	- `members`: list of user emails

If a team uses `access_level = "custom"`, you can also include:

- `project_access`: `settings`, `teams`, `variable_sets`
- `workspace_access`: `runs`, `sentinel_mocks`, `state_versions`, `variables`, `create`, `locking`, `delete`, `move`, `run_tasks`