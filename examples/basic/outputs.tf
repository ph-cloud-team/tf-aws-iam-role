output "role_name" {
  description = "IAM role name."
  value       = module.tf_aws_iam_role.role_name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = module.tf_aws_iam_role.role_arn
}
