module "wrapper" {
  source = "../"

  for_each = var.items

  create_table                       = try(each.value.create_table, var.defaults.create_table, true)
  name                               = try(each.value.name, var.defaults.name, null)
  attributes                         = try(each.value.attributes, var.defaults.attributes, [])
  hash_key                           = try(each.value.hash_key, var.defaults.hash_key, null)
  range_key                          = try(each.value.range_key, var.defaults.range_key, null)
  billing_mode                       = try(each.value.billing_mode, var.defaults.billing_mode, "PAY_PER_REQUEST")
  write_capacity                     = try(each.value.write_capacity, var.defaults.write_capacity, null)
  read_capacity                      = try(each.value.read_capacity, var.defaults.read_capacity, null)
  point_in_time_recovery_enabled     = try(each.value.point_in_time_recovery_enabled, var.defaults.point_in_time_recovery_enabled, false)
  ttl_enabled                        = try(each.value.ttl_enabled, var.defaults.ttl_enabled, false)
  ttl_attribute_name                 = try(each.value.ttl_attribute_name, var.defaults.ttl_attribute_name, "")
  global_secondary_indexes           = try(each.value.global_secondary_indexes, var.defaults.global_secondary_indexes, [])
  local_secondary_indexes            = try(each.value.local_secondary_indexes, var.defaults.local_secondary_indexes, [])
  replica_regions                    = try(each.value.replica_regions, var.defaults.replica_regions, [])
  stream_enabled                     = try(each.value.stream_enabled, var.defaults.stream_enabled, false)
  stream_view_type                   = try(each.value.stream_view_type, var.defaults.stream_view_type, null)
  server_side_encryption_enabled     = try(each.value.server_side_encryption_enabled, var.defaults.server_side_encryption_enabled, false)
  server_side_encryption_kms_key_arn = try(each.value.server_side_encryption_kms_key_arn, var.defaults.server_side_encryption_kms_key_arn, null)
  tags                               = try(each.value.tags, var.defaults.tags, {})
  timeouts = try(each.value.timeouts, var.defaults.timeouts, {
    create = "10m"
    update = "60m"
    delete = "10m"
  })
  autoscaling_enabled = try(each.value.autoscaling_enabled, var.defaults.autoscaling_enabled, false)
  autoscaling_defaults = try(each.value.autoscaling_defaults, var.defaults.autoscaling_defaults, {
    scale_in_cooldown  = 0
    scale_out_cooldown = 0
    target_value       = 70
  })
  autoscaling_read                      = try(each.value.autoscaling_read, var.defaults.autoscaling_read, {})
  autoscaling_write                     = try(each.value.autoscaling_write, var.defaults.autoscaling_write, {})
  autoscaling_indexes                   = try(each.value.autoscaling_indexes, var.defaults.autoscaling_indexes, {})
  table_class                           = try(each.value.table_class, var.defaults.table_class, null)
  deletion_protection_enabled           = try(each.value.deletion_protection_enabled, var.defaults.deletion_protection_enabled, null)
  ignore_changes_global_secondary_index = try(each.value.ignore_changes_global_secondary_index, var.defaults.ignore_changes_global_secondary_index, false)
}
