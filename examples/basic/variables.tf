variable "permissions_boundary_policy_name" {
  description = "Permissions boundary policy name required by platform IAM policy."
  type        = string
  default     = "tf_policy"
}
