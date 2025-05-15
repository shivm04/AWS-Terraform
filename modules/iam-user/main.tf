resource "aws_iam_user" "this" {
  name = var.name
  tags = var.tags
}

resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.this.name
  groups = var.groups
}
