resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  policy      = file(var.policy_path)
  tags        = var.tags
}
