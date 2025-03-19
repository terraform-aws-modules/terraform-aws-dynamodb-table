# AWS DynamoDB Table Terraform module

Terraform module to create a DynamoDB table.

## Usage

```hcl
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "my-table"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
```

## Notes

**Warning: enabling or disabling autoscaling can cause your table to be recreated**

There are two separate Terraform resources used for the DynamoDB table: one is for when any autoscaling is enabled the other when disabled. If your table is already created and then you change the variable `autoscaling_enabled` then your table will be recreated by Terraform. In this case you will need to move the old `aws_dynamodb_table` resource that is being `destroyed` to the new resource that is being `created`. For example:

```
terraform state mv module.dynamodb_table.aws_dynamodb_table.this module.dynamodb_table.aws_dynamodb_table.autoscaled
```

**Warning: autoscaling with global secondary indexes**

When using an autoscaled provisioned table with GSIs you may find that applying TF changes whilst a GSI is scaled up will reset the capacity, there
is an [open issue for this on the AWS Provider](https://github.com/hashicorp/terraform-provider-aws/issues/671). To get around this issue you can enable
the `ignore_changes_global_secondary_index` setting however, using this setting means that any changes to GSIs will be ignored by Terraform and will
hence have to be applied manually (or via some other automation).

**NOTE**: Setting `ignore_changes_global_secondary_index` after the table is already created causes your table to be recreated. In this case, you will
need to move the old `aws_dynamodb_table` resource that is being `destroyed` to the new resource that is being `created`. For example:

```
terraform state mv module.dynamodb_table.aws_dynamodb_table.autoscaled module.dynamodb_table.aws_dynamodb_table.autoscaled_ignore_gsi
```

## Module wrappers

Users of this Terraform module can create multiple similar resources by using [`for_each` meta-argument within `module` block](https://www.terraform.io/language/meta-arguments/for_each) which became available in Terraform 0.13.

Users of Terragrunt can achieve similar results by using modules provided in the [wrappers](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/wrappers) directory, if they prefer to reduce amount of configuration files.

## Examples

- [Basic example](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/basic)
- [Autoscaling example](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/autoscaling)
- [Global tables example](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/global-tables)
- [S3 import examples](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/s3-import)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.72.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.72.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.index_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.index_write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.table_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.table_write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.index_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.index_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.table_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.table_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_table.autoscaled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.autoscaled_gsi_ignore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of nested attribute definitions. Only required for hash\_key and range\_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | `list(map(string))` | `[]` | no |
| <a name="input_autoscaling_defaults"></a> [autoscaling\_defaults](#input\_autoscaling\_defaults) | A map of default autoscaling settings | `map(string)` | <pre>{<br/>  "scale_in_cooldown": 0,<br/>  "scale_out_cooldown": 0,<br/>  "target_value": 70<br/>}</pre> | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Whether or not to enable autoscaling. See note in README about this setting | `bool` | `false` | no |
| <a name="input_autoscaling_indexes"></a> [autoscaling\_indexes](#input\_autoscaling\_indexes) | A map of index autoscaling configurations. See example in examples/autoscaling | `map(map(string))` | `{}` | no |
| <a name="input_autoscaling_read"></a> [autoscaling\_read](#input\_autoscaling\_read) | A map of read autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling | `map(string)` | `{}` | no |
| <a name="input_autoscaling_write"></a> [autoscaling\_write](#input\_autoscaling\_write) | A map of write autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling | `map(string)` | `{}` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_create_table"></a> [create\_table](#input\_create\_table) | Controls if DynamoDB table and associated resources are created | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables deletion protection for table | `bool` | `null` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc. | `any` | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_ignore_changes_global_secondary_index"></a> [ignore\_changes\_global\_secondary\_index](#input\_ignore\_changes\_global\_secondary\_index) | Whether to ignore changes lifecycle to global secondary indices, useful for provisioned tables with scaling | `bool` | `false` | no |
| <a name="input_import_table"></a> [import\_table](#input\_import\_table) | Configurations for importing s3 data into a new table. | `any` | `{}` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table | `string` | `null` | no |
| <a name="input_on_demand_throughput"></a> [on\_demand\_throughput](#input\_on\_demand\_throughput) | Sets the maximum number of read and write units for the specified on-demand table | `any` | `{}` | no |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Whether to enable point-in-time recovery | `bool` | `false` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | The attribute to use as the range (sort) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | The number of read units for this table. If the billing\_mode is PROVISIONED, this field should be greater than 0 | `number` | `null` | no |
| <a name="input_replica_regions"></a> [replica\_regions](#input\_replica\_regions) | Region names for creating replicas for a global DynamoDB table. | `any` | `[]` | no |
| <a name="input_resource_policy"></a> [resource\_policy](#input\_resource\_policy) | The JSON definition of the resource-based policy. | `string` | `null` | no |
| <a name="input_restore_date_time"></a> [restore\_date\_time](#input\_restore\_date\_time) | Time of the point-in-time recovery point to restore. | `string` | `null` | no |
| <a name="input_restore_source_name"></a> [restore\_source\_name](#input\_restore\_source\_name) | Name of the table to restore. Must match the name of an existing table. | `string` | `null` | no |
| <a name="input_restore_source_table_arn"></a> [restore\_source\_table\_arn](#input\_restore\_source\_table\_arn) | ARN of the source table to restore. Must be supplied for cross-region restores. | `string` | `null` | no |
| <a name="input_restore_to_latest_time"></a> [restore\_to\_latest\_time](#input\_restore\_to\_latest\_time) | If set, restores table to the most recent point-in-time recovery point. | `bool` | `null` | no |
| <a name="input_server_side_encryption_enabled"></a> [server\_side\_encryption\_enabled](#input\_server\_side\_encryption\_enabled) | Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK) | `bool` | `false` | no |
| <a name="input_server_side_encryption_kms_key_arn"></a> [server\_side\_encryption\_kms\_key\_arn](#input\_server\_side\_encryption\_kms\_key\_arn) | The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb. | `string` | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Indicates whether Streams are to be enabled (true) or disabled (false). | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES. | `string` | `null` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | The storage class of the table. Valid values are STANDARD and STANDARD\_INFREQUENT\_ACCESS | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Updated Terraform resource management timeouts | `map(string)` | <pre>{<br/>  "create": "10m",<br/>  "delete": "10m",<br/>  "update": "60m"<br/>}</pre> | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | The name of the table attribute to store the TTL timestamp in | `string` | `""` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Indicates whether ttl is enabled | `bool` | `false` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | The number of write units for this table. If the billing\_mode is PROVISIONED, this field should be greater than 0 | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | The ARN of the Table Stream. Only available when var.stream\_enabled is true |
| <a name="output_dynamodb_table_stream_label"></a> [dynamodb\_table\_stream\_label](#output\_dynamodb\_table\_stream\_label) | A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream\_enabled is true |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/LICENSE) for full details.
