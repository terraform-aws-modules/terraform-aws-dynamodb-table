locals {
  dynamodb_table = try(aws_dynamodb_table.this[0], aws_dynamodb_table.autoscaled[0], aws_dynamodb_table.autoscaled_gsi_ignore[0], {})

  # Terraform did not like looking it up from the computed values
  dynamodb_table_replica_region_names = var.replicas[*].region_name
}

################################################################################
# Table
################################################################################

resource "aws_dynamodb_table" "this" {
  count = var.create && !var.autoscaling_enabled ? 1 : 0

  region = var.region

  dynamic "attribute" {
    for_each = var.attributes != null ? var.attributes : []

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  billing_mode                = var.billing_mode
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes != null ? var.global_secondary_indexes : {}

    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = try(coalesce(global_secondary_index.value.name, global_secondary_index.key), "")
      non_key_attributes = global_secondary_index.value.non_key_attributes

      dynamic "on_demand_throughput" {
        for_each = global_secondary_index.value.on_demand_throughput != null ? [global_secondary_index.value.on_demand_throughput] : []

        content {
          max_read_request_units  = on_demand_throughput.value.max_read_request_units
          max_write_request_units = on_demand_throughput.value.max_write_request_units
        }
      }

      projection_type = global_secondary_index.value.projection_type
      range_key       = global_secondary_index.value.range_key
      read_capacity   = global_secondary_index.value.read_capacity

      dynamic "warm_throughput" {
        for_each = global_secondary_index.value.warm_throughput != null ? [global_secondary_index.value.warm_throughput] : []

        content {
          read_units_per_second  = warm_throughput.value.read_units_per_second
          write_units_per_second = warm_throughput.value.write_units_per_second
        }
      }

      write_capacity = global_secondary_index.value.write_capacity
    }
  }

  dynamic "global_table_witness" {
    for_each = var.global_table_witness != null ? [var.global_table_witness] : []

    content {
      region_name = global_table_witness.value.region_name
    }
  }

  hash_key = var.hash_key

  dynamic "import_table" {
    for_each = var.import_table != null ? [var.import_table] : []

    content {
      input_compression_type = import_table.value.input_compression_type
      input_format           = import_table.value.input_format

      dynamic "input_format_options" {
        for_each = import_table.value.input_format_options != null ? [import_table.value.input_format_options] : []

        content {
          dynamic "csv" {
            for_each = import_table.value.input_format_options.csv != null ? [import_table.value.input_format_options.csv] : []

            content {
              delimiter   = csv.value.delimiter
              header_list = csv.value.header_list
            }
          }
        }
      }

      dynamic "s3_bucket_source" {
        for_each = [import_table.value.s3_bucket_source]

        content {
          bucket       = import_table.value.bucket
          bucket_owner = import_table.value.bucket_owner
          key_prefix   = import_table.value.key_prefix
        }
      }
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes != null ? var.local_secondary_indexes : {}

    content {
      name               = try(coalesce(local_secondary_index.value.name, local_secondary_index.key), "")
      non_key_attributes = local_secondary_index.value.non_key_attributes
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  name = var.name

  dynamic "on_demand_throughput" {
    for_each = var.on_demand_throughput != null ? [var.on_demand_throughput] : []

    content {
      max_read_request_units  = on_demand_throughput.value.max_read_request_units
      max_write_request_units = on_demand_throughput.value.max_write_request_units
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery != null ? [var.point_in_time_recovery] : []

    content {
      enabled                 = point_in_time_recovery.value.enabled
      recovery_period_in_days = point_in_time_recovery.value.recovery_period_in_days
    }
  }

  range_key     = var.range_key
  read_capacity = var.billing_mode == "PROVISIONED" ? var.read_capacity : null

  dynamic "replica" {
    for_each = length(var.replicas) > 0 ? var.replicas : []

    content {
      consistency_mode            = replica.value.consistency_mode
      deletion_protection_enabled = replica.value.deletion_protection_enabled
      kms_key_arn                 = replica.value.kms_key_arn
      point_in_time_recovery      = replica.value.point_in_time_recovery
      propagate_tags              = replica.value.propagate_tags
      region_name                 = replica.value.region_name
    }
  }

  restore_date_time        = var.restore_date_time
  restore_source_table_arn = var.restore_source_table_arn
  restore_source_name      = var.restore_source_name
  restore_to_latest_time   = var.restore_to_latest_time

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []

    content {
      enabled     = server_side_encryption.value.enabled
      kms_key_arn = server_side_encryption.value.kms_key_arn
    }
  }

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  table_class      = var.table_class

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []

    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  dynamic "warm_throughput" {
    for_each = var.warm_throughput != null ? [var.warm_throughput] : []

    content {
      read_units_per_second  = warm_throughput.value.read_units_per_second
      write_units_per_second = warm_throughput.value.write_units_per_second
    }
  }

  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

################################################################################
# Table - Autoscaled

# read_capacity/write_capacity arguments are ignored
################################################################################

resource "aws_dynamodb_table" "autoscaled" {
  count = var.create && var.autoscaling_enabled && !var.ignore_changes_global_secondary_index ? 1 : 0

  region = var.region

  dynamic "attribute" {
    for_each = var.attributes != null ? var.attributes : []

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  billing_mode                = var.billing_mode
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes != null ? var.global_secondary_indexes : {}

    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = try(coalesce(global_secondary_index.value.name, global_secondary_index.key), "")
      non_key_attributes = global_secondary_index.value.non_key_attributes

      dynamic "on_demand_throughput" {
        for_each = global_secondary_index.value.on_demand_throughput != null ? [global_secondary_index.value.on_demand_throughput] : []

        content {
          max_read_request_units  = on_demand_throughput.value.max_read_request_units
          max_write_request_units = on_demand_throughput.value.max_write_request_units
        }
      }

      projection_type = global_secondary_index.value.projection_type
      range_key       = global_secondary_index.value.range_key
      read_capacity   = global_secondary_index.value.read_capacity

      dynamic "warm_throughput" {
        for_each = global_secondary_index.value.warm_throughput != null ? [global_secondary_index.value.warm_throughput] : []

        content {
          read_units_per_second  = warm_throughput.value.read_units_per_second
          write_units_per_second = warm_throughput.value.write_units_per_second
        }
      }

      write_capacity = global_secondary_index.value.write_capacity
    }
  }

  dynamic "global_table_witness" {
    for_each = var.global_table_witness != null ? [var.global_table_witness] : []

    content {
      region_name = global_table_witness.value.region_name
    }
  }

  hash_key = var.hash_key

  dynamic "import_table" {
    for_each = var.import_table != null ? [var.import_table] : []

    content {
      input_compression_type = import_table.value.input_compression_type
      input_format           = import_table.value.input_format

      dynamic "input_format_options" {
        for_each = import_table.value.input_format_options != null ? [import_table.value.input_format_options] : []

        content {
          dynamic "csv" {
            for_each = import_table.value.input_format_options.csv != null ? [import_table.value.input_format_options.csv] : []

            content {
              delimiter   = csv.value.delimiter
              header_list = csv.value.header_list
            }
          }
        }
      }

      dynamic "s3_bucket_source" {
        for_each = [import_table.value.s3_bucket_source]

        content {
          bucket       = import_table.value.bucket
          bucket_owner = import_table.value.bucket_owner
          key_prefix   = import_table.value.key_prefix
        }
      }
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes != null ? var.local_secondary_indexes : {}

    content {
      name               = try(coalesce(local_secondary_index.value.name, local_secondary_index.key), "")
      non_key_attributes = local_secondary_index.value.non_key_attributes
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  name = var.name

  dynamic "on_demand_throughput" {
    for_each = var.on_demand_throughput != null ? [var.on_demand_throughput] : []

    content {
      max_read_request_units  = on_demand_throughput.value.max_read_request_units
      max_write_request_units = on_demand_throughput.value.max_write_request_units
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery != null ? [var.point_in_time_recovery] : []

    content {
      enabled                 = point_in_time_recovery.value.enabled
      recovery_period_in_days = point_in_time_recovery.value.recovery_period_in_days
    }
  }

  range_key     = var.range_key
  read_capacity = var.billing_mode == "PROVISIONED" ? var.read_capacity : null

  dynamic "replica" {
    for_each = length(var.replicas) > 0 ? var.replicas : []

    content {
      consistency_mode            = replica.value.consistency_mode
      deletion_protection_enabled = replica.value.deletion_protection_enabled
      kms_key_arn                 = replica.value.kms_key_arn
      point_in_time_recovery      = replica.value.point_in_time_recovery
      propagate_tags              = replica.value.propagate_tags
      region_name                 = replica.value.region_name
    }
  }

  restore_date_time        = var.restore_date_time
  restore_source_table_arn = var.restore_source_table_arn
  restore_source_name      = var.restore_source_name
  restore_to_latest_time   = var.restore_to_latest_time

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []

    content {
      enabled     = server_side_encryption.value.enabled
      kms_key_arn = server_side_encryption.value.kms_key_arn
    }
  }

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  table_class      = var.table_class

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []

    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  dynamic "warm_throughput" {
    for_each = var.warm_throughput != null ? [var.warm_throughput] : []

    content {
      read_units_per_second  = warm_throughput.value.read_units_per_second
      write_units_per_second = warm_throughput.value.write_units_per_second
    }
  }

  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
}

################################################################################
# Table - Autoscaled with GSI

# read_capacity/write_capacity and global_secondary_index arguments are ignored
################################################################################

resource "aws_dynamodb_table" "autoscaled_gsi_ignore" {
  count = var.create && var.autoscaling_enabled && var.ignore_changes_global_secondary_index ? 1 : 0

  region = var.region

  dynamic "attribute" {
    for_each = var.attributes != null ? var.attributes : []

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  billing_mode                = var.billing_mode
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes != null ? var.global_secondary_indexes : {}

    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = try(coalesce(global_secondary_index.value.name, global_secondary_index.key), "")
      non_key_attributes = global_secondary_index.value.non_key_attributes

      dynamic "on_demand_throughput" {
        for_each = global_secondary_index.value.on_demand_throughput != null ? [global_secondary_index.value.on_demand_throughput] : []

        content {
          max_read_request_units  = on_demand_throughput.value.max_read_request_units
          max_write_request_units = on_demand_throughput.value.max_write_request_units
        }
      }

      projection_type = global_secondary_index.value.projection_type
      range_key       = global_secondary_index.value.range_key
      read_capacity   = global_secondary_index.value.read_capacity

      dynamic "warm_throughput" {
        for_each = global_secondary_index.value.warm_throughput != null ? [global_secondary_index.value.warm_throughput] : []

        content {
          read_units_per_second  = warm_throughput.value.read_units_per_second
          write_units_per_second = warm_throughput.value.write_units_per_second
        }
      }

      write_capacity = global_secondary_index.value.write_capacity
    }
  }

  dynamic "global_table_witness" {
    for_each = var.global_table_witness != null ? [var.global_table_witness] : []

    content {
      region_name = global_table_witness.value.region_name
    }
  }

  hash_key = var.hash_key

  dynamic "import_table" {
    for_each = var.import_table != null ? [var.import_table] : []

    content {
      input_compression_type = import_table.value.input_compression_type
      input_format           = import_table.value.input_format

      dynamic "input_format_options" {
        for_each = import_table.value.input_format_options != null ? [import_table.value.input_format_options] : []

        content {
          dynamic "csv" {
            for_each = import_table.value.input_format_options.csv != null ? [import_table.value.input_format_options.csv] : []

            content {
              delimiter   = csv.value.delimiter
              header_list = csv.value.header_list
            }
          }
        }
      }

      dynamic "s3_bucket_source" {
        for_each = [import_table.value.s3_bucket_source]

        content {
          bucket       = import_table.value.bucket
          bucket_owner = import_table.value.bucket_owner
          key_prefix   = import_table.value.key_prefix
        }
      }
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes != null ? var.local_secondary_indexes : {}

    content {
      name               = try(coalesce(local_secondary_index.value.name, local_secondary_index.key), "")
      non_key_attributes = local_secondary_index.value.non_key_attributes
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  name = var.name

  dynamic "on_demand_throughput" {
    for_each = var.on_demand_throughput != null ? [var.on_demand_throughput] : []

    content {
      max_read_request_units  = on_demand_throughput.value.max_read_request_units
      max_write_request_units = on_demand_throughput.value.max_write_request_units
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery != null ? [var.point_in_time_recovery] : []

    content {
      enabled                 = point_in_time_recovery.value.enabled
      recovery_period_in_days = point_in_time_recovery.value.recovery_period_in_days
    }
  }

  range_key     = var.range_key
  read_capacity = var.billing_mode == "PROVISIONED" ? var.read_capacity : null

  dynamic "replica" {
    for_each = length(var.replicas) > 0 ? var.replicas : []

    content {
      consistency_mode            = replica.value.consistency_mode
      deletion_protection_enabled = replica.value.deletion_protection_enabled
      kms_key_arn                 = replica.value.kms_key_arn
      point_in_time_recovery      = replica.value.point_in_time_recovery
      propagate_tags              = replica.value.propagate_tags
      region_name                 = replica.value.region_name
    }
  }

  restore_date_time        = var.restore_date_time
  restore_source_table_arn = var.restore_source_table_arn
  restore_source_name      = var.restore_source_name
  restore_to_latest_time   = var.restore_to_latest_time

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []

    content {
      enabled     = server_side_encryption.value.enabled
      kms_key_arn = server_side_encryption.value.kms_key_arn
    }
  }

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  table_class      = var.table_class

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []

    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  dynamic "warm_throughput" {
    for_each = var.warm_throughput != null ? [var.warm_throughput] : []

    content {
      read_units_per_second  = warm_throughput.value.read_units_per_second
      write_units_per_second = warm_throughput.value.write_units_per_second
    }
  }

  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    ignore_changes = [
      global_secondary_index,
      read_capacity,
      write_capacity,
    ]
  }
}

################################################################################
# Resource Policy - Table
################################################################################

locals {
  create_resource_policy = var.create && var.resource_policy_statements != null
}

data "aws_iam_policy_document" "resource_policy" {
  count = local.create_resource_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.resource_policy_statements != null ? var.resource_policy_statements : {}

    content {
      sid           = try(coalesce(statement.value.sid, statement.key))
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = coalescelist(statement.value.resources, ["__DYNAMODB_TABLE_ARN__"])
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_dynamodb_resource_policy" "this" {
  count = local.create_resource_policy ? 1 : 0

  region       = var.region
  resource_arn = local.dynamodb_table.arn
  policy       = replace(data.aws_iam_policy_document.resource_policy[0].json, "__DYNAMODB_TABLE_ARN__", local.dynamodb_table.arn)
}

################################################################################
# Resource Policy - Replica Table(s)
################################################################################

locals {
  dynamodb_table_replica_arns = try(local.dynamodb_table.replica[*].arn, [])
}

resource "aws_dynamodb_resource_policy" "replica" {
  count = local.create_resource_policy ? length(var.replicas) : 0

  region = local.dynamodb_table_replica_region_names[count.index]

  resource_arn = local.dynamodb_table_replica_arns[count.index]
  policy       = replace(data.aws_iam_policy_document.resource_policy[0].json, "__DYNAMODB_TABLE_ARN__", local.dynamodb_table_replica_arns[count.index])
}

################################################################################
# Resource Policy - Stream
################################################################################

locals {
  create_stream_resource_policy = var.create && var.stream_resource_policy_statements != null
}

data "aws_iam_policy_document" "stream_resource_policy" {
  count = local.create_stream_resource_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.stream_resource_policy_statements != null ? var.stream_resource_policy_statements : {}

    content {
      sid           = try(coalesce(statement.value.sid, statement.key))
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = coalescelist(statement.value.resources, ["__DYNAMODB_TABLE_STREAM__"])
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_dynamodb_resource_policy" "stream" {
  count = local.create_stream_resource_policy ? 1 : 0

  region       = var.region
  resource_arn = local.dynamodb_table.stream_arn
  policy       = replace(data.aws_iam_policy_document.stream_resource_policy[0].json, "__DYNAMODB_TABLE_STREAM__", local.dynamodb_table.stream_arn)
}

################################################################################
# Resource Policy - Replica Stream(s)
################################################################################

locals {
  dynamodb_table_replica_stream_arns = try(local.dynamodb_table.replica[*].stream_arn, [])
}

resource "aws_dynamodb_resource_policy" "replica_stream" {
  count = local.create_stream_resource_policy ? length(var.replicas) : 0

  region = local.dynamodb_table_replica_region_names[count.index]

  resource_arn = local.dynamodb_table_replica_stream_arns[count.index]
  policy       = replace(data.aws_iam_policy_document.stream_resource_policy[0].json, "__DYNAMODB_TABLE_STREAM__", local.dynamodb_table_replica_stream_arns[count.index])
}
