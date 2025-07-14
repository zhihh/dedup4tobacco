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
