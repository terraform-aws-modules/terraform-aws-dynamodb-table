output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream"
  value       = module.dynamodb_table.dynamodb_table_stream_arn
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream"
  value       = module.dynamodb_table.dynamodb_table_stream_label
}

output "dynamodb_table_replicas" {
  description = "Map of Table replicas by region"
  value       = module.dynamodb_table.dynamodb_table_replicas
}

output "dynamodb_table_replica_arns" {
  description = "Map of the Table replicas ARNs"
  value       = module.dynamodb_table.dynamodb_table_replica_arns
}

output "dynamodb_table_replica_stream_arns" {
  description = "Map of the Table replicas stream ARNs"
  value       = module.dynamodb_table.dynamodb_table_replica_stream_arns
}

output "dynamodb_table_replica_stream_labels" {
  description = "Map of the timestamps of the Table replicas stream"
  value       = module.dynamodb_table.dynamodb_table_replica_stream_labels
}
