provider "aws" {
  region = "eu-west-1"
}

resource "random_pet" "this" {
  length = 2
}

module "dynamodb_table" {
  source = "../../"

  name      = "my-table-${random_pet.this.id}"
  hash_key  = "id"
  range_key = "title"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

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

  global_secondary_indexes = [
    {
      name               = "TitleIndex"
      hash_key           = "title"
      range_key          = "age"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    }
  ]

  replica_regions = [
    "eu-west-2"
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
