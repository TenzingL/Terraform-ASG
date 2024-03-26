data "aws_caller_identity" "account" {}
resource "aws_iam_role" "ec2_role" {
  name = "EC2-Role"
  assume_role_policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
}

resource "aws_iam_policy" "parameter_store_access" {
  name = "ParameterStoreAccessPolicy"
  path = "/development/"
  description = "Creates IAM policy for development that allow access to the parameter store"

  policy = jsonencode({ //Might have to change this to EOF
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParameterByPath"
        ]
        Resource = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.account.account_id}:/Databases/Test/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "parameter_store_role_attachment" {
    role = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.parameter_store_access.arn
}