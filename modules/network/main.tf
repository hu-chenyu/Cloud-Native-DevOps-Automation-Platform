terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "~> 1.248.0"
    }
  }
}

data "alicloud_vswitches" "existing_vsw" {
  name_regex = "Hangzhou-Subnet"
  vpc_id     = alicloud_vpc.main.id  # 关联本模块创建的VPC
}

data "alicloud_security_groups" "existing_sg" {
  name_regex = "Hangzhou-Free-SG"
  vpc_id     = alicloud_vpc.main.id
}

data "alicloud_vswitches" "default" {
  name_regex = "Hangzhou-Subnet"
  vpc_id = data.alicloud_vpcs.existing_vpc.vpcs.0.id
}

locals {
  vswitch_id = var.vswitch_id != "" ? var.vswitch_id : try(data.alicloud_vswitches.default.ids[0], "")
}

# VPC核心定义
resource "alicloud_vpc" "main" {
  vpc_name   = "Hangzhou-Free-VPC"  # 固定名称以匹配查询条件
  cidr_block = "10.0.0.0/16"
}

data "alicloud_vpcs" "existing_vpc" {
  name_regex = "Hangzhou-Free-VPC"
}

# 子网配置
resource "alicloud_vswitch" "subnet" {
  vswitch_name = "${var.env}-subnet"
  vpc_id       = alicloud_vpc.main.id
  cidr_block   = cidrsubnet(var.vpc_cidr, 8, 0)
  zone_id      = var.zone_id
}

# 安全组定义
resource "alicloud_security_group" "default" {
  security_group_name = "${var.env}-sg"
  vpc_id      = alicloud_vpc.main.id
  description = "基础安全组"
}

# 安全组规则单独定义
resource "alicloud_security_group_rule" "ssh" {
  security_group_id = alicloud_security_group.default.id
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "http" {
  security_group_id = alicloud_security_group.default.id
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  cidr_ip           = "0.0.0.0/0"
}
