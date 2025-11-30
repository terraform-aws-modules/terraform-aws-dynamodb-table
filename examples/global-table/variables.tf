variable "initial_apply_complete" {
  description = "Set to true after the initial apply to create replicas with autoscaling enabled - https://github.com/hashicorp/terraform-provider-aws/issues/13097"
  type        = bool
  default     = false
}
