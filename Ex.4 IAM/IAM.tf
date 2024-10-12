# IAM Groups
resource "aws_iam_group" "developers_group" {
  name = "Developers"
}

# Declare IAM users for Developers
resource "aws_iam_user" "dev_precious" {
  name = "dev_precious"
}

resource "aws_iam_user" "dev_miles" {
  name = "dev_miles"
}

# Attach dev_precious to the Developers group
resource "aws_iam_user_group_membership" "dev_precious_membership" {
  user   = aws_iam_user.dev_precious.name
  groups = [aws_iam_group.developers_group.name]
}

# Attach dev_miles to the Developers group
resource "aws_iam_user_group_membership" "dev_miles_membership" {
  user   = aws_iam_user.dev_miles.name
  groups = [aws_iam_group.developers_group.name]
}



# Attach Policies to Developers Group
resource "aws_iam_group_policy_attachment" "developers_ec2_full_access" {
  group      = aws_iam_group.developers_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "developers_s3_read_only" {
  group      = aws_iam_group.developers_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# Define the Operations group
resource "aws_iam_group" "operations" {
  name = "Operations"
}


# Declare IAM users for Operations
resource "aws_iam_user" "ops_pride" {
  name = "ops_pride"
}

resource "aws_iam_user" "ops_cecce" {
  name = "ops_cecce"
}

# Operations Group Membership
resource "aws_iam_user_group_membership" "operations_group_membership" {
  user   = aws_iam_user.ops_pride.name
  groups = [aws_iam_group.operations.name]
}

resource "aws_iam_user_group_membership" "operations_group_membership_2" {
  user   = aws_iam_user.ops_cecce.name
  groups = [aws_iam_group.operations.name]
}

# Attach Policies to Operations Group
resource "aws_iam_group_policy_attachment" "operations_s3_full_access" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "operations_cloudwatch_full_access" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}



# Define the Support group
resource "aws_iam_group" "support" {
  name = "Support"
}

# Declare IAM users for Support
resource "aws_iam_user" "support_chanceline" {
  name = "support_chanceline"
}

resource "aws_iam_user" "support_juel" {
  name = "support_juel"
}


# # Support Group Membership
resource "aws_iam_user_group_membership" "support_group_membership" {
  user   = aws_iam_user.support_chanceline.name
  groups = [aws_iam_group.support.name]
}

resource "aws_iam_user_group_membership" "support_group_membership_2" {
  user   = aws_iam_user.support_juel.name
  groups = [aws_iam_group.support.name]
} 

# Attach Policies to Support Group
resource "aws_iam_group_policy_attachment" "support_ec2_read_only" {
  group      = aws_iam_group.support.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "support_s3_read_only" {
  group      = aws_iam_group.support.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "support_cloudwatch_read_only" {
  group      = aws_iam_group.support.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}





# Policy that allows users in the Support group to assume SupportRole
resource "aws_iam_policy" "allow_assume_support_role" {
  name        = "AllowAssumeSupportRole"
  description = "Allow users in the Support group to assume the SupportRole"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = aws_iam_role.support_role.arn
      }
    ]
  })
}

# Attach this policy to the Support group
resource "aws_iam_group_policy_attachment" "support_group_assume_support" {
  group      = aws_iam_group.support.name
  policy_arn = aws_iam_policy.allow_assume_support_role.arn
}




# Policy that allows users in the Operations group to assume AdminRole
resource "aws_iam_policy" "allow_assume_admin_role" {
  name        = "AllowAssumeAdminRole"
  description = "Allow users in the Operations group to assume the AdminRole"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = aws_iam_role.admin_role.arn
      }
    ]
  })
}

# Attach this policy to the Operations group
resource "aws_iam_group_policy_attachment" "operations_group_assume_admin" {
  group      = aws_iam_group.operations.name
  policy_arn = aws_iam_policy.allow_assume_admin_role.arn
}


# AdminRole: Full administrative access to all resources
resource "aws_iam_role" "admin_role" {
  name = "AdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"  # Trust the root account
        }
        Action = "sts:AssumeRole"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach AdministratorAccess policy to AdminRole
resource "aws_iam_role_policy_attachment" "admin_role_policy_attachment" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# SupportRole: Read-only access to EC2 and S3
resource "aws_iam_role" "support_role" {
  name = "SupportRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"  # Trust the root account
        }
        Action = "sts:AssumeRole"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Create a custom read-only policy for EC2 and S3
resource "aws_iam_policy" "support_read_only_policy" {
  name        = "SupportReadOnlyPolicy"
  description = "Grants read-only access to EC2 and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "s3:Get*",
          "s3:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the read-only policy to the SupportRole
resource "aws_iam_role_policy_attachment" "support_role_policy_attachment" {
  role       = aws_iam_role.support_role.name
  policy_arn = aws_iam_policy.support_read_only_policy.arn
}



# Attach the policy to allow Operations group users to assume the AdminRole
resource "aws_iam_group_policy_attachment" "operations_assume_admin_role_attachment" {
  group      = aws_iam_group.operations.name
  policy_arn = aws_iam_policy.operations_assume_admin_role.arn
}

# Attach the policy to allow Support group users to assume the SupportRole
resource "aws_iam_group_policy_attachment" "support_assume_support_role_attachment" {
  group      = aws_iam_group.support.name
  policy_arn = aws_iam_policy.support_assume_support_role.arn
}




# Allow Operations group users to assume AdminRole
resource "aws_iam_policy" "operations_assume_admin_role" {
  name        = "OperationsAssumeAdminRolePolicy"
  description = "Allow Operations group users to assume AdminRole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.admin_role.arn
      }
    ]
  })
}



# Allow Support group users to assume SupportRole
resource "aws_iam_policy" "support_assume_support_role" {
  name        = "SupportAssumeSupportRolePolicy"
  description = "Allow Support group users to assume SupportRole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.support_role.arn
      }
    ]
  })
}

