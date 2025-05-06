terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.248.0"
     }
  }
}

resource "alicloud_instance" "existing_ecs" {
  instance_name = data.alicloud_instances.existing.instances.0.name
  vswitch_id    = data.alicloud_instances.existing.instances.0.vswitch_id
  image_id   = "ubuntu_22_04_x64_20G_alibase_20250415.vhd"
  vpc_id     = "vpc-bp1twde92j79oghiyv2lc"
  instance_type = "ecs.e-c1m1.large"
  security_groups = ["sg-bp15zxt89r754hap111s"]
  system_disk_category = "cloud_essd_entry"
  system_disk_size     = 40
  internet_max_bandwidth_out = 100
  deletion_protection = true  # 阿里云原生删除保护
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      system_disk_size,
      security_groups,      # 忽略安全组变更
      system_disk_category,  # 忽略可能导致替换的磁盘类型变更
      image_id,
      internet_max_bandwidth_out
    ]
  }
}

resource "alicloud_security_group_rule" "http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  security_group_id = "sg-bp15zxt89r754hap111s"
  cidr_ip           = "0.0.0.0/0"  # 允许公网访问
}

resource "alicloud_security_group_rule" "https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 2
  security_group_id = "sg-bp15zxt89r754hap111s"
  cidr_ip           = "0.0.0.0/0"
}

locals {
  vpc_id = try(
    data.alicloud_vpcs.existing_vpc.vpcs[0].id,
    var.vpc_id_fallback  # 查询失败时使用输入变量
  )
}

# 引用现有VPC
data "alicloud_vpcs" "existing_vpc" {
  name_regex = "^Hangzhou-Free-VPC$"
  status     = "Available"
}

# 引用现有交换机（子网）
data "alicloud_vswitches" "existing_vsw" {
  vpc_id = data.alicloud_vpcs.existing_vpc.vpcs.0.id
}

# 引用现有安全组
data "alicloud_security_groups" "existing_sg" {
  name_regex = "^Hangzhou-Free-SG$"
  vpc_id     = local.vpc_id
}

data "alicloud_instances" "hz_existing_ecs" {
  ids        = [var.existing_ecs_id]
  status     = "Running"
  vpc_id     = var.vpc_id
}

data "alicloud_instances" "existing" {
  ids = ["i-bp16ec3rqz6jsp1erpm9"]
}

data "alicloud_instances" "existing_ecs" {
  name_regex = "iZbp16ec3rqz6jsp1erpm9Z"  # 匹配实例名的正则表达式
  status     = "Running"                     # 筛选运行中的实例
  vswitch_id = "vsw-bp1bl4frgzh72m6aoic2e"   # 指定VSwitch
}
