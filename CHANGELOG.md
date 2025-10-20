# Changelog

All notable changes to this project will be documented in this file.

## [5.1.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v5.0.0...v5.1.0) (2025-08-26)


### Features

* Add support for deletion protection functionality to table repl… ([#105](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/105)) ([b45a0b6](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/b45a0b6ad0ec561a493c357bd30d95bb85768f1c))

## [5.0.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.4.0...v5.0.0) (2025-07-15)


### ⚠ BREAKING CHANGES

* Support `replica.consistency_mode`, AWS Provider MSV 6.3, Terraform MSV 1.5.7 (#103)

### Features

* Support `replica.consistency_mode`, AWS Provider MSV 6.3, Terraform MSV 1.5.7 ([#103](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/103)) ([495d7a5](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/495d7a5e6ee9a45ae985a4160d9242c8b8727d69))

## [4.4.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.3.0...v4.4.0) (2025-05-17)


### Features

* PITR Recovery Period in Days ([#99](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/99)) ([ee48ced](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/ee48ced57afbac9c7a50ecf30df81a09fadd12a9))

## [4.3.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.2.0...v4.3.0) (2025-03-19)


### Features

* Support `aws_dynamodb_resource_policy` (closes [#95](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/95)) ([#96](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/96)) ([eee22aa](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/eee22aaa46d5975dde066c396cc848eb3b79d291))

## [4.1.1](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.1.0...v4.1.1) (2024-10-11)


### Bug Fixes

* Update CI workflow versions to latest ([#88](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/88)) ([f63d068](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/f63d0685419e2f973278e434f409c5440ed0e2a9))

## [4.1.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.0.1...v4.1.0) (2024-08-25)


### Features

* Add support for table restores ([#87](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/87)) ([998e0a7](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/998e0a7d8f576ba8f0c9301f75e484912242b9b6))

## [4.0.1](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v4.0.0...v4.0.1) (2024-03-07)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#84](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/84)) ([243808a](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/243808a5ec4f5e8e431f0d8f6dc43c3b688d5bb9))

## [4.0.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.3.0...v4.0.0) (2023-10-27)


### ⚠ BREAKING CHANGES

* Added import table feature and AWS provider v5 upgrade (#77)

### Features

* Added import table feature and AWS provider v5 upgrade ([#77](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/77)) ([d596c25](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/d596c253d91c7b44b35f62c520f724d86a2bef23))

## [3.3.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.2.0...v3.3.0) (2023-05-25)


### Features

* Added option to ignore changes to GSIs ([#72](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/72)) ([44187e9](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/44187e9d56b6662eb6aef757d3322c92edc27d4b))

## [3.2.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.1.2...v3.2.0) (2023-03-21)


### Features

* Add `deletion_protection_enabled` ([#70](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/70)) ([bce94be](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/bce94bea8da8facd0a709263414a3f8f7888b5d4))

### [3.1.2](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.1.1...v3.1.2) (2022-11-14)


### Bug Fixes

* Update CI configuration files to use latest version ([#66](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/66)) ([463c164](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/463c1640cd3d580254c4f52b2873144f0a5322cd))

### [3.1.1](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.1.0...v3.1.1) (2022-09-02)


### Bug Fixes

* Added variable table_class in autoscaled ([#64](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/64)) ([0b81ce3](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/0b81ce3d6354547be7e257807e449cbb75d73506))

## [3.1.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v3.0.0...v3.1.0) (2022-08-30)


### Features

* Support configuring point_in_time_recovery on replicas ([#62](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/62)) ([53fc0a0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/53fc0a0f62602f53b51435481d6389df32e36902))

## [3.0.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v2.0.0...v3.0.0) (2022-07-26)


### ⚠ BREAKING CHANGES

* Added support for propagate_tags feature (#59)

### Features

* Added support for propagate_tags feature ([#59](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/59)) ([c750eda](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/c750eda6246076e3d49343cba100c4f2d5768e1f))

## [2.0.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.3.0...v2.0.0) (2022-06-07)


### ⚠ BREAKING CHANGES

* Added module wrappers. Bump TF version to 1.0. (#55)

### Features

* Added module wrappers. Bump TF version to 1.0. ([#55](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/55)) ([2b464ad](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/2b464ad0f32bd2767f6b18487e01f9e860a50a2d))

## [1.3.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.2.2...v1.3.0) (2022-06-07)


### Features

* Added support for table class ([#54](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/54)) ([c0b6ca2](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/c0b6ca22a8871062c989a9cdd4d45dabb81b57a8))

### [1.3.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.2.2...v1.3.0) (2022-06-05)


### Features

* Support table class feature ([#48](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/52)) ([f3f11eb](https://github.com/HarriLLC/terraform-aws-dynamodb-table/commit/f3f11eb68a178978178b44d8ec40fc1d7e8d80ad))

### [1.2.2](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.2.1...v1.2.2) (2022-01-24)


### Bug Fixes

* Fixed dynamodb_table_stream_label output ([#47](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/47)) ([ba08762](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/ba08762b098f64af561d2f0a63b2cb166c9138bc))

### [1.2.1](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.2.0...v1.2.1) (2022-01-24)


### Bug Fixes

* Fixed dynamodb_table_stream_arn output ([#46](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/46)) ([e3f534c](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/e3f534c6e80a542c1e6282cd79129e291f9bc83f))

## [1.2.0](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.1.1...v1.2.0) (2022-01-14)


### Features

* Added autoscaled table resource (may cause unexpected changes) ([#43](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/43)) ([c4a8306](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/c4a8306643ad30f67b63b3db37fcf7c8dd5b168a))
* Added variable `autoscaling_enabled` to control autoscaling ([#44](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/44)) ([9ae52b6](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/9ae52b61430e46fc77fbe619bb7eecbd3754315a))

### [1.1.1](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/compare/v1.1.0...v1.1.1) (2022-01-10)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#41](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/issues/41)) ([09d7a28](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/commit/09d7a2893f0c94c97cc7b03387802acfdeaea7bf))

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
