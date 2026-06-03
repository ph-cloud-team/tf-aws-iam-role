data "aws_partition" "current" {}

locals {
  ci_plan_account_id       = format("%012d", 0)
  permissions_boundary_arn = "arn:${data.aws_partition.current.partition}:iam::${local.ci_plan_account_id}:policy/${var.permissions_boundary_policy_name}"
}

module "tf_aws_iam_role" {
  source = "../../"

  name                 = "dev-eks-cluster-role"
  description          = "IAM role for the dev EKS control plane."
  permissions_boundary = local.permissions_boundary_arn

  trusted_service_principals = ["eks.amazonaws.com"]

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  tags = {
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    DataClassification = "internal"
    Application        = "midh-eks"
  }
}
