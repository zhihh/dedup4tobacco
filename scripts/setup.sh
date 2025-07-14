#!/bin/bash

echo "🚀 开始安装文档去重系统..."

# 检查Python版本
python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
echo "Python版本: $python_version"

# 创建虚拟环境
echo "📦 创建虚拟环境..."
python3 -m venv venv
source venv/bin/activate

# 升级pip
echo "⬆️ 升级pip..."
pip install --upgrade pip

# 安装依赖
echo "📥 安装依赖..."
pip install -r requirements.txt

# 创建数据目录
echo "📁 创建数据目录..."
mkdir -p data/databases data/embeddings/cache data/uploads logs

# 初始化数据库
echo "��️ 初始化数据库..."
python -c "
from src.core.config import Config
from src.core.database import init_db
config = Config('configs/development.yaml')
init_db(config)
print('数据库初始化完成')
"

echo "✅ 安装完成！"
echo "运行 'source venv/bin/activate' 激活虚拟环境"
echo "运行 'python src/main.py --mode api' 启动API服务"
