output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = element(concat(aws_dynamodb_table.this.*.arn, [""]), 0)
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = element(concat(aws_dynamodb_table.this.*.id, [""]), 0)
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? concat(aws_dynamodb_table.this.*.stream_arn, [""])[0] : null
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? concat(aws_dynamodb_table.this.*.stream_label, [""])[0] : null
}
