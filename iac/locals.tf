locals {

  policy = jsondecode(file("${path.module}/policy.json"))
  config = jsondecode(file("${path.module}/../config.json"))

}