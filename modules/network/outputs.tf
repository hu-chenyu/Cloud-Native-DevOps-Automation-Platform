# 网络模块输出定义
output "vpc_id" {
  description = "VPC ID"  # 现网VPC的唯一标识符
  value       = data.alicloud_vpcs.existing_vpc.vpcs.0.id  # 从数据源获取首个匹配VPC的ID
}

output "vswitch_id" {
  description = "主 VSwitch 资源 ID"  # 业务主子网标识
  value       = alicloud_vswitch.subnet.id  # 新创建VSwitch的资源ID
}

output "security_group_id" {
  description = "默认安全组 ID"  # 包含基础访问规则的安全组
  value       = data.alicloud_security_groups.existing_sg.groups.0.id
}

output "vpc_name" {
  description = "VPC的名称"  # 用于资源标识和账单分类
  value       = data.alicloud_vpcs.existing_vpc.vpcs[0].vpc_name  # 从现有VPC获取名称
}
