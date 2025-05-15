#!/bin/bash

# TCP检查（端口8080）
nc -zv 127.0.0.1 8080 > /dev/null 2>&1 || exit 1

# HTTP检查（/health端点）
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/health)
[ "$HTTP_CODE" -eq 200 ] || exit 1
