output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].arn, aws_dynamodb_table.autoscaled[0].arn, "")
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].id, aws_dynamodb_table.autoscaled[0].id, "")
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? try(aws_dynamodb_table.this[0].stream_arn, aws_dynamodb_table.autoscaled[0].stream_arn, "") : null
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? try(aws_dynamodb_table.this[0].stream_label, aws_dynamodb_table.autoscaled[0].stream_label, "") : null
}
