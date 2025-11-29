provider "aws" {
  region = "eu-west-1"
}

resource "random_pet" "this" {
  length = 2
}

module "dynamodb_table" {
  source = "../../"

  # Example only
  deletion_protection_enabled = false

  name        = "my-table-${random_pet.this.id}"
  hash_key    = "id"
  range_key   = "title"
  table_class = "STANDARD"

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

  global_secondary_indexes = {
    TitleIndex = {
      hash_key           = "title"
      range_key          = "age"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]

      on_demand_throughput = {
        max_write_request_units = 1
        max_read_request_units  = 1
      }
    }
  }

  on_demand_throughput = {
    max_read_request_units  = 1
    max_write_request_units = 1
  }

  resource_policy_statements = {
    AllowDummyRoleAccess = {
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::222222222222:role/DummyRole"]
      }]
      actions = ["dynamodb:GetItem"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "disabled_dynamodb_table" {
  source = "../../"

  create = false
}
