locals {
  autoscaling_enabled    = var.create && try(var.autoscaling.enabled, false) == true
  autoscaling_table_name = try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name, "")

  regions = distinct(concat([data.aws_region.current[0].region], local.dynamodb_table_replica_region_names))

  # Takes the indices and maps to each region (primary region + replicas)
  region_gsi = var.global_secondary_indexes != null ? flatten([for region in local.regions : [for k, v in var.global_secondary_indexes : merge({ index = k, region = region }, v)]]) : []

  # Result of what will be iterated over with `for_each`
  autoscaling_indices = { for ri in local.region_gsi : "${ri.index}/${ri.region}" => merge({ index = ri.index, region = ri.region }, ri.autoscaling) if try(ri.autoscaling.enabled, false) == true }
}

################################################################################
# Autoscaling - Table Read
################################################################################

resource "aws_appautoscaling_target" "table_read" {
  count = local.autoscaling_enabled && var.autoscaling.read != null ? length(local.regions) : 0

  region = local.regions[count.index]

  max_capacity       = var.autoscaling.read.max_capacity
  min_capacity       = try(coalesce(try(var.autoscaling.read.min_capacity, null), var.read_capacity), 1)
  resource_id        = "table/${local.autoscaling_table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count = local.autoscaling_enabled && var.autoscaling.read != null ? length(local.regions) : 0

  region = local.regions[count.index]

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(var.autoscaling.read.scale_in_cooldown, var.autoscaling.defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(var.autoscaling.read.scale_out_cooldown, var.autoscaling.defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(var.autoscaling.read.target_value, var.autoscaling.defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Table Write
################################################################################

resource "aws_appautoscaling_target" "table_write" {
  count = local.autoscaling_enabled && var.autoscaling.write != null ? length(local.regions) : 0

  region = local.regions[count.index]

  max_capacity       = var.autoscaling.write.max_capacity
  min_capacity       = try(coalesce(try(var.autoscaling.write.min_capacity, null), var.write_capacity), 1)
  resource_id        = "table/${local.autoscaling_table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count = local.autoscaling_enabled && var.autoscaling.write != null ? length(local.regions) : 0

  region = local.regions[count.index]

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(var.autoscaling.write.scale_in_cooldown, var.autoscaling.defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(var.autoscaling.write.scale_out_cooldown, var.autoscaling.defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(var.autoscaling.write.target_value, var.autoscaling.defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Index Read
################################################################################

resource "aws_appautoscaling_target" "index_read" {
  for_each = local.autoscaling_enabled ? local.autoscaling_indices : {}

  region = each.value.region

  max_capacity       = each.value.read_max_capacity
  min_capacity       = each.value.read_min_capacity
  resource_id        = "table/${local.autoscaling_table_name}/index/${each.value.index}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = local.autoscaling_enabled ? local.autoscaling_indices : {}

  region = each.value.region

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.index_read[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(each.value.scale_in_cooldown, var.autoscaling.defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(each.value.scale_out_cooldown, var.autoscaling.defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(each.value.target_value, var.autoscaling.defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Index Write
################################################################################

resource "aws_appautoscaling_target" "index_write" {
  for_each = local.autoscaling_enabled ? local.autoscaling_indices : {}

  region = each.value.region

  max_capacity       = each.value.write_max_capacity
  min_capacity       = each.value.write_min_capacity
  resource_id        = "table/${local.autoscaling_table_name}/index/${each.value.index}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = local.autoscaling_enabled ? local.autoscaling_indices : {}

  region = each.value.region

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.index_write[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(each.value.scale_in_cooldown, var.autoscaling.defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(each.value.scale_out_cooldown, var.autoscaling.defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(each.value.target_value, var.autoscaling.defaults.target_value), null)
  }
}
