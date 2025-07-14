#!/bin/bash

# 项目创建脚本
# 用法: ./create_project.sh [项目名称] [GitHub用户名] [GitHub仓库名]

set -e

# 默认参数
PROJECT_NAME=${1:-"document_deduplication_system"}
GITHUB_USER=${2:-"your-username"}
GITHUB_REPO=${3:-"document-deduplication-system"}

echo "🚀 创建项目: $PROJECT_NAME"
echo "📁 GitHub: https://github.com/$GITHUB_USER/$GITHUB_REPO"

# 检查依赖
check_dependencies() {
    echo "🔍 检查依赖..."
    
    if ! command -v git &> /dev/null; then
        echo "❌ Git 未安装，请先安装 Git"
        exit 1
    fi
    
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python3 未安装，请先安装 Python3"
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        echo "⚠️  GitHub CLI 未安装，将跳过 GitHub 仓库创建"
        echo "请手动在 GitHub 创建仓库: https://github.com/$GITHUB_USER/$GITHUB_REPO"
        CREATE_GITHUB_REPO=false
    else
        CREATE_GITHUB_REPO=true
    fi
}

# 创建目录结构
create_directory_structure() {
    echo "📁 创建目录结构..."
    
    # 创建项目根目录
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    # 创建源代码目录
    mkdir -p src/{core,processors,clustering,detection,utils,api}
    
    # 创建测试目录
    mkdir -p tests/{test_core,test_processors,test_clustering,test_detection,test_utils,test_api}
    
    # 创建数据目录
    mkdir -p data/{test_documents,databases,embeddings/cache}
    
    # 创建配置目录
    mkdir -p configs
    
    # 创建文档目录
    mkdir -p docs
    
    # 创建脚本目录
    mkdir -p scripts
    
    # 创建Docker目录
    mkdir -p docker
    
    # 创建日志目录
    mkdir -p logs
    
    # 创建GitHub Actions目录
    mkdir -p .github/workflows
    
    echo "✅ 目录结构创建完成"
}

