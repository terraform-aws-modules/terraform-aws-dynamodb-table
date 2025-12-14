locals {
  replicas              = { for v in try(aws_dynamodb_table.this[0].replica[*], aws_dynamodb_table.autoscaled[0].replica[*], aws_dynamodb_table.autoscaled_gsi_ignore[0].replica[*], []) : v.region_name => v }
  replica_arns          = { for v in local.replicas : v.region_name => v.arn }
  replica_stream_arns   = { for v in local.replicas : v.region_name => v.stream_arn }
  replica_stream_labels = { for v in local.replicas : v.region_name => v.stream_label }
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = local.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.this[0].id, aws_dynamodb_table.autoscaled[0].id, aws_dynamodb_table.autoscaled_gsi_ignore[0].id, "")
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream"
  value       = try(aws_dynamodb_table.this[0].stream_arn, aws_dynamodb_table.autoscaled[0].stream_arn, aws_dynamodb_table.autoscaled_gsi_ignore[0].stream_arn, "")
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream"
  value       = try(aws_dynamodb_table.this[0].stream_label, aws_dynamodb_table.autoscaled[0].stream_label, aws_dynamodb_table.autoscaled_gsi_ignore[0].stream_label, "")
}

output "dynamodb_table_replicas" {
  description = "Map of Table replicas by region"
  value       = local.replicas
}

output "dynamodb_table_replica_arns" {
  description = "Map of the Table replicas ARNs"
  value       = local.replica_arns
}

output "dynamodb_table_replica_stream_arns" {
  description = "Map of the Table replicas stream ARNs"
  value       = local.replica_stream_arns
}

output "dynamodb_table_replica_stream_labels" {
  description = "Map of the timestamps of the Table replicas stream"
  value       = local.replica_stream_labels
}
