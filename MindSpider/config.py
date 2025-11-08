# -*- coding: utf-8 -*-
"""
存储数据库连接信息和API密钥
"""

from pydantic_settings import BaseSettings
from typing import Optional
from pydantic import Field
from pathlib import Path

# 计算 .env 优先级：优先当前工作目录，其次项目根目录（MindSpider 的上级目录）
PROJECT_ROOT: Path = Path(__file__).resolve().parents[1]
CWD_ENV: Path = Path.cwd() / ".env"
ENV_FILE: str = str(CWD_ENV if CWD_ENV.exists() else (PROJECT_ROOT / ".env"))

class Settings(BaseSettings):
    """全局配置管理，优先从环境变量和.env加载。支持MySQL/PostgreSQL统一数据库参数命名。"""
    # PostgreSQL作为默认数据库
    DB_DIALECT: str = Field("postgresql", description="数据库类型，支持'mysql'或'postgresql'")
    DB_HOST: str = Field("bettafish-db", description="数据库主机名，PostgreSQL容器服务名")
    DB_PORT: int = Field(5432, description="数据库端口号，PostgreSQL默认为5432")
    DB_USER: str = Field("bettafish", description="数据库用户名")
    DB_PASSWORD: str = Field("bettafish", description="数据库密码")
    DB_NAME: str = Field("bettafish", description="数据库名称")
    # 注意：PostgreSQL不需要DB_CHARSET参数，此参数仅用于MySQL兼容性
    DB_CHARSET: str = Field("", description="数据库字符集，PostgreSQL不需要此参数")
    MINDSPIDER_API_KEY: Optional[str] = Field(None, description="MINDSPIDER API密钥")
    MINDSPIDER_BASE_URL: Optional[str] = Field("https://api.deepseek.com", description="MINDSPIDER API基础URL，推荐deepseek-chat模型使用https://api.deepseek.com")
    MINDSPIDER_MODEL_NAME: Optional[str] = Field("deepseek-chat", description="MINDSPIDER API模型名称, 推荐deepseek-chat")

    class Config:
        env_file = ENV_FILE
        env_prefix = ""
        case_sensitive = False
        extra = "allow"

settings = Settings()
