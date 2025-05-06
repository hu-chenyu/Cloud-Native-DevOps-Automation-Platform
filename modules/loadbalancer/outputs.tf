output "slb_public_ip" {
  description = "SLB公网IP地址"
  value       = alicloud_slb.existing_slb.address
}

output "slb_id" {
  description = "SLB实例ID"
  value       = alicloud_slb.existing_slb.id
}
