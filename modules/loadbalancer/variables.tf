variable "ecs_ids" {
  description = "关联的ECS实例ID列表（必须与现有SLB同VPC）"
  type        = list(string)
  validation {
    condition     = length(var.ecs_ids) > 0
    error_message = "至少需要传入一个ECS实例ID"
  }
}

variable "ecs_id" {
  type        = string
  description = "从根模块传入的ECS实例ID"
}

variable "alicloud_access_key" {
  type        = string
  description = "阿里云AccessKey ID"
}

variable "alicloud_secret_key" {
  type        = string
  sensitive   = true
  description = "阿里云AccessKey Secret"
}
