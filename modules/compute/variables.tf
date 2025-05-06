variable "instance_type" {
  description = "ECS实例规格"
  default     = "ecs.e-c1m1.large"
}

variable "image_id" {
  description = "ECS实例统镜像ID"
  type        = string
}

variable "region" {
  description = "阿里云地域"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from network module"
  type        = string
}

variable "vpc_id_fallback" {
  type    = string
  description = "当数据源查询失败时使用的VPC ID"
  default     = "vpc-bp1twde92j79oghiyv2lc"
}

variable "security_group_id" {
  type        = string
  description = "安全组 ID"

  validation {
    condition     = can(regex("^sg-", var.security_group_id))
    error_message = "安全组 ID 不能为空"
  }
}

variable "vswitch_id" {
  type        = string
  description = "交换机 ID"

  validation {
    condition     = var.vswitch_id != null && length(var.vswitch_id) > 0
    error_message = "交换机 ID 不能为空"
  }
}

variable "existing_ecs_id" {
  type        = string
  description = "Existing ECS instance ID"
  sensitive   = true
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
