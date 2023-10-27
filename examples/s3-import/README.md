# DynamoDB Table s3 import example

Configuration in this directory creates an AWS DynamoDB table created from s3 imports (both json and csv examples).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.21 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_import_csv_table"></a> [import\_csv\_table](#module\_import\_csv\_table) | ../../ | n/a |
| <a name="module_import_json_table"></a> [import\_json\_table](#module\_import\_json\_table) | ../../ | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.15 |
| <a name="module_s3_import_object_csv"></a> [s3\_import\_object\_csv](#module\_s3\_import\_object\_csv) | terraform-aws-modules/s3-bucket/aws//modules/object | ~> 3.15 |
| <a name="module_s3_import_object_json"></a> [s3\_import\_object\_json](#module\_s3\_import\_object\_json) | terraform-aws-modules/s3-bucket/aws//modules/object | ~> 3.15 |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
