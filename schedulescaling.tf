resource "aws_appautoscaling_scheduled_action" "table_read_schedule" {
  for_each = var.create_table && var.autoscaling_enabled && length(var.schedule_scaling_read) > 0 ? { for k, v in var.schedule_scaling_read : k => v } : {}

  name = "DynamoDBReadCapacityUtilization-${replace(aws_appautoscaling_target.table_read[0].resource_id, "/", "-")}-${each.key}"

  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[0].service_namespace

  schedule = each.value["schedule"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}

module "index_read_schedule" {
  for_each = var.create_table && length(var.schedule_scaling_indexes_read) > 0 ? var.autoscaling_indexes : {}
  source   = "./module"

  name = "DynamoDBReadCapacityUtilization-${replace(aws_appautoscaling_target.index_read[each.key].resource_id, "/", "-")}"

  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace

  schedule_scaling_indexes = var.schedule_scaling_indexes_read[each.key]
}

resource "aws_appautoscaling_scheduled_action" "table_write_schedule" {
  for_each = var.create_table && var.autoscaling_enabled && length(var.schedule_scaling_write) > 0 ? { for k, v in var.schedule_scaling_write : k => v } : {}

  name = "DynamoDBWriteCapacityUtilization-${replace(aws_appautoscaling_target.table_write[0].resource_id, "/", "-")}-${each.key}"

  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[0].service_namespace

  schedule = each.value["schedule"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}

module "index_write_schedule" {
  for_each = var.create_table && length(var.schedule_scaling_indexes_write) > 0 ? var.autoscaling_indexes : {}
  source   = "./module"

  name = "DynamoDBWriteCapacityUtilization-${replace(aws_appautoscaling_target.index_write[each.key].resource_id, "/", "-")}"

  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace

  schedule_scaling_indexes = var.schedule_scaling_indexes_write[each.key]
}
