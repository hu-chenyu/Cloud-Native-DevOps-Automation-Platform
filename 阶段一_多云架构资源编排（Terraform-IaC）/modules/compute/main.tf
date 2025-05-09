# 计算模块主配置
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud" # 阿里云官方Provider
      version = "~> 1.248.0"      # 锁定版本避免兼容性问题
    }
  }
}

# 现有ECS实例管理（复用已有资源）
resource "alicloud_instance" "existing_ecs" {
  instance_name              = "iZbp16ec3rqz6jsp1erpm9Z"                   # 实例名称
  vswitch_id                 = "vsw-bp1bl4frgzh72m6aoic2e"                 # 绑定指定子网
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20250415.vhd" # 官方Ubuntu镜像
  vpc_id                     = data.alicloud_vpcs.existing_vpc.vpcs.0.id   # 从数据源获取VPC ID
  instance_type              = "ecs.e-c1m1.large"                          # 2vCPU/2GB配置
  security_groups            = ["sg-bp15zxt89r754hap111s"]                 # 安全组ID
  system_disk_category       = "cloud_essd_entry"                          # ESSD云盘
  system_disk_size           = 40                                          # 系统盘容量（GB）
  internet_max_bandwidth_out = 100                                         # 公网出带宽100Mbps
  dry_run                    = false                                       # 关闭试运行模式
  timeouts {
    create = "20m" # 创建超时设置
    update = "15m" # 更新操作超时
  }
  deletion_protection = true # 开启防误删保护
  lifecycle {
    prevent_destroy = true # 阻止terraform destroy操作
    ignore_changes = [     # 忽略可能导致资源重建的变更
      dry_run,
      timeouts,
      system_disk_size,
      security_groups,
      system_disk_category,
      image_id,
      instance_type,
      tags,
      internet_max_bandwidth_out
    ]
  }
}

# 本地变量定义（VPC ID动态获取）
locals {
  vpc_id = try(
    data.alicloud_vpcs.existing_vpc.vpcs[0].id, # 优先使用数据源查询结果
    var.vpc_id_fallback                         # 查询失败时使用输入变量
  )
}

# 现有VPC数据源查询
data "alicloud_vpcs" "existing_vpc" {
  name_regex = var.vpc_name # 通过变量动态获取VPC名称
  status     = "Available"  # 只查询可用状态的VPC
}

# 子网数据源查询
data "alicloud_vswitches" "existing_vsw" {
  vpc_id = data.alicloud_vpcs.existing_vpc.vpcs.0.id # 限定同VPC下的子网
}

# 安全组数据源查询
data "alicloud_security_groups" "existing_sg" {
  name_regex = "^Hangzhou-Free-SG$" # 正则精确匹配安全组名称
  vpc_id     = local.vpc_id         # 基于动态获取的VPC ID
}

# 杭州区域现有ECS查询
data "alicloud_instances" "hz_existing_ecs" {
  ids    = [var.existing_ecs_id] # 通过变量传入实例ID
  status = "Running"             # 只查询运行中实例
  vpc_id = var.vpc_id            # 限定同VPC环境
}

# 通用实例查询
data "alicloud_instances" "existing" {
  ids = ["i-bp16ec3rqz6jsp1erpm9"] # 实例ID
}

data "alicloud_instances" "existing_ecs" {
  name_regex = "iZbp16ec3rqz6jsp1erpm9Z"   # 正则匹配实例名称  
  status     = "Running"                   # 筛选运行中的实例
  vswitch_id = "vsw-bp1bl4frgzh72m6aoic2e" # 绑定特定子网
}
