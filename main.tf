resource "aws_iam_role" "this" {
  name                  = var.name
  path                  = var.path
  description           = var.description
  assume_role_policy    = local.assume_role_policy_json
  permissions_boundary  = var.permissions_boundary
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = merge(local.common_tags, var.role_tags, { Name = var.name })

  lifecycle {
    precondition {
      condition = (
        !var.require_trust_policy ||
        var.assume_role_policy_json != null ||
        length(var.trusted_service_principals) > 0 ||
        length(var.trusted_aws_principals) > 0
      )
      error_message = "Provide assume_role_policy_json or at least one trusted principal."
    }
  }
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_policy" "customer_managed" {
  for_each = var.customer_managed_policies

  name        = coalesce(each.value.name, "${var.name}-${each.key}")
  path        = each.value.path
  description = each.value.description
  policy      = each.value.policy

  tags = merge(
    local.common_tags,
    var.policy_tags,
    each.value.tags,
    {
      Name = coalesce(each.value.name, "${var.name}-${each.key}")
    }
  )
}

resource "aws_iam_role_policy_attachment" "customer_managed" {
  for_each = aws_iam_policy.customer_managed

  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = coalesce(var.instance_profile_name, var.name)
  path = var.path
  role = aws_iam_role.this.name

  tags = merge(
    local.common_tags,
    {
      Name = coalesce(var.instance_profile_name, var.name)
    }
  )
}
