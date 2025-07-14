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
