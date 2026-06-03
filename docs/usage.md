# Usage

## EKS Cluster Role

```hcl
module "eks_cluster_role" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/security/tf-aws-iam-role.git?ref=v1.0.0"

  name                 = "dev-eks-cluster-role"
  permissions_boundary = var.permissions_boundary

  trusted_service_principals = ["eks.amazonaws.com"]

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  tags = local.tags
}
```

## EKS Managed Node Role

```hcl
module "eks_node_role" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/security/tf-aws-iam-role.git?ref=v1.0.0"

  name                 = "dev-eks-node-role"
  permissions_boundary = var.permissions_boundary

  trusted_service_principals = ["ec2.amazonaws.com"]

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = local.tags
}
```

## EC2 Instance Profile

```hcl
module "ec2_role" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/security/tf-aws-iam-role.git?ref=v1.0.0"

  name                    = "dev-management-ec2-role"
  permissions_boundary    = var.permissions_boundary
  trusted_service_principals = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = local.tags
}
```

## Live Repository Pattern

Live stacks should create IAM roles before modules that consume them, then pass explicit outputs:

```hcl
module "eks_cluster" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/containers/tf-aws-eks-cluster.git?ref=v1.0.0"

  cluster_role_arn = module.eks_cluster_role.role_arn
}
```

This keeps IAM ownership visible in the Terraform graph and prevents higher-level modules from silently creating privileged roles.
