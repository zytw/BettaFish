-- MindSpider表结构 - PostgreSQL版本
-- 基于mindspider_tables.sql转换而来

-- 删除现有表（如果存在）
DROP TABLE IF EXISTS topic_news_relation CASCADE;
DROP TABLE IF EXISTS crawling_tasks CASCADE;
DROP TABLE IF EXISTS daily_news CASCADE;
DROP TABLE IF EXISTS daily_topics CASCADE;

-- 创建daily_topics表
CREATE TABLE daily_topics (
    id SERIAL NOT NULL,
    topic_id VARCHAR(64) NOT NULL,
    topic_name VARCHAR(255) NOT NULL,
    topic_description TEXT,
    keywords TEXT,
    extract_date DATE NOT NULL,
    relevance_score FLOAT DEFAULT NULL,
    news_count INTEGER DEFAULT 0,
    processing_status VARCHAR(16) DEFAULT 'pending',
    add_ts BIGINT NOT NULL,
    last_modify_ts BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (topic_id, extract_date),
    UNIQUE (topic_id)
);

-- 创建索引
CREATE INDEX idx_daily_topics_date ON daily_topics (extract_date);
CREATE INDEX idx_daily_topics_status ON daily_topics (processing_status);
CREATE INDEX idx_daily_topics_score ON daily_topics (relevance_score);

-- 创建daily_news表
CREATE TABLE daily_news (
    id SERIAL NOT NULL,
    news_id VARCHAR(128) NOT NULL,
    source_platform VARCHAR(32) NOT NULL,
    title VARCHAR(500) NOT NULL,
    url VARCHAR(512) DEFAULT NULL,
    description TEXT,
    extra_info TEXT,
    crawl_date DATE NOT NULL,
    rank_position INTEGER DEFAULT NULL,
    add_ts BIGINT NOT NULL,
    last_modify_ts BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (news_id, source_platform, crawl_date),
    UNIQUE (news_id)
);

-- 创建索引
CREATE INDEX idx_daily_news_date ON daily_news (crawl_date);
CREATE INDEX idx_daily_news_platform ON daily_news (source_platform);
CREATE INDEX idx_daily_news_rank ON daily_news (rank_position);

-- 创建crawling_tasks表
CREATE TABLE crawling_tasks (
    id SERIAL NOT NULL,
    task_id VARCHAR(64) NOT NULL,
    topic_id VARCHAR(64) NOT NULL,
    platform VARCHAR(32) NOT NULL,
    search_keywords TEXT NOT NULL,
    task_status VARCHAR(16) DEFAULT 'pending',
    start_time BIGINT DEFAULT NULL,
    end_time BIGINT DEFAULT NULL,
    total_crawled INTEGER DEFAULT 0,
    success_count INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    error_message TEXT,
    config_params TEXT,
    scheduled_date DATE NOT NULL,
    add_ts BIGINT NOT NULL,
    last_modify_ts BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (task_id)
);

-- 创建索引
CREATE INDEX idx_crawling_tasks_topic ON crawling_tasks (topic_id);
CREATE INDEX idx_crawling_tasks_platform ON crawling_tasks (platform);
CREATE INDEX idx_crawling_tasks_status ON crawling_tasks (task_status);
CREATE INDEX idx_crawling_tasks_date ON crawling_tasks (scheduled_date);

-- 创建topic_news_relation表
CREATE TABLE topic_news_relation (
    id SERIAL NOT NULL,
    topic_id VARCHAR(64) NOT NULL,
    news_id VARCHAR(128) NOT NULL,
    relation_score FLOAT DEFAULT NULL,
    extract_date DATE NOT NULL,
    add_ts BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (topic_id, news_id, extract_date)
);

-- 创建索引
CREATE INDEX idx_topic_news_topic ON topic_news_relation (topic_id);
CREATE INDEX idx_topic_news_news ON topic_news_relation (news_id);
CREATE INDEX idx_topic_news_date ON topic_news_relation (extract_date);

-- 添加外键约束（引用业务键）
ALTER TABLE crawling_tasks
ADD CONSTRAINT fk_crawling_tasks_topic
FOREIGN KEY (topic_id) REFERENCES daily_topics(topic_id) ON DELETE CASCADE;

ALTER TABLE topic_news_relation
ADD CONSTRAINT fk_topic_news_topic
FOREIGN KEY (topic_id) REFERENCES daily_topics(topic_id) ON DELETE CASCADE;

ALTER TABLE topic_news_relation
ADD CONSTRAINT fk_topic_news_news
FOREIGN KEY (news_id) REFERENCES daily_news(news_id) ON DELETE CASCADE;

-- 创建复合索引优化查询
CREATE INDEX idx_topic_date_status ON daily_topics (extract_date, processing_status);
CREATE INDEX idx_task_topic_platform ON crawling_tasks (topic_id, platform, task_status);
CREATE INDEX idx_news_date_platform ON daily_news (crawl_date, source_platform);
