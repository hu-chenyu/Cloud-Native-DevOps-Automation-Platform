provider "alicloud" {
  alias      = "hangzhou"
  region     = "cn-hangzhou"
  access_key = var.alicloud_access_key   
  secret_key = var.alicloud_secret_key
}

terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "~> 1.248.0"
    }
  }
}

# 调用网络模块
module "network" {
  source = "./modules/network"
  alicloud_access_key = var.alicloud_access_key
  alicloud_secret_key = var.alicloud_secret_key
  providers = {
    alicloud = alicloud.main
  }
  vpc_name          = "Hangzhou-Free-VPC"
}

# 调用计算模块
module "compute" {
  source = "./modules/compute"
  alicloud_access_key = var.alicloud_access_key
  alicloud_secret_key = var.alicloud_secret_key
    providers = {
    alicloud = alicloud.main
  }
  region = "cn-hangzhou"
  existing_ecs_id = "i-bp16ec3rqz6jsp1erpm9"
  security_group_id = "sg-bp15zxt89r754hap111s"
  vswitch_id        = "vsw-bp1bl4frgzh72m6aoic2e"
  image_id   = "new_image"
  vpc_id = module.network.vpc_id
}

# 调用流量模块
module "loadbalancer" {
  source       = "./modules/loadbalancer"
  alicloud_access_key = var.alicloud_access_key
  alicloud_secret_key = var.alicloud_secret_key
  providers = {
    alicloud = alicloud.main
  }
  ecs_id    = module.compute.instance_id
  ecs_ids      = [module.compute.instance_id]
  ecs_id_list  = [module.compute.ecs_instance_id]
  depends_on   = [module.compute]
}
