# 负载均衡模块输入变量
variable "ecs_ids" {
  description = "关联的ECS实例ID列表（必须与现有SLB同VPC）"
  type        = list(string) # 多实例ID集合（实现横向扩展）
  validation {
    condition     = length(var.ecs_ids) > 0 # 防御性校验（禁止空列表）
    error_message = "至少需要传入一个ECS实例ID"       # 与SLB健康检查机制联动
  }
}

variable "ecs_id" {
  type        = string # 单实例ID参数
  description = "从根模块传入的ECS实例ID"
}

# 阿里云认证参数
variable "alicloud_access_key" {
  type        = string
  description = "阿里云AccessKey ID"
}

variable "alicloud_secret_key" {
  type        = string
  sensitive   = true # 控制台输出自动隐藏
  description = "阿里云AccessKey Secret"
}

variable "ecs_instance_id" {
  description = "The ID of the ECS instance"
  type        = string
}
