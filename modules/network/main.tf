# Provider 配置
terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"  # 使用阿里云官方认证的 Provider
      version = "~> 1.248.0"      # 版本锁定策略
    }
  }
}

# 数据源定义
data "alicloud_vswitches" "existing_vsw" {
  name_regex = "Hangzhou-Subnet"  # 正则匹配子网名称
  vpc_id     = data.alicloud_vpcs.existing_vpc.vpcs.0.id  # 跨数据源引用 VPC ID
}

data "alicloud_security_groups" "existing_sg" {
  name_regex = "Hangzhou-Free-SG"  # 匹配现有安全组
  vpc_id     = data.alicloud_vpcs.existing_vpc.vpcs.0.id  # 限定同 VPC 下的安全组
}

data "alicloud_vswitches" "default" {
  name_regex = "Hangzhou-Free-VPC"  # 默认子网匹配规则
  vpc_id = data.alicloud_vpcs.existing_vpc.vpcs.0.id  # 确保子网属于目标 VPC
}

data "alicloud_vswitches" "existing" {
  vpc_id  = data.alicloud_vpcs.existing_vpc.vpcs.0.id  # 精确 VPC 关联
  name_regex = "Hangzhou-Free-VPC"                     # 子网命名规范
  zone_id = "cn-hangzhou-h"                            # 可用区 H 的专用子网
}

data "alicloud_vpcs" "existing_vpc" {
  name_regex = "Hangzhou-Free-VPC"    # 通过名称获取已存在的 VPC（非新建）
}

locals {
  vswitch_id = var.vswitch_id != "" ? var.vswitch_id : try(data.alicloud_vswitches.default.ids[0], "")
  # 动态选择子网逻辑：优先使用传入参数，否则取默认子网第一个ID
}

# 子网配置
resource "alicloud_vswitch" "subnet" {
  vswitch_name = "Hangzhou-Free-VPC"  # 子网显示名称
  vpc_id       = data.alicloud_vpcs.existing_vpc.vpcs[0].id  # 绑定现有 VPC
  cidr_block   = try(data.alicloud_vswitches.existing.vswitches[0].cidr_block, "10.0.1.0/24")
  # 子网 CIDR 继承逻辑：存在则复用，否则新建 10.0.1.0/24
  zone_id      = "cn-hangzhou-i"  # 可用区 I（与 existing 数据源不同区实现跨区冗余）
  lifecycle {
    ignore_changes = [vswitch_name]  # 禁止名称变更（避免误触发资源重建）
  }
}

resource "alicloud_security_group_rule" "ssh" {
  security_group_id = "sg-bp15zxt89r754hap111s"  # 安全组 ID
  ip_protocol       = "tcp"                      # 协议类型TCP
  port_range        = "22/22"                    # 开放 SSH 端口
  type              = "ingress"                  # 入站规则
  nic_type          = "intranet"                 # 内网类型
  policy            = "accept"                   # 允许策略
  cidr_ip           = "0.0.0.0/0"                # 开放全网段
  priority          = 2                          # 规则优先级
}

resource "alicloud_security_group_rule" "http" {
  security_group_id = "sg-bp15zxt89r754hap111s"  # 安全组 ID
  ip_protocol       = "tcp"                      # 协议类型TCP 
  port_range        = "80/80"                    # Web 服务标准端口
  type              = "ingress"                  # 入站规则
  nic_type          = "intranet"                 # 内网类型
  policy            = "accept"                   # 允许策略
  cidr_ip           = "0.0.0.0/0"                # 开放全网段
  priority          = 1                          # 优先级高于 SSH 规则
}
