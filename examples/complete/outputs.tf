output "role_name" {
  description = "IAM role name."
  value       = module.tf_aws_iam_role.role_name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = module.tf_aws_iam_role.role_arn
}

output "managed_policy_arns" {
  description = "Managed policy ARNs attached to the role."
  value       = module.tf_aws_iam_role.managed_policy_arns
}

output "customer_managed_policy_arns" {
  description = "Customer managed policy ARNs created and attached by the module."
  value       = module.tf_aws_iam_role.customer_managed_policy_arns
}
