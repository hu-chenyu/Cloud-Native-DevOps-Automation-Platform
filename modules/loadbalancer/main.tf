terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.248.0"
    }
  }
}

variable "ecs_id_list" {
  type = list(string)
}

resource "alicloud_slb" "existing_slb" {
  load_balancer_name = "SLB"
  address_type       = "internet"
  bandwidth          = 5120
  vswitch_id         = "vsw-bp1bl4frgzh72m6aoic2e"
  load_balancer_spec = "slb.s3.large"
  instance_charge_type = "PayBySpec"
  delete_protection    = "on"
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      load_balancer_spec,  # 忽略规格变更
      instance_charge_type # 忽略计费模式变更
    ]
  }
}

resource "alicloud_slb_listener" "tcp_80" {
  load_balancer_id = alicloud_slb.existing_slb.id
  bandwidth        = -1
  health_check_timeout = 5
  protocol         = "http"
  frontend_port    = 80
  backend_port     = 80
  server_group_id  = "rsp-bp1tqjkw485eh"
  health_check     = "on"               # 启用健康检查
  health_check_uri = "/healthcheck"     # 根路径探活
  health_check_http_code = "http_2xx"
}

resource "alicloud_slb_server_group_server_attachment" "attach" {
  server_group_id = "rsp-bp1tqjkw485eh"
  server_id       = "i-bp16ec3rqz6jsp1erpm9"
  port            = 80
  weight          = 100
}

