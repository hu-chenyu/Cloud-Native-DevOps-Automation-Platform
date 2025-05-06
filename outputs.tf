# 核心基础设施输出（模块化输出）
output "vpc_id" {
  description = "通过 network 模块创建的 VPC ID"
  value       = module.network.vpc_id
}

output "vswitch_id" {
  description = "通过 network 模块创建的主子网 ID"
  value       = module.network.vswitch_id
}

output "security_group_id" {
  description = "通过 network 模块创建的默认安全组 ID"
  value       = module.network.security_group_id
}

output "ecs_instance_ids" {
  description = "compute 模块管理的所有 ECS 实例 ID 列表[6]"
  value       = module.compute.ecs_instance_ids
  sensitive   = true
}

output "slb_public_ip" {
  description = "loadbalancer 模块创建的 SLB 公网 IP"
  value       = module.loadbalancer.slb_public_ip
}

# 调试类输出
output "debug_ecs_instances" {
  description = "ECS 实例调试信息（统一对象类型）"
  value = length(module.compute.ecs_instance_ids) > 0 ? {
    first_instance_id = module.compute.ecs_instance_ids[0]
    total_instances   = length(module.compute.ecs_instance_ids)
  } : {
    message           = "No instances"
  }
  sensitive   = true
}

output "slb_id" {
  description = "根模块暴露的SLB实例ID"
  value       = module.loadbalancer.slb_id
}