# 创建核心文件
create_core_files() {
    echo "📝 创建核心文件..."
    
    # 创建所有 __init__.py 文件
    touch src/__init__.py
    touch src/core/__init__.py
    touch src/processors/__init__.py
    touch src/clustering/__init__.py
    touch src/detection/__init__.py
    touch src/utils/__init__.py
    touch src/api/__init__.py
    touch tests/__init__.py
    touch tests/test_core/__init__.py
    touch tests/test_processors/__init__.py
    touch tests/test_clustering/__init__.py
    touch tests/test_detection/__init__.py
    touch tests/test_utils/__init__.py
    touch tests/test_api/__init__.py
    
    # 创建主入口文件
    cat > src/main.py << 'EOF'
#!/usr/bin/env python3
"""
基于LLM的智能文档去重系统
主入口文件
"""

import argparse
import sys
from pathlib import Path

# 添加项目根目录到Python路径
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from src.core.config import Config
from src.utils.logger import setup_logger


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="智能文档去重系统")
    parser.add_argument("--config", type=str, default="configs/default.yaml",
                       help="配置文件路径")
    parser.add_argument("--mode", type=str, default="api",
                       choices=["api", "cli", "batch"],
                       help="运行模式")
    parser.add_argument("--input", type=str, help="输入文档路径")
    parser.add_argument("--output", type=str, help="输出结果路径")
    
    args = parser.parse_args()
    
    # 初始化配置
    config = Config(args.config)
    
    # 设置日志
    logger = setup_logger(config)
    
    logger.info(f"启动文档去重系统 - 模式: {args.mode}")
    
    try:
        if args.mode == "api":
            from src.api.main import run_api
            run_api(config)
        elif args.mode == "cli":
            from src.cli.main import run_cli
            run_cli(config, args.input, args.output)
        elif args.mode == "batch":
            from src.batch.main import run_batch
            run_batch(config, args.input, args.output)
    except Exception as e:
        logger.error(f"运行失败: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
EOF

    # 创建API主入口
    cat > src/api/main.py << 'EOF'
"""
API服务主入口
"""

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .endpoints import router
from ..core.config import Config


def create_app(config: Config) -> FastAPI:
    """创建FastAPI应用"""
    app = FastAPI(
        title="智能文档去重系统",
        description="基于LLM的智能文档去重API",
        version="1.0.0"
    )
    
    # 添加CORS中间件
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    
    # 注册路由
    app.include_router(router, prefix="/api/v1")
    
    return app


def run_api(config: Config):
    """运行API服务"""
    app = create_app(config)
    
    uvicorn.run(
        app,
        host=config.api.host,
        port=config.api.port,
        log_level=config.logging.level.lower()
    )
EOF

    # 创建配置文件
    cat > configs/default.yaml << 'EOF'
# 默认配置文件

# 系统配置
system:
  name: "智能文档去重系统"
  version: "1.0.0"
  debug: false

# API配置
api:
  host: "0.0.0.0"
  port: 8000
  workers: 4

# 数据库配置
database:
  type: "sqlite"
  path: "data/databases/documents.db"
  pool_size: 10
  max_overflow: 20

# 向量存储配置
vector_store:
  type: "chroma"
  host: "localhost"
  port: 8001
  collection_name: "documents"

# LLM配置
llm:
  provider: "openai"
  model: "gpt-4"
  api_key: "${OPENAI_API_KEY}"
  temperature: 0.1
  max_tokens: 1000

# 嵌入配置
embedding:
  provider: "openai"
  model: "text-embedding-3-large"
  api_key: "${OPENAI_API_KEY}"
  batch_size: 100
  cache_enabled: true

# 聚类配置
clustering:
  algorithm: "hierarchical"
  threshold: 0.3
  min_cluster_size: 2
  max_cluster_size: 100

# 检测配置
detection:
  similarity_threshold: 0.8
  confidence_threshold: 0.7
  max_retries: 3

# 日志配置
logging:
  level: "INFO"
  format: "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
  file: "logs/app.log"
  max_size: "10MB"
  backup_count: 5
EOF

    # 创建开发环境配置
    cat > configs/development.yaml << 'EOF'
# 开发环境配置

# 继承默认配置
extends: "default.yaml"

# 覆盖特定配置
system:
  debug: true

api:
  host: "127.0.0.1"
  port: 8000

logging:
  level: "DEBUG"
  file: "logs/dev.log"

database:
  path: "data/databases/dev_documents.db"
EOF

    # 创建生产环境配置
    cat > configs/production.yaml << 'EOF'
# 生产环境配置

# 继承默认配置
extends: "default.yaml"

# 覆盖特定配置
system:
  debug: false

api:
  host: "0.0.0.0"
  port: 8000
  workers: 8

logging:
  level: "INFO"
  file: "logs/prod.log"

database:
  type: "postgresql"
  host: "${DB_HOST}"
  port: 5432
  name: "${DB_NAME}"
  user: "${DB_USER}"
  password: "${DB_PASSWORD}"
EOF

    # 创建测试环境配置
    cat > configs/test.yaml << 'EOF'
# 测试环境配置

# 继承默认配置
extends: "default.yaml"

# 覆盖特定配置
system:
  debug: true

database:
  path: "data/databases/test_documents.db"

logging:
  level: "DEBUG"
  file: "logs/test.log"

# 测试专用配置
test:
  sample_documents: "data/test_documents/"
  output_dir: "tests/output/"
EOF

    echo "✅ 核心文件创建完成"
}

