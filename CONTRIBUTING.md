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
