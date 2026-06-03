# tf-aws-iam-role

Enterprise Terraform module for creating AWS IAM roles with enforced permissions boundaries, controlled trust policies, managed policy attachments, optional inline policies, and optional EC2 instance profiles.

This module is intended to be the standard role primitive for platform modules such as EKS clusters, EKS managed node groups, EC2 workloads, AWX automation roles, and other infrastructure services that need consistent IAM guardrails.

## What This Module Creates

- IAM role with generated or supplied assume-role policy.
- Required permissions boundary.
- Optional managed policy attachments.
- Optional customer-managed IAM policies created and attached by this module.
- Optional inline policies for tightly scoped permissions.
- Optional EC2 instance profile.
- Enterprise tags on taggable resources.

## Design Standards

- Permissions boundary is required for every role.
- Trust policy is explicit and generated from service or AWS principals unless a full policy document is supplied.
- AdministratorAccess is not used in examples and is blocked by platform policy.
- Inline policies should avoid wildcard administrator patterns and must pass central Rego checks.
- Instance profiles are opt-in because EKS cluster and node roles do not require this module to create one.

## Basic Usage

```hcl
module "eks_cluster_role" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/security/tf-aws-iam-role.git?ref=v1.0.0"

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
```

## Inputs

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| `name` | IAM role name. | `string` | yes |
| `permissions_boundary` | IAM permissions boundary ARN. | `string` | yes |
| `trusted_service_principals` | AWS service principals for generated trust policy. | `list(string)` | no |
| `trusted_aws_principals` | AWS principal ARNs for generated trust policy. | `list(string)` | no |
| `assume_role_policy_json` | Complete trust policy JSON. | `string` | no |
| `managed_policy_arns` | Managed policy ARNs to attach. | `set(string)` | no |
| `customer_managed_policies` | Customer-managed IAM policies to create and attach. | `map(object)` | no |
| `inline_policies` | Inline policy JSON documents keyed by policy name. | `map(string)` | no |
| `create_instance_profile` | Create an EC2 instance profile. | `bool` | no |
| `tags` | Enterprise tags. | `map(string)` | yes |

## Outputs

| Name | Description |
| --- | --- |
| `role_name` | IAM role name. |
| `role_arn` | IAM role ARN. |
| `role_unique_id` | IAM role unique ID. |
| `instance_profile_name` | Instance profile name when created. |
| `instance_profile_arn` | Instance profile ARN when created. |
| `managed_policy_arns` | Managed policy ARNs attached to the role. |
| `customer_managed_policy_arns` | Customer-managed policy ARNs created and attached by the module. |

## Validation

Run locally before opening a merge request:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

CI should also run the central shared Terraform pipeline with fmt, validate, Checkov, and Conftest/Rego policy checks.

## Documentation

- [Architecture](docs/architecture.md)
- [Security](docs/security.md)
- [Usage](docs/usage.md)
