# 云原生DevOps自动化平台

## 🚀 第四阶段核心成果（Prometheus + Grafana监控集成）

### 🛠️ 技术特性
| 模块           | 功能实现                                    | 技术指标                           |
|----------------|---------------------------------------------|------------------------------------|
|**监控采集**    | 容器级指标实时采集/多服务统一纳管           | 3类核心服务监控覆盖率100%          |
|**告警引擎**    | 5xx错误率动态阈值告警/延迟P95智能检测       | 告警触发延迟<15s                   |
|**通知系统**    | 邮件告警通道（163邮箱）                     | 告警响应率100%                     |

### 📊 执行验证
```bash
[监控体系] {
|-- 阶段1: 指标采集      ✅ Prometheus三大监控目标全UP（cAdvisor/Prometheus/Flask-App）
|-- 阶段2: 规则计算      ✅ 5xx错误率阈值触发（5%持续5分钟）
|-- 阶段3: 告警路由      ✅ 163邮箱通道响应（邮件送达率100%）
|-- 阶段4: 状态同步      ✅ Grafana大屏实时告警热区
[监控体系] }
FIRING: HighHttp5xxErrorRate告警已生效

# 关键指标验证数据
HTTP状态分布（模拟场景）：
├── 500: 47% (强制触发错误)
├── 404: 47% (无效请求探测)
└── 200: 5%

容器资源负载：
├── CPU峰值: 3.25%（容器级精细监控）
├── 内存峰值: 877MiB（cAdvisor实时采集）
└── 最大网络吞吐率：3 MB/s
```
### 📂 项目结构
```bash
├── prometheus/
│   ├── prometheus.yml    # 监控主配置（含抓取规则）
│   └── rules/            
│       └── service-alerts.yml  # 告警策略（阈值5%/持续5分钟）
├── alertmanager/
│   └── alertmanager.yml  # 163邮箱告警通道（SMTP+SSL加密）
└── grafana/
    └── dashboards/       # 三屏联动看板（资源/HTTP/告警状态）
