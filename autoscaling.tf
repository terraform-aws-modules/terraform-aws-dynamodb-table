locals {
  autoscaling_scheduled_indexes_read = flatten([
    for k, v in var.autoscaling_scheduled_indexes_read : [
      for i in range(length(v)) : {
        key          = k
        index        = i
        schedule     = v[i].schedule
        start_time   = try(v[i].start_time, null)
        end_time     = try(v[i].end_time, null)
        timezone     = try(v[i].timezone, null)
        min_capacity = v[i].min_capacity
        max_capacity = v[i].max_capacity
      }
    ]
  ])
  autoscaling_scheduled_indexes_write = flatten([
    for k, v in var.autoscaling_scheduled_indexes_write : [
      for i in range(length(v)) : {
        key          = k
        index        = i
        schedule     = v[i].schedule
        start_time   = try(v[i].start_time, null)
        end_time     = try(v[i].end_time, null)
        timezone     = try(v[i].timezone, null)
        min_capacity = v[i].min_capacity
        max_capacity = v[i].max_capacity
      }
    ]
  ])
}

resource "aws_appautoscaling_target" "table_read" {
  count = var.create_table && var.autoscaling_enabled && length(var.autoscaling_read) > 0 ? 1 : 0

  max_capacity       = var.autoscaling_read["max_capacity"]
  min_capacity       = var.read_capacity
  resource_id        = "table/${try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name)}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count = var.create_table && var.autoscaling_enabled && length(var.autoscaling_read) > 0 ? 1 : 0

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = lookup(var.autoscaling_read, "scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(var.autoscaling_read, "scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(var.autoscaling_read, "target_value", var.autoscaling_defaults["target_value"])
  }
}

resource "aws_appautoscaling_target" "table_write" {
  count = var.create_table && var.autoscaling_enabled && length(var.autoscaling_write) > 0 ? 1 : 0

  max_capacity       = var.autoscaling_write["max_capacity"]
  min_capacity       = var.write_capacity
  resource_id        = "table/${try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name)}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count = var.create_table && var.autoscaling_enabled && length(var.autoscaling_write) > 0 ? 1 : 0

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = lookup(var.autoscaling_write, "scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(var.autoscaling_write, "scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(var.autoscaling_write, "target_value", var.autoscaling_defaults["target_value"])
  }
}

resource "aws_appautoscaling_target" "index_read" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  max_capacity       = each.value["read_max_capacity"]
  min_capacity       = each.value["read_min_capacity"]
  resource_id        = "table/${try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name)}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.index_read[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = merge(var.autoscaling_defaults, each.value)["scale_in_cooldown"]
    scale_out_cooldown = merge(var.autoscaling_defaults, each.value)["scale_out_cooldown"]
    target_value       = merge(var.autoscaling_defaults, each.value)["target_value"]
  }
}

resource "aws_appautoscaling_target" "index_write" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  max_capacity       = each.value["write_max_capacity"]
  min_capacity       = each.value["write_min_capacity"]
  resource_id        = "table/${try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name)}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.index_write[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = merge(var.autoscaling_defaults, each.value)["scale_in_cooldown"]
    scale_out_cooldown = merge(var.autoscaling_defaults, each.value)["scale_out_cooldown"]
    target_value       = merge(var.autoscaling_defaults, each.value)["target_value"]
  }
}

resource "aws_appautoscaling_scheduled_action" "table_read_schedule" {
  for_each = { for k, v in var.autoscaling_scheduled_read : k => v if var.create_table && var.autoscaling_enabled && length(var.autoscaling_scheduled_read) > 0 }

  name = "DynamoDBReadCapacityUtilization-${replace(aws_appautoscaling_target.table_read[0].resource_id, "/", "-")}-${each.key}"

  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  schedule   = each.value["schedule"]
  start_time = each.value["start_time"]
  end_time   = each.value["end_time"]
  timezone   = each.value["timezone"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}

resource "aws_appautoscaling_scheduled_action" "index_read_schedule" {
  for_each = { for i in local.autoscaling_scheduled_indexes_read : "${i.key}-${i.index}" => i if var.create_table && var.autoscaling_enabled }

  name = "DynamoDBReadCapacityUtilization-${replace(aws_appautoscaling_target.index_read[each.value["key"]].resource_id, "/", "-")}"

  resource_id        = aws_appautoscaling_target.index_read[each.value["key"]].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.value["key"]].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.value["key"]].service_namespace

  schedule   = each.value["schedule"]
  start_time = each.value["start_time"]
  end_time   = each.value["end_time"]
  timezone   = each.value["timezone"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}

resource "aws_appautoscaling_scheduled_action" "table_write_schedule" {
  for_each = { for k, v in var.autoscaling_scheduled_write : k => v if var.create_table && var.autoscaling_enabled && length(var.autoscaling_scheduled_write) > 0 }

  name = "DynamoDBWriteCapacityUtilization-${replace(aws_appautoscaling_target.table_write[0].resource_id, "/", "-")}-${each.key}"

  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  schedule   = each.value["schedule"]
  start_time = each.value["start_time"]
  end_time   = each.value["end_time"]
  timezone   = each.value["timezone"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}

resource "aws_appautoscaling_scheduled_action" "index_write_schedule" {
  for_each = { for i in local.autoscaling_scheduled_indexes_write : "${i.key}-${i.index}" => i if var.create_table && var.autoscaling_enabled }

  name = "DynamoDBWriteCapacityUtilization-${replace(aws_appautoscaling_target.index_write[each.value["key"]].resource_id, "/", "-")}"

  resource_id        = aws_appautoscaling_target.index_write[each.value["key"]].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.value["key"]].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.value["key"]].service_namespace

  schedule   = each.value["schedule"]
  start_time = each.value["start_time"]
  end_time   = each.value["end_time"]
  timezone   = each.value["timezone"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}
