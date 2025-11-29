provider "aws" {
  region = "eu-west-1"
}

module "import_json_table" {
  source = "../../"

  # Example only
  deletion_protection_enabled = false

  name        = "import-json"
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
  ]

  import_table = {
    input_compression_type = "NONE"
    input_format           = "DYNAMODB_JSON"
    s3_bucket_source = {
      bucket     = module.s3_bucket.s3_bucket_id
      key_prefix = "import-json"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "import_csv_table" {
  source = "../../"

  name                        = "import-csv"
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
    input_compression_type = "NONE"
    input_format           = "CSV"
    input_format_options = {
      csv = {
        delimiter = ";"
      }
    }
    s3_bucket_source = {
      bucket     = module.s3_bucket.s3_bucket_id
      key_prefix = "import-csv"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "import-example-"

  # Example only
  force_destroy = true
}

module "s3_import_object_json" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "~> 5.0"

  bucket = module.s3_bucket.s3_bucket_id
  key    = "import-json/sample.json"

  content_base64 = filebase64("./files/sample.json")
}

module "s3_import_object_csv" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "~> 5.0"

  bucket = module.s3_bucket.s3_bucket_id
  key    = "import-csv/sample.csv"

  content_base64 = filebase64("./files/sample.csv")
}
