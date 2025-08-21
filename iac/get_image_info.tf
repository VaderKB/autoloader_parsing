data "aws_ecr_image" "ecr_image" {
  repository_name = local.config.ecr.repository_name
  image_tag       = "latest"
}