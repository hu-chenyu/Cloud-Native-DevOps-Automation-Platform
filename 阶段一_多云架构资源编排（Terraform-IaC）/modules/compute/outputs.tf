output "instance_id" {
  value = alicloud_instance.existing_ecs.id # 单实例ID
}

output "instance_ids" {
  description = "ECS实例ID列表"
  value       = try(data.alicloud_instances.existing_ecs.instances[0].id, null) # 动态获取实例ID
}

output "ecs_instance_ids" {
  description = "ECS实例ID列表"
  value       = [var.existing_ecs_id] # 通过输入变量传递实例ID
}

output "ecs_instance_id" {
  value = alicloud_instance.existing_ecs.id # 与instance_id重复输出
}

output "existing_ecs_id" {
  description = "现有ECS实例的ID"
  value       = alicloud_instance.existing_ecs.id # 资源ID直出
}

output "imported_ecs_info" {
  value = var.existing_ecs_id # 透传输入变量
}

output "protected_ecs_ip" {
  value       = alicloud_instance.existing_ecs.public_ip # 公网IP暴露
  description = "受保护实例的公网IP"
  sensitive   = true # 隐藏敏感信息
}
