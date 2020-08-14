# AWS DynamoDB Table Terraform module

Terraform module to create a DynamoDB table.

This type of resources are supported:

* [DynamoDB table](https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html)

## Terraform versions

Terraform 0.12 or newer is supported.

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

## Examples

* [Basic example](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples/basic)

## Change log

The [change log](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/CHANGELOG.md) captures all important release notes.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.52, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.52, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | List of nested attribute definitions. Only required for hash\_key and range\_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | `list(map(string))` | `[]` | no |
| autoscaling\_defaults | A map of default autoscaling settings | `map(string)` | <pre>{<br>  "scale_in_cooldown": 0,<br>  "scale_out_cooldown": 0,<br>  "target_value": 70<br>}</pre> | no |
| autoscaling\_indexes | A map of index autoscaling configurations. See example in examples/autoscaling | `map(map(string))` | `{}` | no |
| autoscaling\_read | A map of read autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling | `map(string)` | `{}` | no |
| autoscaling\_write | A map of write autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling | `map(string)` | `{}` | no |
| billing\_mode | Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| create\_table | Controls if DynamoDB table and associated resources are created | `bool` | `true` | no |
| global\_secondary\_indexes | Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc. | `list(any)` | `[]` | no |
| hash\_key | The attribute to use as the hash (partition) key. Must also be defined as an attribute | `string` | `null` | no |
| local\_secondary\_indexes | Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource. | `list(any)` | `[]` | no |
| name | Name of the DynamoDB table | `string` | `null` | no |
| point\_in\_time\_recovery\_enabled | Whether to enable point-in-time recovery | `bool` | `false` | no |
| range\_key | The attribute to use as the range (sort) key. Must also be defined as an attribute | `string` | `null` | no |
| read\_capacity | The number of read units for this table. If the billing\_mode is PROVISIONED, this field should be greater than 0 | `number` | `null` | no |
| server\_side\_encryption\_enabled | Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK) | `bool` | `false` | no |
| server\_side\_encryption\_kms\_key\_arn | The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb. | `string` | `null` | no |
| stream\_enabled | Indicates whether Streams are to be enabled (true) or disabled (false). | `bool` | `false` | no |
| stream\_view\_type | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES. | `string` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| timeouts | Updated Terraform resource management timeouts | `map(string)` | <pre>{<br>  "create": "10m",<br>  "delete": "10m",<br>  "update": "60m"<br>}</pre> | no |
| ttl\_attribute\_name | The name of the table attribute to store the TTL timestamp in | `string` | `""` | no |
| ttl\_enabled | Indicates whether ttl is enabled | `bool` | `false` | no |
| write\_capacity | The number of write units for this table. If the billing\_mode is PROVISIONED, this field should be greater than 0 | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_dynamodb\_table\_arn | ARN of the DynamoDB table |
| this\_dynamodb\_table\_id | ID of the DynamoDB table |
| this\_dynamodb\_table\_stream\_arn | The ARN of the Table Stream. Only available when var.stream\_enabled is true |
| this\_dynamodb\_table\_stream\_label | A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream\_enabled is true |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module written by [Max Williams](https://github.com/max-rocket-internet) and managed by [Anton Babenko](https://github.com/antonbabenko).

## License

Apache 2 Licensed. See LICENSE for full details.
