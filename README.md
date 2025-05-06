# 阿里云生产环境基础设施自动化部署

通过 Terraform 实现阿里云核心资源（VPC/ECS/SLB）的模块化编排，支持一键式部署与销毁。

```bash
├── modules/            # 子模块目录
│   ├── network/       # 网络层资源（VPC/子网/安全组）
│   ├── compute/       # 计算层资源（ECS实例管理）
│   └── loadbalancer/  # 流量层资源（SLB负载均衡器）
├── main.tf             # 主入口文件
├── outputs.tf          # 基础设施输出定义
├── variables.tf        # 输入变量声明
├── providers.tf        # 云服务商配置
└── README.md           # 当前文档
