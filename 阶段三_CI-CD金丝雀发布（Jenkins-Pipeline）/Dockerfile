FROM python:3.10-slim

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl libgcc-10-dev \
    && rm -rf /var/lib/apt/lists/*

# 配置全局 pip 镜像源
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip config set global.trusted-host mirrors.aliyun.com \
    && pip config set global.timeout 120

# 创建工作目录并复制应用代码
WORKDIR /app
COPY container_app/app.py .

# 安装 Flask（带重试和缓存优化）
RUN pip install flask \
    --no-cache-dir \
    --retries 5 \
    --default-timeout=180

# 创建非 root 用户（安全加固）
RUN useradd -u 1000 -m appuser && chown -R appuser /app
USER appuser

# 暴露端口并启动应用
EXPOSE 5000
CMD ["python", "app.py"]
