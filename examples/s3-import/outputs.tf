output "import_json_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.import_json_table.dynamodb_table_arn
}

output "import_json_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.import_json_table.dynamodb_table_id
}

output "import_json_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = module.import_json_table.dynamodb_table_stream_arn
}

output "import_json_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = module.import_json_table.dynamodb_table_stream_label
}

output "import_csv_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.import_csv_table.dynamodb_table_arn
}

output "import_csv_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.import_csv_table.dynamodb_table_id
}

output "import_csv_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = module.import_csv_table.dynamodb_table_stream_arn
}

output "import_csv_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = module.import_csv_table.dynamodb_table_stream_label
}
