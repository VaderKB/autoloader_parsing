resource "aws_lambda_function" "lambda_execution" {
  function_name = "${var.prefix}-${var.lambda_name}"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.ecr_image.image_uri
  image_config {
    entry_point = ["/lambda-entrypoint.sh"]
    command     = ["generate_data.lambda_handler"]
  }
}