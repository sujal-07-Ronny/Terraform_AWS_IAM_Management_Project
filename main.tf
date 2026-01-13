terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  # Load users from YAML
  user_data = yamldecode(file("./user.yml")).users

  # Create user-role pairs (flattened)
  user_role_pair = flatten([
    for user in local.user_data : [
      for role in user.roles : {
        username = user.username
        role     = role
      }
    ]
  ])
}

# Debug outputs (optional but useful)
output "usernames" {
  value = local.user_data[*].username
}

output "user_role_pair" {
  value = local.user_role_pair
}

# Create IAM Users
resource "aws_iam_user" "users" {
  for_each = toset(local.user_data[*].username)
  name     = each.value
}

# Login profile for users
resource "aws_iam_user_login_profile" "profile" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

# Attach IAM policies to users based on roles
resource "aws_iam_user_policy_attachment" "policy_attach" {
  for_each = {
    for ur in local.user_role_pair :
    "${ur.username}-${ur.role}" => ur
  }

  user       = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}

