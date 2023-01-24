# locals {
#   basic_auth_creds = var.enabled ? try(base64encode("${var.gh_user}:${var.gh_password}"), null) : null
# }

resource "aws_amplify_app" "this" {
  count = var.enabled ? 1 : 0

  name       = var.application
  description = var.description

  repository = "https://github.com/${var.organization}/${var.repo}"
  access_token = var.access_token
  # enable_basic_auth = var.enable_basic_auth
  # basic_auth_credentials = local.basic_auth_creds

  build_spec = var.build_spec_content
  environment_variables = var.env_var
  iam_service_role_arn = var.default_service_role_arn
  enable_branch_auto_build = var.enable_auto_build

  # auto_branch_creation_config {
  #   enable_auto_build = var.enable_auto_build
  # }

  dynamic "custom_rule" {
    for_each = var.custom_rules
    iterator = rule

    content {
      source    = rule.value.source
      target    = rule.value.target
      status    = rule.value.status
      condition = lookup(rule.value, "condition", null)
    }
  }

  lifecycle {
    ignore_changes = [platform, custom_rule]
  }

  tags = var.tags
}

resource "aws_amplify_branch" "master" {
  count = var.enabled ? 1 : 0

  app_id      = aws_amplify_app.this[0].id
  
  framework = var.framework
  branch_name = var.master_branch_name
  stage = "PRODUCTION"

  tags = var.tags

  depends_on = [
    aws_amplify_app.this
  ]
}

resource "aws_amplify_domain_association" "this" {
  count = var.enabled ? 1 : 0
  
  app_id      = aws_amplify_app.this[0].id
  domain_name = var.domain_name

  sub_domain {
    branch_name = aws_amplify_branch.master[0].branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.master[0].branch_name
    prefix      = "www"
  }

  depends_on = [
    aws_amplify_app.this,
    aws_amplify_branch.master
  ]
}