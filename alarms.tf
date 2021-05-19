module "ddb_consume_read_capacity_alarms" {
  source              = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  for_each            = var.create_table && length(var.alarm_actions) > 0 ? toset(concat([""], keys(var.autoscaling_indexes))) : []
  alarm_actions       = var.alarm_actions
  alarm_name          = join("-", ["awsdynamodb", var.name, each.key, "ConsumedReadCapacityUnits"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_defaults.evaluation_periods
  threshold           = ceil((each.key != "" ? var.autoscaling_indexes[each.key].read_max_capacity : var.autoscaling_read.max_capacity) * var.alarm_defaults.period * var.autoscaling_defaults.target_value / 100)
  period              = var.alarm_defaults.period
  unit                = "Count"
  namespace           = "AWS/DynamoDB"
  metric_name         = "ConsumedReadCapacityUnits"
  statistic           = "Sum"
  dimensions = merge({
    TableName = var.name
    }, each.key != "" ? {
    GlobalSecondaryIndexName = each.key
  } : {})
  treat_missing_data = "ignore"
  tags               = var.tags
}

module "ddb_consume_write_capacity_alarms" {
  source              = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  for_each            = var.create_table && length(var.alarm_actions) > 0 ? toset(concat([""], keys(var.autoscaling_indexes))) : []
  alarm_actions       = var.alarm_actions
  alarm_name          = join("-", ["awsdynamodb", var.name, each.key, "ConsumedWriteCapacityUnits"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_defaults.evaluation_periods
  threshold           = ceil((each.key != "" ? var.autoscaling_indexes[each.key].write_max_capacity : var.autoscaling_write.max_capacity) * var.alarm_defaults.period * var.autoscaling_defaults.target_value / 100)
  period              = var.alarm_defaults.period
  unit                = "Count"
  namespace           = "AWS/DynamoDB"
  metric_name         = "ConsumedWriteCapacityUnits"
  statistic           = "Sum"
  dimensions = merge({
    TableName = var.name
    }, each.key != "" ? {
    GlobalSecondaryIndexName = each.key
  } : {})
  treat_missing_data = "ignore"
  tags               = var.tags
}
