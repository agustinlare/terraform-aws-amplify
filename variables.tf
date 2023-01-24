variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "env" {
  type    = string
}

variable "application" {
  type    = string
  description = "The name for an Amplify app."
}

variable "repo" {
  type        = string
  description = "The name of the repo that the Amplify App will be created around."
}

variable "organization" {
  type = string
}

variable "enabled" {
  type = bool
  default = false
}

variable "description" {
  type    = string
}

variable "env_var" {
  type    = map(any)
  description = "The environment variables for the autocreated branch."
}

# variable "enable_basic_auth" {
#   type      = bool
#   description = "Enables basic authorization for the autocreated branch."
#   default = false
# }

variable "enable_auto_build" {
  type = bool
  description = "Enables auto building for the autocreated branch."
  default = false
}

# variable "refresh_branch" {
#   type = bool
#   description = "This should be true only when it's the first time to run"
#   default = false
# }

# variable "gh_user" {
#   type = string
#   sensitive = true
#   default = null
# }

# variable "gh_password" {
#   type = string
#   sensitive = true
#   default = null
# }

variable "custom_rules" {
  default = []
  type = list(object({
    source    = string # Required
    target    = string # Required
    status    = any    # Use null if not passing
    condition = any    # Use null if not passing
  }))
  description = "The custom rules to apply to the Amplify App."
}

variable "framework" {
  type        = string
  description = "(Optional) The framework for the autocreated branch."
}

variable "master_branch_name" {
  type    = string
  description = "The name of the 'master'-like branch that you'd like to use."
}

variable "default_service_role_arn" {
  type    = string
  description = "The AWS Identity and Access Management (IAM) service role for an Amplify app."
  sensitive = true
  default = null
}

variable "build_spec_content" {
  type    = string
  description = "The build specification (build spec) for the autocreated branch."
}

variable "access_token" {
  type = string
  sensitive   = true
  default = null
  description = "The personal access token for a third-party source control system for an Amplify app. The personal access token is used to create a webhook and a read-only deploy key. The token is not stored."
}

variable "tags" {
  type = map(string)
}

variable "domain_name" {
  type = string
}

variable "global_env" {
  type = map
  default = null
}