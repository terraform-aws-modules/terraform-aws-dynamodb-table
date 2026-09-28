provider "aws" {
  region = "eu-west-1"
}

resource "random_pet" "this" {
  length = 2
}

module "dynamodb_table" {
  source = "../../"

  name     = "standalone-gsi-${random_pet.this.id}"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "title"
      type = "S"
    }
  ]

  # Each index is managed as a standalone aws_dynamodb_global_secondary_index
  # resource, so adding, changing, or removing one index does not recreate the
  # others (the drift that inline global_secondary_index blocks suffer from).
  standalone_global_secondary_indexes = [
    {
      index_name = "TitleIndex"

      key_schema = [
        {
          attribute_name = "title"
          attribute_type = "S"
          key_type       = "HASH"
        }
      ]

      projection = {
        projection_type = "ALL"
      }

      on_demand_throughput = {
        max_read_request_units  = 10
        max_write_request_units = 10
      }
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
