# DynamoDB Table w/ S3 Import Example

Configuration in this directory creates an AWS DynamoDB table created from S3 imports (both JSON and CSV examples).

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.22 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_import_csv_table"></a> [import\_csv\_table](#module\_import\_csv\_table) | ../../ | n/a |
| <a name="module_import_json_table"></a> [import\_json\_table](#module\_import\_json\_table) | ../../ | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |
| <a name="module_s3_import_object_csv"></a> [s3\_import\_object\_csv](#module\_s3\_import\_object\_csv) | terraform-aws-modules/s3-bucket/aws//modules/object | ~> 5.0 |
| <a name="module_s3_import_object_json"></a> [s3\_import\_object\_json](#module\_s3\_import\_object\_json) | terraform-aws-modules/s3-bucket/aws//modules/object | ~> 5.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_import_csv_table_arn"></a> [import\_csv\_table\_arn](#output\_import\_csv\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_import_csv_table_id"></a> [import\_csv\_table\_id](#output\_import\_csv\_table\_id) | ID of the DynamoDB table |
| <a name="output_import_csv_table_stream_arn"></a> [import\_csv\_table\_stream\_arn](#output\_import\_csv\_table\_stream\_arn) | The ARN of the Table Stream. Only available when var.stream\_enabled is true |
| <a name="output_import_csv_table_stream_label"></a> [import\_csv\_table\_stream\_label](#output\_import\_csv\_table\_stream\_label) | A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream\_enabled is true |
| <a name="output_import_json_table_arn"></a> [import\_json\_table\_arn](#output\_import\_json\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_import_json_table_id"></a> [import\_json\_table\_id](#output\_import\_json\_table\_id) | ID of the DynamoDB table |
| <a name="output_import_json_table_stream_arn"></a> [import\_json\_table\_stream\_arn](#output\_import\_json\_table\_stream\_arn) | The ARN of the Table Stream. Only available when var.stream\_enabled is true |
| <a name="output_import_json_table_stream_label"></a> [import\_json\_table\_stream\_label](#output\_import\_json\_table\_stream\_label) | A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream\_enabled is true |
<!-- END_TF_DOCS -->
