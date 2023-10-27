provider "aws" {
  region = "eu-west-1"
}

resource "random_pet" "this" {
  length = 2
}

module "import_json_table" {
  source = "../../"

  name                        = "import-json-${random_pet.this.id}"
  hash_key                    = "id"
  range_key                   = "title"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "title"
      type = "S"
    },
  ]

  import_table = {
    input_format           = "DYNAMODB_JSON"
    input_compression_type = "NONE"
    bucket                 = module.s3_bucket.s3_bucket_id
    key_prefix             = "import-json-${random_pet.this.id}"
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "import_csv_table" {
  source = "../../"

  name                        = "import-csv-${random_pet.this.id}"
  hash_key                    = "id"
  range_key                   = "title"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "title"
      type = "S"
    },
  ]

  import_table = {
    input_format           = "CSV"
    input_compression_type = "NONE"
    bucket                 = module.s3_bucket.s3_bucket_id
    key_prefix             = "import-csv-${random_pet.this.id}"
    input_format_options = {
      csv = {
        delimiter = ";"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15"

  bucket = "import-example-${random_pet.this.id}"

  force_destroy = true
}

module "s3_import_object_json" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "~> 3.15"

  bucket = module.s3_bucket.s3_bucket_id
  key    = "import-json-${random_pet.this.id}/sample.json"

  content_base64 = filebase64("./files/sample.json")
}

module "s3_import_object_csv" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "~> 3.15"

  bucket = module.s3_bucket.s3_bucket_id
  key    = "import-csv-${random_pet.this.id}/sample.csv"

  content_base64 = filebase64("./files/sample.csv")
}
