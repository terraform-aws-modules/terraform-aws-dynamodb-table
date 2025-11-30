provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

locals {
  name = "ex-${basename(path.cwd)}"

  secondary_region = "us-west-2"

  tags = {
    Test       = local.name
    GithubRepo = "terraform-aws-dynamodb-table"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# DynamoDB Global Table
################################################################################

module "dynamodb_table" {
  source = "../../"

  # Example only
  deletion_protection_enabled = false

  name      = local.name
  hash_key  = "id"
  range_key = "title"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption = {
    enabled     = true
    kms_key_arn = module.kms_primary.key_arn
  }

  autoscaling = {
    enabled = true

    defaults = {
      scale_in_cooldown  = 10
      scale_out_cooldown = 10
      target_value       = 80
    }

    read = {
      max_capacity = 20
    }
    write = {
      max_capacity = 20
    }
  }

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "title"
      type = "S"
    },
    {
      name = "age"
      type = "N"
    }
  ]

  ignore_changes_global_secondary_index = true
  global_secondary_indexes = {
    TitleIndex = {
      hash_key           = "title"
      range_key          = "age"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
      write_capacity     = 10
      read_capacity      = 10

      autoscaling = {
        enabled            = true
        read_max_capacity  = 20
        read_min_capacity  = 5
        write_max_capacity = 20
        write_min_capacity = 5
      }
    }
  }

  # A matching policy will be created per region replica
  resource_policy_statements = {
    AllowReplicaDummyRoleAccess = {
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }]
      actions = [
        "dynamodb:GetItem",
        "dynamodb:BatchGetItem",
      ]
    }
  }
  # A matching policy will be created per region replica
  stream_resource_policy_statements = {
    AllowReplicaDummyRoleAccessStream = {
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }]
      actions = [
        "dynamodb:*",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
      ]
    }
  }

  replicas = [
    {
      region_name                 = local.secondary_region
      kms_key_arn                 = module.kms_secondary.key_arn
      propagate_tags              = true
      point_in_time_recovery      = true
      deletion_protection_enabled = false
    }
  ]

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 4.0"

  description = "DynamoDB key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Primary
  multi_region = true

  # Aliases
  aliases = ["dynamodb/${local.name}"]

  tags = local.tags
}

module "kms_secondary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 4.0"

  region = local.secondary_region

  description = "DynamoDB key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Replica
  multi_region    = true
  create_replica  = true
  primary_key_arn = module.kms_primary.key_arn

  # Aliases
  aliases = ["dynamodb/${local.name}"]

  tags = local.tags
}
