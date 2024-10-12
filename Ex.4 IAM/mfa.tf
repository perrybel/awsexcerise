# MFA device requirement for users
resource "aws_iam_user_policy" "enforce_mfa_dev_user1" {
  name = "enforce_mfa_dev_precious"
  user = aws_iam_user.dev_precious.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Apply MFA enforcement to all users (repeat this block for each user)
resource "aws_iam_user_policy" "enforce_mfa_dev_user2" {
  name = "enforce_mfa_dev_miles"
  user = aws_iam_user.dev_miles.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Apply the same policy for operations and support users
resource "aws_iam_user_policy" "enforce_mfa_ops_user1" {
  name = "enforce_mfa_ops_pride"
  user = aws_iam_user.ops_pride.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Apply the same policy for operations and support users
resource "aws_iam_user_policy" "enforce_mfa_ops_user2" {
  name = "enforce_mfa_ops_cecce"
  user = aws_iam_user.ops_cecce.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy" "enforce_mfa_support_user1" {
  name = "enforce_mfa_support_chanceline"
  user = aws_iam_user.support_chanceline.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}



resource "aws_iam_user_policy" "enforce_mfa_support_user2" {
  name = "enforce_mfa_support_juel"
  user = aws_iam_user.support_juel.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "*",
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}