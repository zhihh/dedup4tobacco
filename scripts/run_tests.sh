#!/bin/bash

echo "🧪 运行测试..."

# 激活虚拟环境
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
fi

# 运行测试
python -m pytest tests/ -v --cov=src --cov-report=html --cov-report=term

echo "✅ 测试完成！"
echo "查看覆盖率报告: htmlcov/index.html"
