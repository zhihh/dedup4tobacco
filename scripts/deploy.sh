#!/bin/bash

echo "🚀 部署文档去重系统..."

# 构建Docker镜像
echo "🐳 构建Docker镜像..."
docker build -t document-deduplication-system .

# 运行容器
echo "▶️ 启动容器..."
docker-compose up -d

# 检查服务状态
echo "🔍 检查服务状态..."
sleep 10
docker-compose ps

echo "✅ 部署完成！"
echo "API地址: http://localhost:8000"
echo "API文档: http://localhost:8000/docs"
