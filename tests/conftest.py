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
