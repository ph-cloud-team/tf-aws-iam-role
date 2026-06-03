data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  ci_plan_account_id       = format("%012d", 0)
  permissions_boundary_arn = "arn:${data.aws_partition.current.partition}:iam::${local.ci_plan_account_id}:policy/${var.permissions_boundary_policy_name}"
  ssm_parameter_path_arn   = "arn:${data.aws_partition.current.partition}:ssm:${data.aws_region.current.name}:${local.ci_plan_account_id}:parameter/midh/dev/*"
}

data "aws_iam_policy_document" "ssm_read_parameters" {
  statement {
    sid = "ReadApprovedParameterPath"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]

    resources = [
      local.ssm_parameter_path_arn
    ]
  }
}

module "tf_aws_iam_role" {
  source = "../../"

  name                 = "dev-eks-node-role"
  description          = "IAM role for managed EKS worker nodes."
  permissions_boundary = local.permissions_boundary_arn

  trusted_service_principals = ["ec2.amazonaws.com"]

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  customer_managed_policies = {
    ssm-read-approved-parameters = {
      description = "Read approved SSM parameter path for EKS nodes."
      policy      = data.aws_iam_policy_document.ssm_read_parameters.json
    }
  }

  create_instance_profile = false

  tags = {
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    DataClassification = "internal"
    Application        = "midh-eks"
  }
}
