output "instance_id" {
  value = alicloud_instance.existing_ecs.id
}

output "instance_ids" {
  description = "ECS实例ID列表"
  value = try(data.alicloud_instances.existing_ecs.instances[0].id, null)
}

output "ecs_instance_ids" {
  description = "ECS实例ID列表"
  value = [var.existing_ecs_id]
}

output "ecs_instance_id" {
  value = alicloud_instance.existing_ecs.id
}

output "existing_ecs_id" {
  value = try(
    data.alicloud_instances.hz_existing_ecs.instances[0].id,
    "未找到匹配实例，请检查查询条件或手动指定ID"
  )
}

output "imported_ecs_info" {
  value = var.existing_ecs_id  # 正确引用已声明的输入变量
}

output "protected_ecs_ip" {
  value = alicloud_instance.existing_ecs.public_ip
  description = "受保护实例的公网IP"
  sensitive   = true  # 隐藏敏感信息
}
