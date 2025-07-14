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
