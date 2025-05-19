# 云原生DevOps自动化平台

## 🚀 第二阶段核心成果（Ansible Role开发）

### 🛠️ 技术特性
| 组件     | 功能实现                                     | 技术指标                           |
|----------|----------------------------------------------|------------------------------------|
|**Docker**| 密钥管理/镜像加速/日志轮转/健康检查          | 23项任务全绿（0失败）              |
| **Nginx**| 动态配置/服务自启/SSL集成/智能自愈           | 8项任务全绿（0失败）               |

### 📊 执行验证
```bash
# Docker部署验证（耗时: 2m18s）
$ ansible-playbook playbooks/deploy_docker.yml
PLAY RECAP
47.98.112.245 : ok=23 changed=0 ...

# Nginx部署验证（耗时: 47s）  
$ ansible-playbook playbooks/deploy_nginx.yml
PLAY RECAP
47.98.112.245 : ok=8 changed=0 ...
```

### 📂 项目结构
```bash
├── ansible.cfg                   # Ansible主配置文件
├── ansible_debug.log             # 调试日志
├── container_app/                # 示例容器应用代码
│   ├── app.py                    # 应用入口
│   └── src/
│       └── main.py               # 核心业务逻辑
├── Dockerfile                    # 应用容器化构建文件
├── inventory/                    # 主机清单配置
│   └── manual_ecs.ini            # ECS主机清单模板
├── nginx_conf/                   # Nginx静态配置备份
│   ├── app.conf                  # 应用模板配置
│   └── huchenyu.conf             # 定制化配置示例
├── playbooks/                    # 部署剧本中心
│   ├── deploy_docker.yml         # Docker集群部署剧本
│   ├── deploy_nginx.yml          # Nginx服务部署剧本
│   └── files/                    # 共享脚本文件
│       └── health_check.sh       # OpenResty健康检查脚本
├── README.md                     # 项目文档
└── roles/                        # Ansible角色规范
    ├── docker/                   # 容器管控角色
    │   ├── files/                # 静态文件存储
    │   ├── handlers/             # 服务控制处理器
    │   │   └── main.yml          # 定义Docker重载/重启动作
    │   ├── tasks/                # 模块化任务分解
    │   │   └── main.yml          # 主部署流程
    │   └── templates/            # 配置模板
    │       └── docker-daemon.json.j2  # daemon.json模板文件
    └── nginx/                    # Web服务角色
        ├── defaults/             # 默认变量
        │   └── main.yml          # 端口/路径等默认配置
        ├── files/                # 静态资源
        │   ├── health_check.sh   # 增强版健康检查脚本
        │   ├── index.html        # 默认首页文件
        │   └── ssl/              # SSL证书管理
        │       ├── server.crt    # 测试证书
        │       └── server.key    # 测试私钥
        ├── handlers/             # 服务控制
        │   └── main.yml          # 平滑重载处理器
        ├── meta/                 # 角色元数据
        │   └── main.yml          # 声明依赖关系
        ├── tasks/                # 部署任务链
        │   └── main.yml          # 安装→配置→部署流程
        ├── templates/            # 动态配置模板
        │   └── nginx.conf.j2     # 模板化配置
        └── vars/                 # 专有变量
            └── main.yml          # 生产环境专用变量
