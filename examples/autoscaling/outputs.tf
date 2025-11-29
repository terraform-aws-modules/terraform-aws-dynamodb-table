output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.dynamodb_table.id
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when `stream_enabled = true`"
  value       = module.dynamodb_table.stream_arn
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when `stream_enabled = true`"
  value       = module.dynamodb_table.stream_label
}

output "dynamodb_table_replicas" {
  description = "The DynamoDB Table replica(s) created and their attributes"
  value       = module.dynamodb_table.replicas
}
