# AWS Amplify Module

A Terraform module for building simple Amplify apps. This creates the master and develop branches, sets up the domain association, and creates webhooks for both branches.

# Usage

```=terraform
module "app" {
  source = "./amplify"

  # General input
  application = "Some app"
  description = "Some description"
  domain_name = "app.domain"
  env         = "develop"

  access_token = var.GH_ACCESS_TOKEN 
  organization       = "organization"
  repo               = "app-public-website"
  master_branch_name = "develop"

  enable_auto_build = true
  env_var = {
    foo = var
  }

  default_service_role_arn = var.DEFAULT_IAM_ARM
  build_spec_content       = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*

  EOT
  framework                = "Next.js - SSR"

  custom_rules = [{
    source    = "https://public.domain"
    target    = "https://www.public.domain"
    status    = "302"
    condition = null
    }, {
    source    = "/<*>"
    target    = "/index.html"
    status    = "404"
    condition = null
  }]

  tags = {
    Terraform = True
    Owner = "Devops"
  }
}
```

## Credits
1. [@agustinlare](https://github.com/agustinlare)
1. [masterpointio/terraform-aws-amplify-app](https://github.com/masterpointio/terraform-aws-amplify-app)

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| application | App name | `string` | null |
| repo | Only the repository name, e.g gh.com/agustinlare/**lapatriota** | `string` | null |
| access_token | Personal Access token for 3rd party source control system for an Amplify App, used to create webhook and read-only deploy key. Token is not stored. | `string` | null |
| description | The description to associate with the Amplify App. | `string` | null |
| enabled | Set to false (default) to prevent the module from creating any resources | `bool` | false |
| env_var | The environment variables map for an Amplify app. | `map` | null |
| domain_name | The Custom Domain Name to associate with this Amplify App. | `string` | null |
| organization | The GitHub organization or user where the repo lives.	 | `string` | null |
| master_branch_name | The name of the 'master'-like branch that you'd like to use.	 | `string` | null |
| enable_auto_build | Enables auto building for the autocreated branch. | `bool` | true |
| default_service_role_arn | The AWS Identity and Access Management (IAM) service role for an Amplify app. | `string` | null |
| build_spec_content | The build specification (build spec) for an Amplify app. | `string` | null |
| framework | The framework for the autocreated branch. | `string` | null |
| custom_rules | The custom rules to apply to the Amplify App. | list(object({<br>    source    = string # Required<br>    target    = string # Required<br>    status    = any    # Use null if not passing<br>    condition = any    # Use null if not passing<br>  })) | null |
| tags | 	Additional tags (e.g. map('BusinessUnit','XYZ') | `map(string`) | null |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the main Amplify resource. |
| default_domain | The amplify domain (non-custom). |
| domain_association_arn | The ARN of the domain association resource. |
| custom_domains | List of custom domains that are associated with this resource (if any). |