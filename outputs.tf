output "arn" {
  description = "ARN of the DynamoDB table"
  value       = local.dynamodb_table.arn
}

output "id" {
  description = "ID of the DynamoDB table"
  value       = local.dynamodb_table.id
}

output "stream_arn" {
  description = "The ARN of the Table Stream. Only available when `stream_enabled = true`"
  value       = local.dynamodb_table.stream_arn
}

output "stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when `stream_enabled = true`"
  value       = local.dynamodb_table.stream_label
}

output "replicas" {
  description = "The DynamoDB Table replica(s) created and their attributes"
  value       = { for r in local.dynamodb_table.replica : r.region_name => r }
}
