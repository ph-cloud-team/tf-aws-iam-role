variable "name" {
  description = "IAM role name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.name))
    error_message = "name must be a valid IAM role name with 1-64 characters."
  }
}

variable "path" {
  description = "IAM path for the role."
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description for the IAM role."
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "Permissions boundary ARN required by platform IAM policy."
  type        = string

  validation {
    condition     = can(regex(format("^%s:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/.+", "arn"), var.permissions_boundary))
    error_message = "permissions_boundary must be an IAM policy ARN."
  }
}

variable "trusted_service_principals" {
  description = "AWS service principals allowed to assume this role when assume_role_policy_json is not supplied."
  type        = list(string)
  default     = []
}

variable "trusted_aws_principals" {
  description = "AWS principal ARNs allowed to assume this role when assume_role_policy_json is not supplied."
  type        = list(string)
  default     = []
}

variable "assume_role_policy_json" {
  description = "Prebuilt assume-role policy JSON. When null, the module builds one from trusted principals."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "force_detach_policies" {
  description = "Detach policies from the role during destroy."
  type        = bool
  default     = true
}

variable "managed_policy_arns" {
  description = "Managed policy ARNs to attach to the role. AdministratorAccess is blocked by platform policy."
  type        = set(string)
  default     = []
}

variable "customer_managed_policies" {
  description = "Customer managed policies to create and attach to the role, keyed by logical policy name."
  type = map(object({
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string)
    policy      = string
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "inline_policies" {
  description = "Inline IAM policies keyed by policy name. Policies must be least-privilege and pass platform Rego checks."
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Create an IAM instance profile for EC2 workloads."
  type        = bool
  default     = false
}

variable "instance_profile_name" {
  description = "Optional IAM instance profile name. Defaults to role name when create_instance_profile is true."
  type        = string
  default     = null
}

variable "require_trust_policy" {
  description = "Require either generated trust principals or assume_role_policy_json."
  type        = bool
  default     = true
}

variable "role_tags" {
  description = "Additional tags applied only to the IAM role."
  type        = map(string)
  default     = {}
}

variable "policy_tags" {
  description = "Additional tags applied to customer managed IAM policies created by this module."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags to apply to supported AWS resources. Must include enterprise required tags in live usage."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "Environment"),
      contains(keys(var.tags), "Owner"),
      contains(keys(var.tags), "CostCenter"),
      contains(keys(var.tags), "DataClassification")
    ])
    error_message = "tags must include Environment, Owner, CostCenter, and DataClassification."
  }
}
