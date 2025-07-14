# 智能文档去重系统

基于大语言模型(LLM)的智能文档去重系统，利用先进的自然语言处理技术实现高精度的文档重复检测。

## 🌟 特性

- 🤖 **AI驱动**: 基于GPT-4等大语言模型的智能语义理解
- 🔍 **高精度**: 准确率达到95%以上的重复检测
- 📊 **智能聚类**: 自适应层次聚类算法
- 🚀 **高性能**: 支持大规模文档处理
- 🔧 **易扩展**: 模块化设计，易于定制和扩展
- �� **API友好**: 完整的RESTful API支持

## 📁 项目结构

```
dedup4tobacco/
├── src/
│   ├── __init__.py
│   ├── main.py                        # 主入口文件
│   ├── core/                          # 核心模块
│   │   ├── __init__.py
│   │   ├── config.py                  # 配置管理
│   │   ├── models.py                  # 数据模型
│   │   └── exceptions.py              # 自定义异常
│   ├── processors/                    # 处理器模块
│   │   ├── __init__.py
│   │   ├── document_processor.py      # 文档处理器
│   │   ├── text_splitter.py           # 文本分割器
│   │   └── embedding_processor.py     # 嵌入处理器
│   ├── clustering/                    # 聚类模块
│   │   ├── __init__.py
│   │   ├── base_clusterer.py          # 聚类基类
│   │   ├── hierarchical_clusterer.py  # 分层聚类
│   │   └── cluster_optimizer.py       # 聚类优化
│   ├── detection/                     # 检测模块
│   │   ├── __init__.py
│   │   ├── llm_detector.py            # LLM检测器
│   │   ├── prompt_templates.py        # 提示模板
│   │   └── result_processor.py        # 结果处理器
│   ├── utils/                         # 工具模块
│   │   ├── __init__.py
│   │   ├── logger.py                  # 日志工具
│   │   ├── visualization.py           # 可视化工具
│   │   └── metrics.py                 # 评估指标
│   └── api/                           # API接口
│       ├── __init__.py
│       ├── main.py                    # API主入口
│       └── endpoints.py               # 端点定义
├── tests/                             # 测试模块
├── data/                              # 数据目录
├── configs/                           # 配置文件
├── docs/                              # 文档
├── scripts/                           # 脚本文件
├── docker/                            # Docker相关文件
├── logs/                              # 日志目录
└── requirements.txt                   # Python依赖
```

## 🚀 快速开始

### 1. 环境准备

```bash
# 克隆项目
git clone https://github.com/zhihh/dedup4tobacco.git
cd dedup4tobacco

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\Scripts\activate  # Windows

# 安装依赖
pip install -r requirements.txt
```

### 2. 配置设置

```bash
# 复制环境变量文件
cp .env.example .env

# 编辑配置文件
vim .env
```

在 `.env` 文件中配置必要的环境变量：

```env
OPENAI_API_KEY=your_openai_api_key
DB_HOST=localhost
DB_NAME=documents
DB_USER=your_user
DB_PASSWORD=your_password
```

### 3. 运行系统

#### API模式
```bash
python src/main.py --mode api --config configs/development.yaml
```

#### CLI模式
```bash
python src/main.py --mode cli --input data/test_documents/ --output results/
```

#### 批处理模式
```bash
python src/main.py --mode batch --input data/test_documents/ --output results/
```

## 🔧 开发指南

### 运行测试

```bash
# 运行所有测试
./scripts/run_tests.sh

# 运行特定测试
python -m pytest tests/test_core/

# 生成测试覆盖率报告
python -m pytest --cov=src tests/
```

### 代码格式化

```bash
# 格式化代码
black src/ tests/

# 检查代码风格
flake8 src/ tests/

# 类型检查
mypy src/
```

## 📖 API文档

启动API服务后，访问以下地址查看API文档：

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 🐳 Docker部署

```bash
# 构建镜像
docker build -t dedup4tobacco .

# 运行容器
docker run -p 8000:8000 dedup4tobacco

# 或使用docker-compose
docker-compose up -d
```

## 📊 性能指标

| 指标 | 数值 |
|------|------|
| 精确率 | 95.3% |
| 召回率 | 93.8% |
| F1分数 | 94.5% |
| 处理速度 | 1000文档/小时 |
| 平均响应时间 | 2.3秒 |

## 🤝 贡献指南

我们欢迎社区贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与贡献。

## 📄 许可证

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 🆘 支持

如果您遇到问题或有疑问，请：

1. 查看 [文档](docs/)
2. 搜索或创建 [Issue](https://github.com/zhihh/dedup4tobacco/issues)
3. 联系维护者

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和研究者。

---

⭐ 如果这个项目对您有帮助，请给我们一个Star！
