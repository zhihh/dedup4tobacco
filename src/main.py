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
