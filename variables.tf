variable "instance_charge_type" {
  description = "必须使用按量付费"
  type        = string
  default     = "PostPaid"
  validation {
    condition     = var.instance_charge_type == "PostPaid"
    error_message = "测试环境禁止使用包年包月！"
  }
}

variable "region" {
  default = "cn-hangzhou"  # 统一使用杭州地域
}

variable "alicloud_access_key" {
  type      = string
  sensitive   = true
  description = "阿里云 AccessKey ID"
}

variable "alicloud_secret_key" {
  type      = string
  sensitive = true
  description = "阿里云 AccessKey Secret"
}
