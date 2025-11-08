# BettaFish 信息源扩展使用指南

## 概述

BettaFish 已经扩展了多个信息源，增强了舆情分析能力。本指南提供了所有新增信息源的详细使用示例。

## 新增信息源一览

### QueryEngine（查询引擎）
- **Google Custom Search API** - 增强网络搜索
- **Semantic Scholar** - 学术论文检索
- **Reddit API** - 社交媒体讨论
- **HackerNews** - 科技新闻搜索
- **ArXiv** - 学术预印本搜索

### MediaEngine（媒体引擎）
- **NewsAPI** - 全球新闻聚合
- **RSS Feed Reader** - 博客和新闻订阅
- **YouTube Data API** - 视频内容分析

### InsightEngine（洞察引擎）
- **Alpha Vantage** - 金融数据
- **GDELT Project** - 全球事件检测

## 快速开始

### 1. 环境配置

在 `.env` 文件中配置相应的API密钥：

```bash
# NewsAPI - 全球新闻聚合
NEWSAPI_API_KEY=your_newsapi_key_here

# Google Custom Search API
GOOGLE_SEARCH_API_KEY=your_google_search_api_key
GOOGLE_SEARCH_CSE_ID=your_google_cse_id

# Alpha Vantage - 金融数据
ALPHAVANTAGE_API_KEY=your_alphavantage_key

# Semantic Scholar - 学术论文
SEMANTIC_SCHOLAR_API_KEY=your_semantic_scholar_key

# Reddit API
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_client_secret

# YouTube Data API
YOUTUBE_API_KEY=your_youtube_api_key
```

### 2. API密钥申请指南

