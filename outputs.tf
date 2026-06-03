output "module_name" {
  description = "Name of the Terraform module."
  value       = local.module_name
}

output "role_name" {
  description = "IAM role name."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "IAM role ID."
  value       = aws_iam_role.this.id
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.this.arn
}

output "role_unique_id" {
  description = "IAM role unique ID."
  value       = aws_iam_role.this.unique_id
}

output "instance_profile_name" {
  description = "IAM instance profile name when created."
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN when created."
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "managed_policy_arns" {
  description = "Managed policy ARNs attached to the role."
  value       = var.managed_policy_arns
}

output "customer_managed_policy_arns" {
  description = "Customer managed IAM policy ARNs created and attached by this module."
  value       = { for key, policy in aws_iam_policy.customer_managed : key => policy.arn }
}

output "inline_policy_names" {
  description = "Inline policy names attached to the role."
  value       = keys(aws_iam_role_policy.inline)
}
