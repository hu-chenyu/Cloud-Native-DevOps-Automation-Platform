#!/bin/bash

# 检查cAdvisor监控端口（8081）
if nc -z localhost 8081; then
  echo "cAdvisor健康检查通过"
  exit 0
else
  echo "cAdvisor服务异常"
  exit 1
fi

# 检查Nginx的TCP端口是否存活
check_tcp() {
    nc -zv 47.98.112.245 80 &> /dev/null
    return $?
}

# 检查HTTP服务是否正常
check_http() {
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" http://47.98.112.245)
    [[ "$status_code" == 200 ]]
    return $?
}

# 主逻辑
if check_tcp && check_http; then
    echo "OK: Service is healthy."
    exit 0
else
    echo "CRITICAL: Service is down!"
    exit 1
fi
