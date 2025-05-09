variable "vpc_cidr" {
  description = "VPC网段"
  type        = string        # 字符串类型约束
  default     = "10.0.0.0/16" # 默认测试环境网段
}

variable "zone_id" {
  description = "可用区ID"
  type        = string          # 字符串类型约束
  default     = "cn-hangzhou-h" # 默认部署到杭州H区
}

variable "env" {
  description = "环境标识"
  type        = string # 字符串类型约束
  default     = "prod" # 默认生产环境
}

variable "vpc_name" {
  description = "VPC名称" # 控制台显示名称
  type        = string  # 字符串类型约束
  default     = ""      # 空值表示自动生成名称
}

variable "vswitch_id" {
  type    = string # 子网ID
  default = ""     # 空值则创建新子网
}

variable "security_group_id" {
  type    = string # 安全组ID
  default = ""     # 空值则创建新安全组
}

variable "alicloud_access_key" {
  type        = string
  description = "阿里云AccessKey ID"
}

variable "alicloud_secret_key" {
  type        = string
  sensitive   = true # 控制台输出自动隐藏
  description = "阿里云AccessKey Secret"
}
