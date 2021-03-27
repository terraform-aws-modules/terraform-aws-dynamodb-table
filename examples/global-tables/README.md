# DynamoDB Table example

Configuration in this directory creates a Global AWS DynamoDB table with replicas in eu-west-1 and eu-west-2 regions.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.58 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | ../../ |  |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_dynamodb_table_arn"></a> [this\_dynamodb\_table\_arn](#output\_this\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_this_dynamodb_table_id"></a> [this\_dynamodb\_table\_id](#output\_this\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_this_dynamodb_table_stream_arn"></a> [this\_dynamodb\_table\_stream\_arn](#output\_this\_dynamodb\_table\_stream\_arn) | The ARN of the Table Stream. Only available when var.stream\_enabled is true |
| <a name="output_this_dynamodb_table_stream_label"></a> [this\_dynamodb\_table\_stream\_label](#output\_this\_dynamodb\_table\_stream\_label) | A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream\_enabled is true |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
