variable "schedule_scaling_indexes" {
  description = "A map of index schedule scaling configurations"
  type = list(object({
    schedule     = string
    min_capacity = number
    max_capacity = number
  }))
}

variable "service_namespace" {
  type        = string
  description = "Namespace of the AWS service"
}

variable "resource_id" {
  type        = string
  description = "Identifier of the resource associated with the scheduled action"
}

variable "scalable_dimension" {
  type        = string
  description = "Scalable dimension"
}

variable "name" {
  description = "Name of the autoscaling action"
  type        = string
}
