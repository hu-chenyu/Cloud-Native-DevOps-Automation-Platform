# 全局配置：定义Terraform版本和Provider依赖
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"  # 使用阿里云官方Provider
      version = "~> 1.248.0"       # 版本锁定避免兼容性问题
    }
  }
}

# 阿里云服务认证配置
provider "alicloud" {
  region     = "cn-hangzhou"  # 资源部署地域
  access_key = var.alicloud_access_key  # 通过变量注入AccessKey
  secret_key = var.alicloud_secret_key  # 通过变量注入SecretKey
}

# 网络模块：创建VPC/安全组/子网
module "network" {
  source              = "./modules/network"  # 模块存储路径
  alicloud_access_key = var.alicloud_access_key  # 密钥传递
  alicloud_secret_key = var.alicloud_secret_key  # 密钥传递
  providers = {
    alicloud = alicloud.main  # 显式传递认证上下文给子模块
  }
  vpc_name = "Hangzhou-Free-VPC"  # VPC显示名称
}

# 计算模块：管理ECS实例
module "compute" {
  source              = "./modules/compute"  # 模块存储路径
  region    = "cn-hangzhou"  # 必须与provider区域一致
  image_id  = "new_image"    # 自定义镜像ID
  alicloud_access_key = var.alicloud_access_key # 密钥传递
  alicloud_secret_key = var.alicloud_secret_key # 密钥传递
  providers = {
    alicloud = alicloud.main  # 显式传递认证上下文给子模块
  }

  # 安全组与网络绑定
  security_group_id = "sg-bp15zxt89r754hap111s"  # 允许SSH/HTTP入站规则
  vswitch_id        = "vsw-bp1bl4frgzh72m6aoic2e"  # 子网划分（/24网段）
  
  # 跨模块引用
  vpc_id   = module.network.vpc_id   # 继承网络模块创建的VPC ID
  vpc_name = module.network.vpc_name  # VPC名称传递（用于资源tag标记） 

  # 实例配置
  ecs_instance_id   = "i-bp16ec3rqz6jsp1erpm9"  # 实例ID
  existing_ecs_id   = "i-bp16ec3rqz6jsp1erpm9"  # 实例ID
}

# 调用流量模块
module "loadbalancer" {
  source              = "./modules/loadbalancer"  # 模块存储路径
  # 实例绑定配置
  ecs_id      = module.compute.existing_ecs_id    # 复用已有ECS
  ecs_ids     = [module.compute.instance_id]      # 新实例ID集合
  ecs_id_list = [module.compute.ecs_instance_id]  # 新实例ID集合
  ecs_instance_id   = "i-bp16ec3rqz6jsp1erpm9"    # 实例ID
  alicloud_access_key = var.alicloud_access_key   # 密钥传递
  alicloud_secret_key = var.alicloud_secret_key   # 密钥传递
  providers = {
    alicloud = alicloud.main  # 统一认证上下文
  }
  depends_on  = [module.compute]  # 确保计算资源就绪后创建SLB
}
