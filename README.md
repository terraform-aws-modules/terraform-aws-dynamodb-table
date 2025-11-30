# AWS DynamoDB Table Terraform module

Terraform module to create a DynamoDB table.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

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

### Usage Notes

> [!CAUTION]
> #### Enabling or disabling autoscaling can cause your table to be recreated
>
> There are two separate Terraform resources used for the DynamoDB table: one is for when any autoscaling is enabled the other when disabled. If your table is already created and then you change the variable `autoscaling_enabled` then your table will be recreated by Terraform. In this case you will need to move the old `aws_dynamodb_table` resource that is being `destroyed` to the new resource that is being `created`. For example:
>
> ```sh
> terraform state mv module.dynamodb_table.aws_dynamodb_table.this \
>     module.dynamodb_table.aws_dynamodb_table.autoscaled
> ```

> [!CAUTION]
> #### Autoscaling with global secondary indexes
>
> When using an autoscaled provisioned table with GSIs you may find that applying TF changes whilst a GSI is scaled up will reset the capacity, there is an [open issue for this on the AWS Provider](https://github.com/hashicorp/terraform-provider-aws/issues/671). To get around this issue you can enable the `ignore_changes_global_secondary_index` setting however, using this setting means that any changes to GSIs will be ignored by Terraform and will hence have to be applied manually (or via some other automation).
>
> Note: Setting `ignore_changes_global_secondary_index` after the table is already created causes your table to be recreated. In this case, you will
> need to move the old `aws_dynamodb_table` resource that is being `destroyed` to the new resource that is being `created`. For example:
>
> ```sh
> terraform state mv module.dynamodb_table.aws_dynamodb_table.autoscaled \
>     module.dynamodb_table.aws_dynamodb_table.autoscaled_ignore_gsi
> ```

## Examples

- [Basic](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/basic)
- [Autoscaling](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/autoscaling)
- [Global table](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/global-table)
- [S3 import](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/s3-import)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.22 |

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
| [aws_dynamodb_resource_policy.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_resource_policy.replica_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_resource_policy.stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_table.autoscaled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.autoscaled_gsi_ignore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy_document.resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.stream_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Set of nested attribute definitions. Only required for `hash_key` and `range_key` attributes | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | `null` | no |
| <a name="input_autoscaling"></a> [autoscaling](#input\_autoscaling) | Configuration block for autoscaling settings | <pre>object({<br/>    enabled = optional(bool, false)<br/>    defaults = optional(object({<br/>      scale_in_cooldown  = optional(number, 0)<br/>      scale_out_cooldown = optional(number, 0)<br/>      target_value       = optional(number, 70)<br/>    }), {})<br/>    read = optional(object({<br/>      max_capacity       = number<br/>      min_capacity       = optional(number)<br/>      scale_in_cooldown  = optional(number)<br/>      scale_out_cooldown = optional(number)<br/>      target_value       = optional(number)<br/>    }))<br/>    write = optional(object({<br/>      max_capacity       = number<br/>      min_capacity       = optional(number)<br/>      scale_in_cooldown  = optional(number)<br/>      scale_out_cooldown = optional(number)<br/>      target_value       = optional(number)<br/>    }))<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables deletion protection for table | `bool` | `true` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc | <pre>map(object({<br/>    hash_key           = string<br/>    name               = optional(string) # will fall back to map key if not provided<br/>    non_key_attributes = optional(list(string))<br/>    on_demand_throughput = optional(object({<br/>      max_read_request_units  = optional(number)<br/>      max_write_request_units = optional(number)<br/>    }))<br/>    projection_type = string<br/>    range_key       = optional(string)<br/>    read_capacity   = optional(number)<br/>    warm_throughput = optional(object({<br/>      read_capacity  = optional(number)<br/>      write_capacity = optional(number)<br/>    }))<br/>    write_capacity = optional(number)<br/><br/>    # Autoscaling<br/>    autoscaling = optional(object({<br/>      enabled            = optional(bool, false)<br/>      read_max_capacity  = number<br/>      read_min_capacity  = optional(number)<br/>      write_max_capacity = number<br/>      write_min_capacity = optional(number)<br/>      scale_in_cooldown  = optional(number)<br/>      scale_out_cooldown = optional(number)<br/>      target_value       = optional(number)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_global_table_witness"></a> [global\_table\_witness](#input\_global\_table\_witness) | Witness Region in a Multi-Region Strong Consistency deployment. Note This must be used alongside a single replica with consistency\_mode set to STRONG. Other combinations will fail to provision | <pre>object({<br/>    region_name = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_ignore_changes_global_secondary_index"></a> [ignore\_changes\_global\_secondary\_index](#input\_ignore\_changes\_global\_secondary\_index) | Whether to ignore changes lifecycle to global secondary indices, useful for provisioned tables with scaling | `bool` | `false` | no |
| <a name="input_import_table"></a> [import\_table](#input\_import\_table) | Configurations for importing s3 data into a new table | <pre>object({<br/>    input_compression_type = optional(string)<br/>    input_format           = string<br/>    input_format_options = optional(object({<br/>      csv = optional(object({<br/>        delimiter   = optional(string)<br/>        header_list = optional(list(string))<br/>      }))<br/>    }))<br/>    s3_bucket_source = object({<br/>      bucket       = string<br/>      bucket_owner = optional(string)<br/>      key_prefix   = optional(string)<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource | <pre>map(object({<br/>    name               = optional(string) # will fall back to map key if not provided<br/>    non_key_attributes = optional(list(string))<br/>    projection_type    = string<br/>    range_key          = string<br/>  }))</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table | `string` | `null` | no |
| <a name="input_on_demand_throughput"></a> [on\_demand\_throughput](#input\_on\_demand\_throughput) | Sets the maximum number of read and write units for the specified on-demand table | <pre>object({<br/>    max_read_request_units  = optional(number)<br/>    max_write_request_units = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_point_in_time_recovery"></a> [point\_in\_time\_recovery](#input\_point\_in\_time\_recovery) | Enable point-in-time recovery options | <pre>object({<br/>    enabled                 = optional(bool, true)<br/>    recovery_period_in_days = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | The attribute to use as the range (sort) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | The number of read units for this table when the billing\_mode is `PROVISIONED`. Must be greater than 0 | `number` | `1` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Region names for creating replicas for a global DynamoDB table | <pre>list(object({<br/>    consistency_mode            = optional(string)<br/>    deletion_protection_enabled = optional(bool, true)<br/>    kms_key_arn                 = optional(string)<br/>    point_in_time_recovery      = optional(bool)<br/>    propagate_tags              = optional(bool, true)<br/>    region_name                 = string<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_policy_statements"></a> [resource\_policy\_statements](#input\_resource\_policy\_statements) | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for table resource policy permissions | <pre>map(object({<br/>    sid           = optional(string)<br/>    actions       = optional(list(string))<br/>    not_actions   = optional(list(string))<br/>    effect        = optional(string, "Allow")<br/>    resources     = optional(list(string))<br/>    not_resources = optional(list(string))<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    not_principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    condition = optional(list(object({<br/>      test     = string<br/>      variable = string<br/>      values   = list(string)<br/>    })))<br/>  }))</pre> | `null` | no |
| <a name="input_restore_date_time"></a> [restore\_date\_time](#input\_restore\_date\_time) | Time of the point-in-time recovery point to restore | `string` | `null` | no |
| <a name="input_restore_source_name"></a> [restore\_source\_name](#input\_restore\_source\_name) | Name of the table to restore. Must match the name of an existing table | `string` | `null` | no |
| <a name="input_restore_source_table_arn"></a> [restore\_source\_table\_arn](#input\_restore\_source\_table\_arn) | ARN of the source table to restore. Must be supplied for cross-region restores | `string` | `null` | no |
| <a name="input_restore_to_latest_time"></a> [restore\_to\_latest\_time](#input\_restore\_to\_latest\_time) | If set, restores table to the most recent point-in-time recovery point | `bool` | `null` | no |
| <a name="input_server_side_encryption"></a> [server\_side\_encryption](#input\_server\_side\_encryption) | Enable server-side encryption options | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    kms_key_arn = optional(string)<br/>  })</pre> | <pre>{<br/>  "enabled": true<br/>}</pre> | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Indicates whether Streams are to be enabled (true) or disabled (false) | `bool` | `false` | no |
| <a name="input_stream_resource_policy_statements"></a> [stream\_resource\_policy\_statements](#input\_stream\_resource\_policy\_statements) | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for stream resource policy permissions | <pre>map(object({<br/>    sid           = optional(string)<br/>    actions       = optional(list(string))<br/>    not_actions   = optional(list(string))<br/>    effect        = optional(string, "Allow")<br/>    resources     = optional(list(string))<br/>    not_resources = optional(list(string))<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    not_principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    condition = optional(list(object({<br/>      test     = string<br/>      variable = string<br/>      values   = list(string)<br/>    })))<br/>  }))</pre> | `null` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES | `string` | `null` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | The storage class of the table. Valid values are STANDARD and STANDARD\_INFREQUENT\_ACCESS | `string` | `null` | no |
| <a name="input_tag_autoscaling_target"></a> [tag\_autoscaling\_target](#input\_tag\_autoscaling\_target) | Whether to tag the autoscaling target resources. Set to `false` if targets already exist to avoid the error `ValidationException: The scalable target that you tried to tag already exists. To update tags on an existing scalable target, use the TagResource API` | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for the table | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Enable Time to Live (TTL) settings | <pre>object({<br/>    attribute_name = optional(string)<br/>    enabled        = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_warm_throughput"></a> [warm\_throughput](#input\_warm\_throughput) | Sets the number of warm read and write units for the specified table | <pre>object({<br/>    read_units_per_second  = optional(number)<br/>    write_units_per_second = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | The number of write units for this table when the billing\_mode is `PROVISIONED`. Must be greater than 0 | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the DynamoDB table |
| <a name="output_id"></a> [id](#output\_id) | ID of the DynamoDB table |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | The DynamoDB Table replica(s) created and their attributes |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | The ARN of the Table Stream. Only available when `stream_enabled = true` |
| <a name="output_stream_label"></a> [stream\_label](#output\_stream\_label) | A timestamp, in ISO 8601 format of the Table Stream. Only available when `stream_enabled = true` |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/LICENSE) for full details.
