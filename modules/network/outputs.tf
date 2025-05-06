output "vpc_id" {
  description = "VPC ID"
  value       = alicloud_vpc.main.id
}

output "vswitch_id" {
  description = "主 VSwitch 资源 ID"
  value       = alicloud_vswitch.subnet.id
}

output "security_group_id" {
  description = "默认安全组 ID"
  value       = alicloud_security_group.default.id
}
