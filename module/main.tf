resource "aws_appautoscaling_scheduled_action" "index_schedule" {
  for_each = { for k, v in var.schedule_scaling_indexes : k => v }

  name = "${var.name}-${each.key}"

  resource_id        = var.resource_id
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace

  schedule = each.value["schedule"]

  scalable_target_action {
    max_capacity = each.value["max_capacity"]
    min_capacity = each.value["min_capacity"]
  }
}
