resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-${var.lambda_role_name}"
  assume_role_policy = jsonencode({
    version   = local.policy.lambda.trust_policy.Version
    statement = local.policy.lambda.trust_policy.Statement
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