#### Google Custom Search API
1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建新项目或选择现有项目
3. 启用 "Custom Search API"
4. 创建凭据（API密钥）
5. 访问 [Programmable Search Engine](https://cse.google.com/) 创建搜索引擎
6. 获取搜索引擎ID (CSE ID)

#### NewsAPI
1. 访问 [NewsAPI.org](https://newsapi.org/)
2. 注册免费账户
3. 获取API密钥（免费版限制：1000次请求/天）

#### Alpha Vantage
1. 访问 [Alpha Vantage](https://www.alphavantage.co/)
2. 注册免费账户
3. 获取API密钥（免费版限制：5次请求/分钟）

#### Semantic Scholar
1. 访问 [Semantic Scholar](https://www.semanticscholar.org/)
2. 注册账户
3. 在 [API设置](https://www.semanticscholar.org/product/api#Partner-Form) 中申请API密钥

#### Reddit API
1. 访问 [Reddit Apps](https://www.reddit.com/prefs/apps)
2. 创建新应用（选择 "script" 类型）
3. 获取 Client ID 和 Client Secret

#### YouTube Data API
1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 启用 "YouTube Data API v3"
3. 创建凭据（API密钥）

## 使用示例

### QueryEngine 使用示例

#### 1. 综合搜索引擎

```python
from QueryEngine.tools.search import ComprehensiveSearchEngine

# 初始化搜索引擎
search_engine = ComprehensiveSearchEngine()

# 多源综合搜索
results = search_engine.search_all_sources(
    query="人工智能",
    sources=['tavily', 'google', 'semantic_scholar', 'reddit'],
    max_results=5
)

# 处理结果
for source, items in results.items():
    print(f"\n{source.upper()} ({len(items)} 结果):")
    for item in items:
        print(f"  - {item.title[:60]}...")
```

#### 2. Google自定义搜索

```python
from QueryEngine.tools.search import GoogleCustomSearch

# 初始化Google搜索
google_search = GoogleCustomSearch()

# 执行搜索
results = google_search.search(
    query="Python机器学习教程",
    max_results=10
)

for result in results:
    print(f"标题: {result.title}")
    print(f"链接: {result.url}")
    print(f"摘要: {result.content[:100]}...")
    print("-" * 60)
```

#### 3. 学术论文搜索

```python
from QueryEngine.tools.search import SemanticScholarSearch

# 初始化学术搜索
semantic_search = SemanticScholarSearch()

# 搜索论文
papers = semantic_search.search_papers(
    query="machine learning",
    max_results=10
)

for paper in papers:
    print(f"标题: {paper.title}")
    print(f"摘要: {paper.content[:200]}...")
    print(f"发布日期: {paper.published_date}")
    print(f"链接: {paper.url}")
    print("-" * 60)
```

#### 4. Reddit社区讨论

```python
from QueryEngine.tools.search import RedditSearch

# 初始化Reddit搜索
reddit_search = RedditSearch()

# 搜索帖子
posts = reddit_search.search_posts(
    query="人工智能",
    subreddit="MachineLearning",
    max_results=10
)

for post in posts:
    print(f"标题: {post.title}")
    print(f"内容: {post.content[:200]}...")
    print(f"发布日期: {post.published_date}")
    print(f"链接: {post.url}")
    print("-" * 60)
```

#### 5. HackerNews科技新闻

```python
from QueryEngine.tools.search import HackerNewsSearch

# 初始化HackerNews搜索
hn_search = HackerNewsSearch()

# 搜索故事
stories = hn_search.search_stories(
    query="AI",
    max_results=10
)

for story in stories:
    print(f"标题: {story.title}")
    print(f"链接: {story.url}")
    print("-" * 60)
```

#### 6. ArXiv学术预印本

```python
from QueryEngine.tools.search import ArxivSearch

# 初始化ArXiv搜索
arxiv_search = ArxivSearch()

# 搜索论文
papers = arxiv_search.search_papers(
    query="quantum computing",
    category="quant-ph",
    max_results=10
)

for paper in papers:
    print(f"标题: {paper.title}")
    print(f"摘要: {paper.content[:300]}...")
    print(f"发布日期: {paper.published_date}")
    print(f"PDF链接: {paper.url}")
    print("-" * 60)
```

### MediaEngine 使用示例

#### 1. 多模态内容引擎

```python
from MediaEngine.tools.search import MultimodalContentEngine

# 初始化多模态引擎
multimodal_engine = MultimodalContentEngine()

# 综合媒体搜索
results = multimodal_engine.comprehensive_media_search(
    query="人工智能教育",
    sources=['bocha', 'newsapi', 'rss', 'youtube'],
    max_results=5
)

# 处理结果
for source, data in results.items():
    print(f"\n{source.upper()}:")
    if source == 'bocha_web_results':
        print(f"  网页: {len(data.get('webpages', []))} 项")
        print(f"  图片: {len(data.get('images', []))} 项")
        print(f"  模态卡: {len(data.get('modal_cards', []))} 项")
    else:
        print(f"  项目: {len(data)} 项")
```

#### 2. NewsAPI全球新闻

```python
from MediaEngine.tools.search import NewsAPIClient

# 初始化NewsAPI客户端
news_client = NewsAPIClient()

# 获取头条新闻
headlines = news_client.get_top_headlines(
    query="人工智能",
    country="cn",
    page_size=10
)

for article in headlines:
    print(f"标题: {article.title}")
    print(f"描述: {article.description}")
    print(f"来源: {article.source}")
    print(f"发布时间: {article.published_at}")
    print(f"链接: {article.url}")
    print("-" * 60)
```

#### 3. RSS订阅阅读

```python
from MediaEngine.tools.search import RSSFeedReader

# 初始化RSS阅读器
rss_reader = RSSFeedReader()

# 读取多个订阅源
feed_results = rss_reader.read_multiple_feeds([
    "https://feeds.feedburner.com/oreilly/radar",
    "https://hnrss.org/frontpage"
])

for feed_url, items in feed_results.items():
    print(f"\n订阅源: {feed_url}")
    for item in items[:3]:  # 只显示前3条
        print(f"  标题: {item.title}")
        print(f"  描述: {item.description[:100]}...")
```

#### 4. YouTube视频搜索

```python
from MediaEngine.tools.search import YouTubeDataClient

# 初始化YouTube客户端
youtube_client = YouTubeDataClient()

# 搜索视频
videos = youtube_client.search_videos(
    query="Python教程",
    max_results=10,
    published_after="2024-01-01T00:00:00Z"
)

for video in videos:
    print(f"标题: {video.title}")
    print(f"频道: {video.channel_title}")
    print(f"发布时间: {video.published_at}")
    print(f"视频ID: {video.video_id}")
    print("-" * 60)
```

### InsightEngine 使用示例

#### 1. 综合洞察分析引擎

```python
from InsightEngine.tools.search import ComprehensiveInsightEngine

# 初始化洞察引擎
insight_engine = ComprehensiveInsightEngine()

# 综合分析
analysis_results = insight_engine.comprehensive_analysis(
    query="人工智能",
    financial_symbol="AAPL",
    country_code="US",
    time_period="week"
)

# 处理结果
for source, data in analysis_results.items():
    print(f"\n{source.upper()}:")
    if isinstance(data, list):
        print(f"  找到 {len(data)} 条记录")
    elif data:
        print(f"  数据类型: {type(data).__name__}")
```

#### 2. Alpha Vantage金融数据

```python
from InsightEngine.tools.search import AlphaVantageClient

# 初始化Alpha Vantage客户端
alpha_vantage = AlphaVantageClient()

# 获取股票报价
quote = alpha_vantage.get_quote("AAPL")
if quote:
    print(f"股票代码: {quote.symbol}")
    print(f"价格: ${quote.price}")
    print(f"涨跌幅: {quote.change_percent}%")
    print(f"成交量: {quote.volume}")

# 搜索股票
symbols = alpha_vantage.search_symbol("Apple")
for symbol_info in symbols:
    print(f"代码: {symbol_info['symbol']}")
    print(f"名称: {symbol_info['name']}")
    print(f"地区: {symbol_info['region']}")
```

#### 3. GDELT全球事件

```python
from InsightEngine.tools.search import GDELTClient

# 初始化GDELT客户端
gdelt_client = GDELTClient()

# 搜索全球事件
events = gdelt_client.search_events(
    query="AI technology",
    start_date="2025-01-01",
    end_date="2025-01-31",
    max_events=10
)

for event in events:
    print(f"事件ID: {event.event_id}")
    print(f"日期: {event.event_date}")
    print(f"参与者1: {event.actor1}")
    print(f"参与者2: {event.actor2}")
    print(f"事件代码: {event.event_code}")
    print(f"情感得分: {event.avg_tone}")
    print("-" * 60)
```

## 高级用法

### 1. 错误处理

所有搜索引擎都实现了优雅的错误处理：

```python
try:
    search_engine = ComprehensiveSearchEngine()
    results = search_engine.search_all_sources("人工智能")
except Exception as e:
    print(f"搜索失败: {e}")

# 系统会自动处理：
# - API密钥缺失（显示警告，继续运行）
# - 网络错误（重试机制）
# - 服务不可用（返回空结果）
```

### 2. 自定义配置

```python
from config import settings

# 查看当前配置
print(f"NewsAPI配置: {settings.NEWSAPI_API_KEY}")
print(f"Google搜索配置: {settings.GOOGLE_SEARCH_API_KEY}")
print(f"Alpha Vantage配置: {settings.ALPHAVANTAGE_API_KEY}")

# 设置环境变量
import os
os.environ['NEWSAPI_API_KEY'] = 'your_key_here'
```

### 3. 性能优化

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

# 并行搜索多个源
async def parallel_search():
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = []
        for source in ['tavily', 'google', 'semantic_scholar']:
            future = executor.submit(
                search_engine.search_all_sources,
                query="人工智能",
                sources=[source]
            )
            futures.append(future)

        results = [future.result() for future in futures]
        return results

# 运行并行搜索
results = asyncio.run(parallel_search())
```

### 4. 结果过滤和处理

```python
from datetime import datetime, timedelta

# 过滤最近的结果
def filter_recent_results(results, days=7):
    cutoff_date = datetime.now() - timedelta(days=days)
    filtered = []

    for source, items in results.items():
        for item in items:
            if item.published_date:
                try:
                    pub_date = datetime.strptime(item.published_date, '%Y-%m-%d')
                    if pub_date >= cutoff_date:
                        filtered.append(item)
                except ValueError:
                    continue

    return filtered

# 使用过滤
recent_results = filter_recent_results(results, days=30)
```

## 最佳实践

### 1. API密钥安全
- 永远不要将API密钥提交到版本控制系统
- 使用环境变量或安全的配置管理
- 定期轮换API密钥

### 2. 请求限制
- 遵守API的速率限制
- 使用缓存避免重复请求
- 实现指数退避重试

### 3. 错误处理
- 总是处理API不可用的情况
- 实现优雅降级
- 记录错误日志用于调试

### 4. 数据质量
- 验证API返回的数据
- 清理和标准化数据格式
- 处理重复内容

## 故障排除

### 常见问题

1. **API密钥错误**
   ```
   ValueError: Google Custom Search需要API_KEY和CSE_ID
   ```
   解决：检查.env文件中的API密钥配置

2. **网络连接错误**
   ```
   ConnectionError: HTTPSConnectionPool
   ```
   解决：检查网络连接和防火墙设置

3. **Rate Limit 错误**
   ```
   429 Too Many Requests
   ```
   解决：降低请求频率，使用缓存

4. **依赖包缺失**
   ```
   ImportError: No module named 'tavily'
   ```
   解决：运行 `pip install tavily-python feedparser xmltodict`

### 调试模式

```python
import logging

# 启用详细日志
logging.basicConfig(level=logging.DEBUG)
from loguru import logger

# 查看具体错误
try:
    search_engine = ComprehensiveSearchEngine()
except Exception as e:
    logger.exception(f"初始化失败: {e}")
```

## 扩展指南

### 添加新的信息源

1. 创建新的客户端类
2. 实现标准接口
3. 添加到综合引擎
4. 更新配置
5. 添加文档和示例

### 自定义搜索策略

```python
class CustomSearchStrategy:
    def __init__(self, search_engine):
        self.engine = search_engine

    def intelligent_search(self, query):
        """智能搜索策略"""
        # 根据查询类型选择最佳搜索源
        if self.is_academic_query(query):
            return self.engine.semantic_scholar.search_papers(query)
        elif self.is_financial_query(query):
            return self.engine.alpha_vantage.search_symbol(query)
        else:
            return self.engine.comprehensive_search(query)

    def is_academic_query(self, query):
        academic_keywords = ["论文", "研究", "学术", "paper", "research"]
        return any(keyword in query.lower() for keyword in academic_keywords)

    def is_financial_query(self, query):
        financial_keywords = ["股票", "金融", "股价", "stock", "finance"]
        return any(keyword in query.lower() for keyword in financial_keywords)
```

## 总结

BettaFish 现在支持10个新的信息源，大大增强了舆情分析能力：

**优势：**
- 多源数据融合
- 统一的API接口
- 优雅的错误处理
- 灵活的配置选项

**适用场景：**
- 舆情监测
- 市场分析
- 学术研究
- 竞品分析
- 趋势预测

通过本指南，您可以充分利用这些新功能，构建更强大的分析和洞察系统。
