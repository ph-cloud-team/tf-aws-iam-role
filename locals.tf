############################################
# Local values for tf-aws-iam-role
############################################

locals {
  module_name = "tf-aws-iam-role"

  common_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = local.module_name
    },
    var.tags
  )

  assume_role_policy_json = var.assume_role_policy_json != null ? var.assume_role_policy_json : data.aws_iam_policy_document.assume_role[0].json
}
