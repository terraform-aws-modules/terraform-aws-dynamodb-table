# Upgrade from v5.x to v6.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/master/examples) directory:
If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

-

## Additional changes

### Added

- Resource policies for both table and streams, including propagation of policies to the respective replicas (again, table and streams)

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type
- `deletion_protection_enabled` now defaults to `true` if not specified
- The `dynamodb_table_` prefix has been removed from all output names for consistency

### Variable and output changes

1. Removed variables:

    -

2. Renamed variables:

    - `create_table` -> `create`

3. Added variables:

    -

4. Removed outputs:

    - None

5. Renamed outputs:

    - `dynamodb_table_arn` -> `arn`
    - `dynamodb_table_id` -> `id`
    - `dynamodb_table_stream_arn` -> `stream_arn`
    - `dynamodb_table_stream_label` -> `stream_label`

6. Added outputs:

    - `replicas`

## Upgrade Migrations

### Before 5.x Example

```hcl
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 5.0"

  # Truncated for brevity ...

}
```

### After 6.x Example

```hcl
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 6.0"

  # Truncated for brevity ...

}
```

### State Changes

TBD
