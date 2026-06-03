############################################
# Data sources for tf-aws-iam-role
############################################

data "aws_iam_policy_document" "assume_role" {
  count = var.assume_role_policy_json == null ? 1 : 0

  dynamic "statement" {
    for_each = length(var.trusted_service_principals) == 0 ? [] : [1]

    content {
      sid     = "AllowServiceAssumeRole"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_aws_principals) == 0 ? [] : [1]

    content {
      sid     = "AllowAwsPrincipalAssumeRole"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_aws_principals
      }
    }
  }
}
