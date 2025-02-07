
provider "aws" {
  # region doesn't matter in this case, as IAM is global per account
  region = "us-east-1"
}

resource "aws_iam_user" "create_terraform_setup" {
  name = "create-terraform-setup"
}

# Inline isn't always recommended, but this way it gets deleted
# automatically when you delete the user.
resource "aws_iam_user_policy" "create_terraform_setup_inline_policy" {
  name   = "TerraformStateSetupPolicy"
  user   = aws_iam_user.create_terraform_setup.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:Create*",
          "s3:Put*",
          "s3:ListBucket",
          "s3:DeleteBucket",
          "s3:Get*"
        ]
        Resource = "arn:aws:s3:::obi-tfstate-*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload"
        ]
        Resource = "arn:aws:s3:::obi-tfstate-*/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:Describe*",
          "dynamodb:List*",
        ]
        Resource = "arn:aws:dynamodb:*:*:table/terraform-state-lock-table-*"
      }
    ]
  })
}

resource "aws_iam_access_key" "create_terraform_setup_user_key" {
  user = aws_iam_user.create_terraform_setup.name
}

output "access_key_id" {
  value     = aws_iam_access_key.create_terraform_setup_user_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.create_terraform_setup_user_key.secret
  sensitive = true
}
