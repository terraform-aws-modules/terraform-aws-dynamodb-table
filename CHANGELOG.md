# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v1.1.0"></a>
## [v1.1.0] - 2021-06-07

- feat: add provisions for accepting KMS key ARN for global table regions ([#38](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/38))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#35](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/35))


<a name="v1.0.0"></a>
## [v1.0.0] - 2021-04-26

- feat: Shorten outputs (removing this_) ([#34](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/34))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#32](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/32))
- chore: align ci-cd static checks to use individual minimum Terraform versions ([#31](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/31))


<a name="v0.13.0"></a>
## [v0.13.0] - 2021-03-02

- fix: Update global example to enable stream ([#30](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/30))
- chore: add ci-cd workflow for pre-commit checks ([#29](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/29))


<a name="v0.12.0"></a>
## [v0.12.0] - 2021-02-20

- chore: update documentation based on latest `terraform-docs` which includes module and resource sections ([#28](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/28))


<a name="v0.11.0"></a>
## [v0.11.0] - 2020-12-07

- fix: use proper var for aws_appautoscaling_policy ([#26](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/26))


<a name="v0.10.0"></a>
## [v0.10.0] - 2020-11-24

- fix: Updated supported Terraform versions ([#24](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/24))


<a name="v0.9.0"></a>
## [v0.9.0] - 2020-10-13

- fix: fixed variable typings in variables.tf for indices ([#21](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/21))


<a name="v0.8.0"></a>
## [v0.8.0] - 2020-09-23

- feat: Add replica configuration to create global DynamoDB tables ([#20](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/20))


<a name="v0.7.0"></a>
## [v0.7.0] - 2020-08-14

- feat: Updated version requirements for AWS provider v3 and Terraform 0.13 ([#18](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/18))


<a name="v0.6.0"></a>
## [v0.6.0] - 2020-06-19

- fix: Fixed autoscaling references (resolves [#15](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/15)) ([#16](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/16))


<a name="v0.5.0"></a>
## [v0.5.0] - 2020-04-15

- fix: Use correct write policy name for table and index autoscaling rules ([#12](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/12))
- fix: Lookup non_key_attributes in local_secondary_index.value. ([#11](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/11))


<a name="v0.4.0"></a>
## [v0.4.0] - 2020-04-02

- feat: Adding autoscaling ([#10](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/10))


<a name="v0.3.0"></a>
## [v0.3.0] - 2020-03-21



<a name="v0.2.0"></a>
## v0.2.0 - 2020-03-21

- feat: Added DynamoDB table resource
- first commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.1.0...HEAD
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.13.0...v1.0.0
[v0.13.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.12.0...v0.13.0
[v0.12.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.11.0...v0.12.0
[v0.11.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.10.0...v0.11.0
[v0.10.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.9.0...v0.10.0
[v0.9.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.8.0...v0.9.0
[v0.8.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v0.2.0...v0.3.0
