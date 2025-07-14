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
