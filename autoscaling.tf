locals {
  autoscaling = {
    enabled    = var.create && var.autoscaling_enabled
    table_name = try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name, "")
  }
}

################################################################################
# Autoscaling - Table Read
################################################################################

resource "aws_appautoscaling_target" "table_read" {
  count = local.autoscaling.enabled && var.autoscaling_read != null ? 1 : 0

  region = var.region

  max_capacity       = var.autoscaling_read.max_capacity
  min_capacity       = try(coalesce(var.autoscaling_read.min_capacity, var.read_capacity), null)
  resource_id        = "table/${local.autoscaling.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count = local.autoscaling.enabled && var.autoscaling_read != null ? 1 : 0

  region = var.region

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(var.autoscaling_read.scale_in_cooldown, var.autoscaling_defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(var.autoscaling_read.scale_out_cooldown, var.autoscaling_defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(var.autoscaling_read.target_value, var.autoscaling_defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Table Write
################################################################################

resource "aws_appautoscaling_target" "table_write" {
  count = local.autoscaling.enabled && var.autoscaling_write != null ? 1 : 0

  region = var.region

  max_capacity       = var.autoscaling_write.max_capacity
  min_capacity       = var.write_capacity
  resource_id        = "table/${local.autoscaling.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count = local.autoscaling.enabled && var.autoscaling_write != null ? 1 : 0

  region = var.region

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(var.autoscaling_write.scale_in_cooldown, var.autoscaling_defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(var.autoscaling_write.scale_out_cooldown, var.autoscaling_defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(var.autoscaling_write.target_value, var.autoscaling_defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Index Read
################################################################################

resource "aws_appautoscaling_target" "index_read" {
  for_each = local.autoscaling.enabled && var.autoscaling_indexes != null ? var.autoscaling_indexes : {}

  region = var.region

  max_capacity       = each.value.read_max_capacity
  min_capacity       = each.value.read_min_capacity
  resource_id        = "table/${local.autoscaling.table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = local.autoscaling.enabled && var.autoscaling_indexes != null ? var.autoscaling_indexes : {}

  region = var.region

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.index_read[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(each.value.scale_in_cooldown, var.autoscaling_defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(each.value.scale_out_cooldown, var.autoscaling_defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(each.value.target_value, var.autoscaling_defaults.target_value), null)
  }
}

################################################################################
# Autoscaling - Index Write
################################################################################

resource "aws_appautoscaling_target" "index_write" {
  for_each = local.autoscaling.enabled && var.autoscaling_indexes != null ? var.autoscaling_indexes : {}

  region = var.region

  max_capacity       = each.value["write_max_capacity"]
  min_capacity       = each.value["write_min_capacity"]
  resource_id        = "table/${local.autoscaling.table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = local.autoscaling.enabled && var.autoscaling_indexes != null ? var.autoscaling_indexes : {}

  region = var.region

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.index_write[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = try(coalesce(each.value.scale_in_cooldown, var.autoscaling_defaults.scale_in_cooldown), null)
    scale_out_cooldown = try(coalesce(each.value.scale_out_cooldown, var.autoscaling_defaults.scale_out_cooldown), null)
    target_value       = try(coalesce(each.value.target_value, var.autoscaling_defaults.target_value), null)
  }
}
