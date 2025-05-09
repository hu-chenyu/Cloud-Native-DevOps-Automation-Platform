# SLB模块主配置
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud" # 阿里云官方认证Provider
      version = "~> 1.248.0"      # 版本锁定策略
    }
  }
}

variable "ecs_id_list" {
  type = list(string) # 需挂载的ECS实例ID列表（通过网络模块动态获取
}

data "alicloud_instances" "attached_ecs" {
  ids = var.ecs_id_list # 通过变量传入需要挂载的ECS ID列表
}

data "alicloud_slb_server_groups" "existing" {
  load_balancer_id = alicloud_slb.existing_slb.id
  name_regex       = "default-server-group" # 正则匹配服务器组名称
}

resource "alicloud_slb" "existing_slb" {
  load_balancer_name   = "SLB"                       # 控制台显示名称
  address_type         = "internet"                  # 公网类型
  bandwidth            = 5120                        # 峰值带宽5Gbps
  vswitch_id           = "vsw-bp1bl4frgzh72m6aoic2e" # 子网ID
  load_balancer_spec   = "slb.s3.large"              # 高性能规格（支撑10万QPS）
  instance_charge_type = "PayBySpec"                 # 按规格计费
  delete_protection    = "on"                        # 开启防误删保护
  lifecycle {
    prevent_destroy = true # 阻止terraform destroy操作
    ignore_changes = [     # 忽略可能导致资源重建的变更
      load_balancer_spec,  # 忽略规格变更
      instance_charge_type # 忽略计费模式变更
    ]
  }
}

resource "alicloud_slb_listener" "tcp_80" {
  load_balancer_id       = alicloud_slb.existing_slb.id
  bandwidth              = -1                  # 不限速
  health_check_timeout   = 5                   # 健康检查超时时间5（秒）
  protocol               = "http"              # 协议类型
  frontend_port          = 80                  # 前端监听端口
  backend_port           = 80                  # 后端服务端口
  server_group_id        = "rsp-bp1tqjkw485eh" # 服务器组
  health_check           = "on"                # 启用健康检查
  health_check_uri       = "/healthcheck"      # 根路径探活
  health_check_http_code = "http_2xx"          # 仅认为HTTP 200-299状态码为健康
}

resource "alicloud_slb_server_group_server_attachment" "attach" {
  server_group_id = try(data.alicloud_slb_server_groups.existing.slb_server_groups[0].id, "rsp-bp1tqjkw485eh")
  # 动态获取服务器组ID
  server_id  = var.ecs_instance_id         # 需挂载的ECS实例ID
  port       = 80                          # 服务端口
  weight     = 100                         # 流量权重
  depends_on = [alicloud_slb.existing_slb] # 显式声明资源依赖顺序
}

