variable "vpc_cidr" {
  description = "VPC网段"
  type        = string
  default     = "10.0.0.0/16"
}

variable "zone_id" {
  description = "可用区ID"
  type        = string
  default     = "cn-hangzhou-h"
}

variable "env" {
  description = "环境标识"
  type        = string
  default     = "prod"
}

variable "vpc_name" {
  description = "VPC名称"
  type        = string
  default     = ""
}

variable "vswitch_id" {
  type = string
  default = ""
}

variable "security_group_id" {
  type = string
  default = ""
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