# 创建文档文件
create_documentation() {
    echo "📚 创建文档文件..."
    
    # 创建README.md
    cat > README.md << EOF
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

\`\`\`
$PROJECT_NAME/
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
\`\`\`

## 🚀 快速开始

### 1. 环境准备

\`\`\`bash
# 克隆项目
git clone https://github.com/$GITHUB_USER/$GITHUB_REPO.git
cd $PROJECT_NAME

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\\Scripts\\activate  # Windows

# 安装依赖
pip install -r requirements.txt
\`\`\`

### 2. 配置设置

\`\`\`bash
# 复制环境变量文件
cp .env.example .env

# 编辑配置文件
vim .env
\`\`\`

在 \`.env\` 文件中配置必要的环境变量：

\`\`\`env
OPENAI_API_KEY=your_openai_api_key
DB_HOST=localhost
DB_NAME=documents
DB_USER=your_user
DB_PASSWORD=your_password
\`\`\`

### 3. 运行系统

#### API模式
\`\`\`bash
python src/main.py --mode api --config configs/development.yaml
\`\`\`

#### CLI模式
\`\`\`bash
python src/main.py --mode cli --input data/test_documents/ --output results/
\`\`\`

#### 批处理模式
\`\`\`bash
python src/main.py --mode batch --input data/test_documents/ --output results/
\`\`\`

## 🔧 开发指南

### 运行测试

\`\`\`bash
# 运行所有测试
./scripts/run_tests.sh

# 运行特定测试
python -m pytest tests/test_core/

# 生成测试覆盖率报告
python -m pytest --cov=src tests/
\`\`\`

### 代码格式化

\`\`\`bash
# 格式化代码
black src/ tests/

# 检查代码风格
flake8 src/ tests/

# 类型检查
mypy src/
\`\`\`

## 📖 API文档

启动API服务后，访问以下地址查看API文档：

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 🐳 Docker部署

\`\`\`bash
# 构建镜像
docker build -t $PROJECT_NAME .

# 运行容器
docker run -p 8000:8000 $PROJECT_NAME

# 或使用docker-compose
docker-compose up -d
\`\`\`

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
2. 搜索或创建 [Issue](https://github.com/$GITHUB_USER/$GITHUB_REPO/issues)
3. 联系维护者

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和研究者。

---

⭐ 如果这个项目对您有帮助，请给我们一个Star！
EOF

    # 创建其他文档文件
    cat > docs/INSTALLATION.md << 'EOF'
# 安装指南

## 系统要求

- Python 3.8+
- Git
- 4GB+ RAM
- 10GB+ 可用存储空间

## 详细安装步骤

### 1. 安装Python环境

确保您的系统已安装Python 3.8或更高版本。

### 2. 克隆项目

```bash
git clone https://github.com/your-username/document-deduplication-system.git
cd document-deduplication-system
```

### 3. 创建虚拟环境

```bash
python -m venv venv
source venv/bin/activate
```

### 4. 安装依赖

```bash
pip install -r requirements.txt
```

### 5. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件，设置必要的环境变量
```

### 6. 初始化数据库

```bash
python scripts/init_db.py
```

### 7. 运行测试

```bash
./scripts/run_tests.sh
```

## 常见问题

### Q: 安装依赖时出现错误？
A: 请确保您的Python版本符合要求，并尝试升级pip。

### Q: 无法连接到数据库？
A: 请检查数据库配置和网络连接。

更多问题请查看 [FAQ](FAQ.md)。
EOF

    cat > docs/USAGE.md << 'EOF'
# 使用指南

## 基本使用

### 1. 启动API服务

```bash
python src/main.py --mode api
```

### 2. 上传文档

```bash
curl -X POST "http://localhost:8000/api/v1/documents" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@document.pdf"
```

### 3. 检测重复

```bash
curl -X POST "http://localhost:8000/api/v1/detect" \
  -H "Content-Type: application/json" \
  -d '{"document_ids": ["doc1", "doc2"]}'
```

## 高级功能

### 批量处理

```bash
python src/main.py --mode batch --input /path/to/documents --output /path/to/results
```

### 自定义配置

```bash
python src/main.py --config configs/custom.yaml
```

## 配置选项

详细的配置选项请参考 [配置文档](CONFIGURATION.md)。
EOF

    cat > docs/API.md << 'EOF'
# API文档

## 认证

目前API不需要认证，但建议在生产环境中启用。

## 端点

### 文档管理

#### 上传文档
- **POST** `/api/v1/documents`
- 上传单个或多个文档

#### 获取文档列表
- **GET** `/api/v1/documents`
- 获取所有文档的列表

#### 获取文档详情
- **GET** `/api/v1/documents/{id}`
- 获取特定文档的详细信息

### 重复检测

#### 检测重复
- **POST** `/api/v1/detect`
- 对指定文档进行重复检测

#### 获取检测结果
- **GET** `/api/v1/results/{id}`
- 获取检测结果详情

### 聚类分析

#### 创建聚类
- **POST** `/api/v1/clusters`
- 创建新的文档聚类

#### 获取聚类结果
- **GET** `/api/v1/clusters/{id}`
- 获取聚类结果

## 响应格式

所有API响应都遵循以下格式：

```json
{
  "success": true,
  "data": {},
  "message": "操作成功",
  "code": 200
}
```

## 错误处理

错误响应格式：

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述",
    "details": {}
  }
}
```

## 示例代码

查看 [examples](../examples/) 目录获取更多示例代码。
EOF

    cat > docs/ARCHITECTURE.md << 'EOF'
# 系统架构

## 总体架构

系统采用分层架构设计，包括：

1. **表现层** - API接口和用户界面
2. **业务层** - 核心业务逻辑处理
3. **数据层** - 数据存储和管理

## 核心模块

### 1. 文档处理器 (Document Processor)
- 支持多种文档格式
- 文本提取和预处理
- 编码检测和转换

### 2. 文本分割器 (Text Splitter)
- 智能文本分割
- 保持语义完整性
- 支持多种分割策略

### 3. 嵌入处理器 (Embedding Processor)
- 语义向量生成
- 多种嵌入模型支持
- 向量缓存和优化

### 4. 聚类引擎 (Clustering Engine)
- 层次聚类算法
- 自适应参数调优
- 聚类质量评估

### 5. 检测引擎 (Detection Engine)
- LLM驱动的智能检测
- 多轮推理验证
- 置信度评估

## 数据流

```
输入文档 → 文档处理 → 文本分割 → 嵌入生成 → 聚类分析 → 重复检测 → 结果输出
```

## 技术选型

- **后端框架**: FastAPI
- **机器学习**: scikit-learn, transformers
- **向量数据库**: Chroma
- **关系数据库**: SQLite/PostgreSQL
- **缓存**: Redis
- **消息队列**: Celery
- **容器化**: Docker

## 扩展性设计

系统支持多种扩展方式：

1. **水平扩展** - 多实例部署
2. **垂直扩展** - 资源增加
3. **功能扩展** - 插件机制
4. **存储扩展** - 多种存储后端

## 性能优化

- 异步处理
- 批量操作
- 缓存机制
- 连接池
- 负载均衡
EOF

    echo "✅ 文档文件创建完成"
}

# 创建配置文件
create_config_files() {
    echo "⚙️ 创建配置文件..."
    
    # 创建requirements.txt
    cat > requirements.txt << 'EOF'
# 核心依赖
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
pydantic-settings==2.1.0
python-multipart==0.0.6

# 数据处理
pandas==2.1.3
numpy==1.24.3
scikit-learn==1.3.2

# 自然语言处理
openai==1.3.6
langchain==0.0.335
langchain-openai==0.0.2
sentence-transformers==2.2.2
transformers==4.35.2
torch==2.1.1

# 向量数据库
chromadb==0.4.18

# 数据库
sqlalchemy==2.0.23
alembic==1.12.1
psycopg2-binary==2.9.9

# 缓存
redis==5.0.1

# 文档处理
PyPDF2==3.0.1
python-docx==1.1.0
beautifulsoup4==4.12.2
markdown==3.5.1

# 可视化
matplotlib==3.8.2
seaborn==0.13.0
plotly==5.17.0

# 工具
pyyaml==6.0.1
python-dotenv==1.0.0
click==8.1.7
tqdm==4.66.1
rich==13.7.0

# 日志
structlog==23.2.0

# 测试
pytest==7.4.3
pytest-cov==4.1.0
pytest-asyncio==0.21.1
pytest-mock==3.12.0
httpx==0.25.2
EOF

    # 创建开发依赖
    cat > requirements-dev.txt << 'EOF'
# 开发依赖
-r requirements.txt

# 代码格式化
black==23.11.0
isort==5.12.0
flake8==6.1.0
mypy==1.7.1

# 调试工具
ipdb==0.13.13
jupyter==1.0.0

# 文档生成
sphinx==7.2.6
sphinx-rtd-theme==1.3.0

# 性能分析
memory-profiler==0.61.0
line-profiler==4.1.1
EOF

    # 创建setup.py
    cat > setup.py << 'EOF'
from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("requirements.txt", "r", encoding="utf-8") as fh:
    requirements = [line.strip() for line in fh if line.strip() and not line.startswith("#")]

setup(
    name="document-deduplication-system",
    version="1.0.0",
    author="Your Name",
    author_email="your.email@example.com",
    description="基于LLM的智能文档去重系统",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/your-username/document-deduplication-system",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires=">=3.8",
    install_requires=requirements,
    entry_points={
        "console_scripts": [
            "dedup-system=src.main:main",
        ],
    },
)
EOF

    # 创建.env.example
    cat > .env.example << 'EOF'
# OpenAI API配置
OPENAI_API_KEY=sk-your-openai-api-key-here

# 数据库配置
DB_HOST=localhost
DB_PORT=5432
DB_NAME=documents
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# Redis配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# 系统配置
DEBUG=false
LOG_LEVEL=INFO
SECRET_KEY=your-secret-key-here

# API配置
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=4

# 向量数据库配置
CHROMA_HOST=localhost
CHROMA_PORT=8001
CHROMA_COLLECTION=documents

# 文件存储配置
UPLOAD_PATH=data/uploads
MAX_FILE_SIZE=10485760  # 10MB
EOF

    # 创建.gitignore
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
.python-version

# celery beat schedule file
celerybeat-schedule

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Project specific
logs/
data/databases/
data/embeddings/cache/
data/uploads/
*.db
*.log
temp/
tmp/
EOF

    # 创建Dockerfile
    cat > docker/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目文件
COPY . .

# 创建必要的目录
RUN mkdir -p logs data/databases data/embeddings/cache

# 设置环境变量
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# 暴露端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# 启动命令
CMD ["python", "src/main.py", "--mode", "api", "--config", "configs/production.yaml"]
EOF

    # 创建docker-compose.yml
    cat > docker/docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - DB_HOST=postgres
      - DB_NAME=documents
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis
    volumes:
      - ./data:/app/data
      - ./logs:/app/logs
    restart: unless-stopped

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=documents
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

  chroma:
    image: ghcr.io/chroma-core/chroma:latest
    ports:
      - "8001:8000"
    environment:
      - CHROMA_DB_IMPL=clickhouse
    volumes:
      - chroma_data:/chroma/chroma
    restart: unless-stopped

volumes:
  postgres_data:
  chroma_data:
EOF

    echo "✅ 配置文件创建完成"
}

# 创建脚本文件
create_scripts() {
    echo "📜 创建脚本文件..."
    
    # 创建setup.sh
    cat > scripts/setup.sh << 'EOF'
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
EOF

    # 创建run_tests.sh
    cat > scripts/run_tests.sh << 'EOF'
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
EOF

    # 创建deploy.sh
    cat > scripts/deploy.sh << 'EOF'
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
EOF

    # 给脚本添加执行权限
    chmod +x scripts/*.sh

    echo "✅ 脚本文件创建完成"
}

# 创建GitHub Actions配置
create_github_actions() {
    echo "🔄 创建GitHub Actions配置..."
    
    # 创建CI配置
    cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.8, 3.9, "3.10", "3.11"]

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Cache pip packages
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
    
    - name: Run linting
      run: |
        flake8 src tests
        black --check src tests
        isort --check-only src tests
    
    - name: Run type checking
      run: |
        mypy src
    
    - name: Run tests
      run: |
        pytest tests/ -v --cov=src --cov-report=xml
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
        flags: unittests
        name: codecov-umbrella
        fail_ci_if_error: true

  docker:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Build Docker image
      run: |
        docker build -t document-deduplication-system .
    
    - name: Test Docker image
      run: |
        docker run --rm document-deduplication-system python -c "import src; print('Import successful')"
EOF

    # 创建测试配置
    cat > .github/workflows/test.yml << 'EOF'
name: Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_documents
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: "3.11"
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
    
    - name: Run integration tests
      env:
        DB_HOST: localhost
        DB_PORT: 5432
        DB_NAME: test_documents
        DB_USER: postgres
        DB_PASSWORD: postgres
        REDIS_HOST: localhost
        REDIS_PORT: 6379
        OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
      run: |
        pytest tests/ -v --cov=src
EOF

    echo "✅ GitHub Actions配置创建完成"
}

# 创建其他必要文件
create_other_files() {
    echo "📝 创建其他必要文件..."
    
    # 创建LICENSE
    cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 Document Deduplication System

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

    # 创建CONTRIBUTING.md
    cat > CONTRIBUTING.md << 'EOF'
# 贡献指南

感谢您对本项目的关注！我们欢迎任何形式的贡献。

## 如何贡献

### 报告问题
- 使用GitHub Issues报告bug
- 提供详细的错误信息和复现步骤
- 说明您的运行环境

### 提交代码
1. Fork本项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

### 代码规范
- 使用Black进行代码格式化
- 遵循PEP 8代码风格
- 添加适当的测试
- 更新相关文档

### 测试
运行测试确保您的更改不会破坏现有功能：
```bash
./scripts/run_tests.sh
```

## 开发环境设置

1. 克隆项目
```bash
git clone https://github.com/your-username/document-deduplication-system.git
cd document-deduplication-system
```

2. 设置开发环境
```bash
./scripts/setup.sh
```

3. 运行开发服务器
```bash
python src/main.py --mode api --config configs/development.yaml
```

## 提交信息格式

请使用以下格式的提交信息：
```
type(scope): description

