# Security

IAM is a high-risk control plane surface. This module is intentionally conservative and aligns with the platform Rego policy set.

## Required Controls

- Every role requires `permissions_boundary`.
- Trust relationships are explicit.
- AdministratorAccess is not used.
- Inline policies are optional and should be narrowly scoped.
- Customer-managed policies are preferred over inline policies for permissions that need independent review, reuse, versioning, or policy-specific tags.
- Required enterprise tags are enforced at module input.

## Policy Guardrails

The central policy repository evaluates IAM plans for:

- missing permissions boundaries on `aws_iam_role`;
- AdministratorAccess attachments;
- dangerous IAM administration actions on wildcard resources;
- wildcard allow action and wildcard allow resource combinations.

Examples in this repository avoid those denied patterns.

## Trust Policy Guidance

Use service principals only when the AWS service must assume the role. Use AWS principal ARNs only for known automation identities. Do not use broad account root trust unless the target account and conditions are intentionally reviewed.

For Kubernetes service accounts, use the IRSA module rather than passing raw OIDC trust JSON here. That keeps cluster identity concerns isolated and easier to audit.

## Operational Notes

- Use customer-managed permission boundaries controlled by the platform/security team.
- Keep role names environment-qualified, for example `dev-eks-node-role`.
- Prefer managed policies for AWS service integration when they are the accepted AWS baseline.
- Use module-created customer-managed policies for workload-specific permissions that need audit visibility.
- Use inline policies only for small permissions that should be tied directly to the role lifecycle.
