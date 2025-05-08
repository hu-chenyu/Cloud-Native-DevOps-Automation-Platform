# 核心基础设施输出（模块化输出）
output "vpc_id" {
  description = "通过 network 模块创建的 VPC ID"  # 用于后续资源绑定
  value       = module.network.vpc_id             # 跨模块调用网络层输出
}

output "vswitch_id" {
  description = "通过 network 模块创建的主子网 ID"  # 子网划分依据业务需求设计
  value       = module.network.vswitch_id           # 绑定ECS实例部署位置
}

output "security_group_id" {
  description = "通过 network 模块创建的默认安全组 ID"  # 包含SSH/HTTP基础规则
  value       = module.network.security_group_id        # 生产环境应用级安全组
}

output "ecs_instance_ids" {
  description = "compute 模块管理的所有 ECS 实例 ID 列表"  # 动态生成的实例ID集合
  value       = module.compute.ecs_instance_ids            # 敏感数据需隐藏
  sensitive   = true                                       # 防止控制台泄露实例信息
}

output "slb_public_ip" {
  description = "loadbalancer 模块创建的 SLB 公网 IP"  # 对外服务入口地址   
  value       = module.loadbalancer.slb_public_ip      # 需绑定域名使用
}

# 调试类输出
output "debug_ecs_instances" {
  description = "ECS 实例调试信息（统一对象类型）"  # 仅限开发环境使用
  value = length(module.compute.ecs_instance_ids) > 0 ? {  # 条件表达式避免空值报错
    first_instance_id = module.compute.ecs_instance_ids[0]  # 首个实例ID
    total_instances   = length(module.compute.ecs_instance_ids)  # 实例总数统计
    } : {
    message = "No instances"  # 空资源提示
  }
  sensitive = true  # 隐藏实例详情
}

output "slb_id" {
  description = "根模块暴露的SLB实例ID"  # 供监控系统调用
  value       = module.loadbalancer.slb_id  # 负载均衡器唯一标识
}
