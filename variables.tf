# 实例付费类型变量（强制按量付费）
variable "instance_charge_type" {
  description = "必须使用按量付费"  # 业务规范描述
  type        = string              # 字符串类型约束
  default     = "PostPaid"          # 默认值（测试环境专用）
  validation {                      # 输入验证规则
    condition     = var.instance_charge_type == "PostPaid"  # 只允许按量付费
    error_message = "测试环境禁止使用包年包月！"            # 违反规则时的错误提示
  }
}

# 地域配置变量
variable "region" {
  default = "cn-hangzhou"   # 默认杭州地域
}

# 阿里云AccessKey配置
variable "alicloud_access_key" {
  type        = string  # 字符串类型
  sensitive   = true    # 敏感数据标记（控制台输出隐藏）
  description = "阿里云 AccessKey ID"  # 参数用途说明
}

# 阿里云SecretKey配置
variable "alicloud_secret_key" {
  type        = string  # 字符串类型
  sensitive   = true    # 敏感数据标记
  description = "阿里云 AccessKey Secret"  # 密钥用途说明
}