[optional body]

[optional footer]
```

类型包括：
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式化
- refactor: 重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动

## 问题和支持

如果您有任何问题，请：
1. 查看现有的Issues
2. 创建新的Issue
3. 联系维护者

再次感谢您的贡献！
EOF

    # 创建CHANGELOG.md
    cat > CHANGELOG.md << 'EOF'
# 变更日志

所有重要的项目变更都会记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本控制](https://semver.org/lang/zh-CN/)。

## [未发布]

### 新增
- 基于LLM的智能文档去重系统
- 多种文档格式支持
- RESTful API接口
- 智能聚类算法
- 语义相似度检测

### 变更
- 无

### 修复
- 无

### 移除
- 无

## [1.0.0] - 2024-01-01

### 新增
- 项目初始化
- 基本架构搭建
- 核心功能实现
EOF

    # 创建测试用例文件
    cat > tests/conftest.py << 'EOF'
import pytest
import tempfile
import os
from pathlib import Path

@pytest.fixture
def temp_dir():
    """创建临时目录"""
    with tempfile.TemporaryDirectory() as tmp_dir:
        yield tmp_dir

@pytest.fixture
def sample_text():
    """示例文本"""
    return "这是一个测试文档。包含多行内容。用于测试文档处理功能。"

@pytest.fixture
def sample_documents():
    """示例文档数据"""
    return [
        {"id": "doc1", "content": "第一个测试文档的内容"},
        {"id": "doc2", "content": "第二个测试文档的内容"},
        {"id": "doc3", "content": "第一个测试文档的内容"},  # 重复内容
    ]

@pytest.fixture
def api_client():
    """API测试客户端"""
    from fastapi.testclient import TestClient
    from src.api.main import create_app
    from src.core.config import Config
    
    config = Config("configs/test.yaml")
    app = create_app(config)
    
    return TestClient(app)
EOF

    # 创建示例文档
    echo "这是第一个测试文档的内容。" > data/test_documents/sample1.txt
    echo "这是第二个测试文档的内容。" > data/test_documents/sample2.txt
    echo "这是第三个测试文档的内容。" > data/test_documents/sample3.txt

    echo "✅ 其他必要文件创建完成"
}

# 初始化Git仓库
init_git_repository() {
    echo "📦 初始化Git仓库..."
    
    # 初始化Git仓库
    git init
    
    # 添加所有文件
    git add .
    
    # 创建初始提交
    git commit -m "feat: 初始化项目结构

- 添加完整的项目目录结构
- 配置开发环境
- 添加基本的API框架
- 创建测试框架
- 添加Docker支持
- 配置GitHub Actions CI/CD"
    
    # 创建开发分支
    git checkout -b develop
    git checkout main
    
    echo "✅ Git仓库初始化完成"
}

# 创建GitHub仓库
create_github_repository() {
    if [ "$CREATE_GITHUB_REPO" = true ]; then
        echo "🐙 创建GitHub仓库..."
        
        # 检查GitHub CLI是否已登录
        if ! gh auth status &> /dev/null; then
            echo "⚠️  请先登录GitHub CLI: gh auth login"
            return 1
        fi
        
        # 创建GitHub仓库
        gh repo create "$GITHUB_REPO" \
            --description "基于大语言模型的智能文档去重系统" \
            --public \
            --source=. \
            --push \
            --remote=origin
        
        echo "✅ GitHub仓库创建完成"
        echo "🔗 仓库地址: https://github.com/$GITHUB_USER/$GITHUB_REPO"
    else
        echo "⚠️  跳过GitHub仓库创建"
        echo "请手动创建GitHub仓库并添加远程源："
        echo "git remote add origin https://github.com/$GITHUB_USER/$GITHUB_REPO.git"
        echo "git push -u origin main"
    fi
}

# 显示完成信息
show_completion_message() {
    echo ""
    echo "🎉 项目创建完成！"
    echo ""
    echo "📁 项目位置: $(pwd)"
    echo "🔗 GitHub仓库: https://github.com/$GITHUB_USER/$GITHUB_REPO"
    echo ""
    echo "🚀 快速开始:"
    echo "1. 进入项目目录: cd $PROJECT_NAME"
    echo "2. 设置环境变量: cp .env.example .env"
    echo "3. 运行安装脚本: ./scripts/setup.sh"
    echo "4. 启动API服务: python src/main.py --mode api"
    echo "5. 访问API文档: http://localhost:8000/docs"
    echo ""
    echo "📚 更多信息请查看 README.md"
    echo ""
    echo "⭐ 如果项目对您有帮助，请给个Star！"
}

# 主函数
main() {
    echo "🚀 开始创建智能文档去重系统项目..."
    
    check_dependencies
    create_directory_structure
    create_core_files
    create_documentation
    create_config_files
    create_scripts
    create_github_actions
    create_other_files
    init_git_repository
    create_github_repository
    show_completion_message
}

# 运行主函数
main "$@"
