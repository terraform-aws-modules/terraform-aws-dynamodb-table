variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Table
################################################################################

variable "attributes" {
  description = "Set of nested attribute definitions. Only required for `hash_key` and `range_key` attributes"
  type = list(object({
    name = string
    type = string
  }))
  default = null
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table"
  type        = bool
  default     = true
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc"
  type = map(object({
    hash_key           = string
    name               = optional(string) # will fall back to map key if not provided
    non_key_attributes = optional(list(string))
    on_demand_throughput = optional(object({
      max_read_request_units  = optional(number)
      max_write_request_units = optional(number)
    }))
    projection_type = string
    range_key       = optional(string)
    read_capacity   = optional(number)
    warm_throughput = optional(object({
      read_capacity  = optional(number)
      write_capacity = optional(number)
    }))
    write_capacity = optional(number)
  }))
  default = null
}

variable "global_table_witness" {
  description = "Witness Region in a Multi-Region Strong Consistency deployment. Note This must be used alongside a single replica with consistency_mode set to STRONG. Other combinations will fail to provision"
  type = object({
    region_name = optional(string)
  })
  default = null
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "import_table" {
  description = "Configurations for importing s3 data into a new table"
  type = object({
    input_compression_type = optional(string)
    input_format           = string
    input_format_options = optional(object({
      csv = optional(object({
        delimiter   = optional(string)
        header_list = optional(list(string))
      }))
    }))
    s3_bucket_source = object({
      bucket       = string
      bucket_owner = optional(string)
      key_prefix   = optional(string)
    })
  })
  default = null
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource"
  type = map(object({
    name               = optional(string) # will fall back to map key if not provided
    non_key_attributes = optional(list(string))
    projection_type    = string
    range_key          = string
  }))
  default = null
}

variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = null
}

variable "on_demand_throughput" {
  description = "Sets the maximum number of read and write units for the specified on-demand table"
  type = object({
    max_read_request_units  = optional(number)
    max_write_request_units = optional(number)
  })
  default = null
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery options"
  type = object({
    enabled                 = optional(bool, true)
    recovery_period_in_days = optional(number)
  })
  default = null
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "replicas" {
  description = "Region names for creating replicas for a global DynamoDB table"
  type = list(object({
    consistency_mode            = optional(string)
    deletion_protection_enabled = optional(bool, true)
    kms_key_arn                 = optional(string)
    point_in_time_recovery      = optional(bool)
    propagate_tags              = optional(bool, true)
    region_name                 = string
  }))
  default  = []
  nullable = false
}

variable "restore_date_time" {
  description = "Time of the point-in-time recovery point to restore"
  type        = string
  default     = null
}

variable "restore_source_table_arn" {
  description = "ARN of the source table to restore. Must be supplied for cross-region restores"
  type        = string
  default     = null
}

variable "restore_source_name" {
  description = "Name of the table to restore. Must match the name of an existing table"
  type        = string
  default     = null
}

variable "restore_to_latest_time" {
  description = "If set, restores table to the most recent point-in-time recovery point"
  type        = bool
  default     = null
}

variable "server_side_encryption" {
  description = "Enable server-side encryption options"
  type = object({
    enabled     = optional(bool, true)
    kms_key_arn = optional(string)
  })
  default = {
    enabled = true
  }
}

variable "stream_enabled" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES"
  type        = string
  default     = null
}

variable "table_class" {
  description = "The storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = null
}

variable "ttl" {
  description = "Enable Time to Live (TTL) settings"
  type = object({
    attribute_name = optional(string)
    enabled        = optional(bool)
  })
  default = null
}

variable "warm_throughput" {
  description = "Sets the number of warm read and write units for the specified table"
  type = object({
    read_units_per_second  = optional(number)
    write_units_per_second = optional(number)
  })
  default = null
}

variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the table"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "ignore_changes_global_secondary_index" {
  description = "Whether to ignore changes lifecycle to global secondary indices, useful for provisioned tables with scaling"
  type        = bool
  default     = false
}

################################################################################
# Resource Policy
################################################################################

variable "resource_policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for table resource policy permissions"
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string, "Allow")
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = null
}


variable "stream_resource_policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for stream resource policy permissions"
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string, "Allow")
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = null
}

################################################################################
# Autoscaling
################################################################################

variable "autoscaling_enabled" {
  description = "Whether or not to enable autoscaling. See note in README about this setting"
  type        = bool
  default     = false
}

variable "autoscaling_defaults" {
  description = "Default autoscaling settings"
  type = object({
    scale_in_cooldown  = optional(number, 0)
    scale_out_cooldown = optional(number, 0)
    target_value       = optional(number, 70)
  })
  default = {}
}

variable "autoscaling_read" {
  description = "Autoscaling read capacity configuration settings. See example in examples/autoscaling"
  type = object({
    max_capacity       = number
    min_capacity       = optional(number)
    scale_in_cooldown  = optional(number)
    scale_out_cooldown = optional(number)
    target_value       = optional(number)
  })
  default = null
}

variable "autoscaling_write" {
  description = "Autoscaling write capacity configuration settings. See example in examples/autoscaling"
  type = object({
    max_capacity       = number
    min_capacity       = optional(number)
    scale_in_cooldown  = optional(number)
    scale_out_cooldown = optional(number)
    target_value       = optional(number)
  })
  default = null
}

variable "autoscaling_indexes" {
  description = "A map of index autoscaling configurations where the map key matches the name of the index to autoscale. See example in examples/autoscaling"
  type = map(object({
    read_max_capacity  = number
    read_min_capacity  = number
    write_max_capacity = number
    write_min_capacity = number
    scale_in_cooldown  = optional(number)
    scale_out_cooldown = optional(number)
    target_value       = optional(number)
  }))
  default = null
}
