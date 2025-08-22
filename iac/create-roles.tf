resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-${var.lambda_role_name}"
  assume_role_policy = jsonencode({
    Version = local.policy.lambda.trust_policy.Version
    Statement = local.policy.lambda.trust_policy.Statement
  })
}


resource "aws_iam_role_policy" "lambda_role_policy" {
  role     = aws_iam_role.lambda_role.id
  for_each = { for idx, val in local.policy.lambda.role_permissions : idx => val }
  name     = "${var.prefix}-${var.lambda_role_name}-${each.value.name}"
  policy = jsonencode({
    Version   = each.value.Version
    Statement = each.value.Statement
  })

}

output value1 {
    value = local.policy.lambda.trust_policy.Version
}

output value2 {
    value = local.policy.lambda.trust_policy.Statement
}