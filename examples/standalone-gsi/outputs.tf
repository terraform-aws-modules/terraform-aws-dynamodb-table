output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_standalone_global_secondary_index_arns" {
  description = "Map of standalone GSI ARNs, keyed by index name"
  value       = module.dynamodb_table.dynamodb_table_standalone_global_secondary_index_arns
}
