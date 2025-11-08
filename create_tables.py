#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
简单的PostgreSQL表创建脚本
使用同步SQLAlchemy创建数据库表
"""

import os
import sys
from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.dialects.postgresql import UUID
import uuid
from datetime import datetime

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'bettafish',
    'password': 'bettafish',
    'database': 'bettafish'
}

# 创建连接URL
DATABASE_URL = f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"

Base = declarative_base()

class DailyNews(Base):
    """每日新闻表"""
    __tablename__ = 'daily_news'

    id = Column(Integer, primary_key=True, autoincrement=True)
    news_id = Column(String(128), nullable=False, comment='新闻唯一ID')
    source_platform = Column(String(32), nullable=False, comment='新闻源平台')
    title = Column(String(500), nullable=False, comment='新闻标题')
    url = Column(String(512), comment='新闻链接')
    description = Column(Text, comment='新闻描述或摘要')
    extra_info = Column(Text, comment='额外信息')
    crawl_date = Column(DateTime, comment='爬取日期')
    rank_position = Column(Integer, comment='在热榜中的排名位置')
    add_ts = Column(BigInteger, comment='记录添加时间戳')
    last_modify_ts = Column(BigInteger, comment='记录最后修改时间戳')

class DailyTopics(Base):
    """每日话题表"""
    __tablename__ = 'daily_topics'

    id = Column(Integer, primary_key=True, autoincrement=True)
    topic_id = Column(String(64), nullable=False, comment='话题唯一ID')
    topic_name = Column(String(255), nullable=False, comment='话题名称')
    topic_description = Column(Text, comment='话题描述')
    keywords = Column(Text, comment='话题关键词')
    extract_date = Column(DateTime, comment='话题提取日期')
    relevance_score = Column(Float, default=0.0, comment='话题相关性得分')
    news_count = Column(Integer, default=0, comment='关联的新闻数量')
    processing_status = Column(String(16), default='pending', comment='处理状态')
    add_ts = Column(BigInteger, comment='记录添加时间戳')
    last_modify_ts = Column(BigInteger, comment='记录最后修改时间戳')

class TopicNewsRelation(Base):
    """话题新闻关系表"""
    __tablename__ = 'topic_news_relation'

    id = Column(Integer, primary_key=True, autoincrement=True)
    topic_id = Column(String(64), nullable=False, comment='话题ID')
    news_id = Column(String(128), nullable=False, comment='新闻ID')
    relation_score = Column(Float, default=0.0, comment='关联度得分')
    extract_date = Column(DateTime, comment='关联提取日期')
    add_ts = Column(BigInteger, comment='记录添加时间戳')

class CrawlingTasks(Base):
    """爬取任务表"""
    __tablename__ = 'crawling_tasks'

    id = Column(Integer, primary_key=True, autoincrement=True)
    task_id = Column(String(64), nullable=False, comment='任务唯一ID')
    topic_id = Column(String(64), nullable=False, comment='关联的话题ID')
    platform = Column(String(32), nullable=False, comment='目标平台')
    search_keywords = Column(Text, comment='搜索关键词')
    task_status = Column(String(16), default='pending', comment='任务状态')
    start_time = Column(BigInteger, comment='任务开始时间戳')
    end_time = Column(BigInteger, comment='任务结束时间戳')
    total_crawled = Column(Integer, default=0, comment='已爬取内容数量')
    success_count = Column(Integer, default=0, comment='成功爬取数量')
    error_count = Column(Integer, default=0, comment='错误数量')
    error_message = Column(Text, comment='错误信息')
    config_params = Column(Text, comment='爬取配置参数')
    scheduled_date = Column(DateTime, comment='计划执行日期')
    add_ts = Column(BigInteger, comment='记录添加时间戳')
    last_modify_ts = Column(BigInteger, comment='记录最后修改时间戳')

def create_tables():
    """创建所有表"""
    try:
        print("正在连接PostgreSQL数据库...")
        engine = create_engine(DATABASE_URL, echo=True)

        print("正在创建数据库表...")
        Base.metadata.create_all(engine)

        print("✅ 所有数据库表创建成功！")
        return True

    except Exception as e:
        print(f"❌ 创建表时发生错误: {e}")
        return False

if __name__ == "__main__":
    print("=== PostgreSQL 数据库表创建工具 ===")
    print(f"数据库配置: {DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}")

    success = create_tables()

    if success:
        print("\n🎉 数据库表创建完成！")
        sys.exit(0)
    else:
        print("\n💥 数据库表创建失败！")
        sys.exit(1)
