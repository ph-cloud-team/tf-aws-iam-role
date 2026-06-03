# Architecture

This module provides a reusable IAM role primitive for the platform Terraform module catalog.

## Resource Model

- `aws_iam_role.this` creates the role, trust policy, permissions boundary, and role tags.
- `aws_iam_role_policy_attachment.managed` attaches approved AWS or customer managed policies.
- `aws_iam_policy.customer_managed` creates workload-specific customer-managed policies when a shared policy is not appropriate.
- `aws_iam_role_policy_attachment.customer_managed` attaches module-created customer-managed policies.
- `aws_iam_role_policy.inline` attaches tightly scoped inline policy documents when a managed policy is not appropriate.
- `aws_iam_instance_profile.this` is optional and only created for EC2-based workloads.

## Trust Policy Model

Consumers can use either:

- generated trust policy inputs, using `trusted_service_principals` and `trusted_aws_principals`; or
- `assume_role_policy_json` when a workload needs conditions, federated identity, OIDC, or a more advanced trust policy.

The generated model covers common service roles such as:

- EKS control plane roles with `eks.amazonaws.com`;
- EC2 and EKS node roles with `ec2.amazonaws.com`;
- automation roles trusted by known AWS principal ARNs.

IRSA/OIDC roles should use the dedicated IRSA module because those trust policies require web identity conditions.

## Dependency Position

This module is a dependency for higher-level infrastructure modules:

- EKS cluster module consumes an EKS control plane role ARN.
- EKS managed node group module consumes a node role ARN.
- EC2 module can consume an instance profile from this module.
- AWX automation can consume constrained AWS roles for controller or execution jobs.

## Release Contract

The module exposes stable outputs for role name, role ARN, unique ID, and instance profile identity. Higher-level modules should consume outputs rather than reconstruct ARNs.

Customer-managed policies are exposed as a map of ARNs keyed by the logical policy names passed to `customer_managed_policies`.
