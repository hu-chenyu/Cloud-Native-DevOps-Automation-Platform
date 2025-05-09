# 负载均衡模块输出定义
output "slb_public_ip" {
  description = "SLB公网IP地址"                       # 面向互联网的服务入口
  value       = alicloud_slb.existing_slb.address # 通过公网SLB实例属性获取
}

output "slb_id" {
  description = "SLB实例ID"
  value       = alicloud_slb.existing_slb.id # 实例唯一标识符
}
